//
//  PFMAPIRequest.m
//  PFMKit
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMAPIRequest.h"

static NSURL* apiURL(void) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/", PARSE_BASE_URL, PARSE_API_VERSION]];
}

@implementation PFMAPIRequest
@synthesize applictionId=_applictionId, apiKey=_apiKey;


- (id)initWithApplicationId:(NSString *)anAppId apiKey:(NSString *)anApiKey
{
    if (self = [super init]) {
        //self.url = apiURL();
        self.applictionId = anAppId;
        self.apiKey = anApiKey;
    }
    return self;
}

- (void)performRequestWithPath:(NSString *)path completionBlock:(PFMRequestResultBlock)block
{
    if (!self.applictionId || !self.apiKey) {
        // abort! we need both...
        NSError *authError = [NSError errorWithDomain:PFMRequestErrorDomain 
                                                 code:ENOAUTH 
                                             userInfo:[NSDictionary dictionaryWithObject:@"API Key or Application ID missing" forKey:NSLocalizedDescriptionKey]];
        block(nil, self, authError);
        return;
        
    }
    
    self.url = [apiURL() URLByAppendingPathComponent:path];
    [self.headers setObject:self.applictionId forKey:@"X-Parse-Application-Id"];
    [self.headers setObject:self.apiKey forKey:@"X-Parse-REST-API-Key"];
    
    [self performRequestWithCompletionBlock:block];
    
}



@end
