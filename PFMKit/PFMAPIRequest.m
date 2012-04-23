//
//  PFMAPIRequest.m
//  PFMKit
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMAPIRequest.h"

NSString * ParseErrorDomain = @"com.parse.ParseRESTAPI.ErrorDomain";


static NSURL* apiURL(void) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/", PARSE_BASE_URL, PARSE_API_VERSION]];
}

@implementation PFMAPIRequest

+ (void)load
{
    @autoreleasepool {
        // simple check to make sure the config is there
        DLOG(@"%@", [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"PFMKit.framework/Resources/Config.plist"]);
        if (![[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"PFMKit.framework/Resources/Config.plist"]) {
            abort(); // Please rename the config file to "Config.plist" in the
            // Framework's resource!
        }
    }
    
}


- (id)init
{
    if (self = [super init]) {
        NSDictionary *settingDictionary = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"PFMKit.framework/Resources/Config.plist"]];
        [self.headers setObject:[settingDictionary objectForKey:@"ParseApplicationID"] forKey:@"X-Parse-Application-Id"];
        [self.headers setObject:[settingDictionary objectForKey:@"ParseRestAPIKey"] forKey:@"X-Parse-REST-API-Key"];
    }
    return self;
}


- (void)performRequestWithPath:(NSString *)path completionBlock:(PFMRequestResultBlock)block
{
    if (![[self headers] objectForKey:@"X-Parse-Application-Id"] || ![[self headers] objectForKey:@"X-Parse-REST-API-Key"]) {
        // abort! we need both...
        NSError *authError = [NSError errorWithDomain:PFMRequestErrorDomain 
                                                 code:ENOAUTH 
                                             userInfo:[NSDictionary dictionaryWithObject:@"API Key or Application ID missing" forKey:NSLocalizedDescriptionKey]];
        block(nil, self, authError);
        return;
        
    }
    
    self.url = [apiURL() URLByAppendingPathComponent:path];
    
    [self performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        if (!error) {
            // intercept Parse's API errors
            if ([(NSDictionary *)data objectForKey:@"error"] &&
                [(NSDictionary *)data objectForKey:@"code"]) {
                NSError *parseAPIError = [NSError errorWithDomain:ParseErrorDomain 
                                                             code:[[(NSDictionary *)data objectForKey:@"code"] integerValue] 
                                                         userInfo:[NSDictionary dictionaryWithObject:[(NSDictionary *)data objectForKey:@"error"] 
                                                                                              forKey:NSLocalizedDescriptionKey]];
                block(nil, self, parseAPIError);
            } else {
                block(data, self, nil);
            }
        } else {
            // propagate the error
            block(nil, self, error);
        }
    }];
    
    
}



@end
