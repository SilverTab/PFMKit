//
//  PFMRequest.m
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Just a thin wrapper around NSURLConnection


#import "PFMRequest.h"

NSString * PFMRequestErrorDomain = @"com.silvercocoa.PFMRequest.ErrorDomain";

@implementation PFMRequest

@synthesize url=_url, responseData=_responseData, headers=_headers, body=_body, method=_method;

- (id)init
{
    if (self = [super init]) {
        self.method = @"GET";
        self.headers = [[NSMutableDictionary alloc] init];
        self.body = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithURL:(NSURL *)anURL
{
    if (self = [self init]) {
        self.url = anURL;
    }
    
    return self;
}

+ (id)requestWithURL:(NSURL *)anURL
{
    return [[self alloc] initWithURL:anURL];
}

- (void)performRequestWithCompletionBlock:(PFMRequestResultBlock)block
{
    //NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // if we have no url... fail
    if (!self.url) {
        NSError *noUrlError = [NSError errorWithDomain:PFMRequestErrorDomain 
                                                  code:ENOURL 
                                              userInfo:[NSDictionary dictionaryWithObject:@"No URL provided" forKey:NSLocalizedDescriptionKey]];
        block(nil, self, noUrlError);
        return;
    }
    
    // Deal with GET right away since it changes the URL...
    if (self.body && self.method == @"GET") {
        // append it to the url...
        
        NSMutableString *currentURL = [[self.url absoluteString] mutableCopy];
        [currentURL appendFormat:@"?%@", [self urlEncodedStringForDictionary:self.body]];
        self.url = [NSURL URLWithString:currentURL];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    if ([self.headers allKeys].count > 0)
        [request setAllHTTPHeaderFields:self.headers];
    
    request.HTTPMethod = self.method;
    
    // deal with POST body
    if (self.body && self.method == @"POST") {
        request.HTTPBody = [[self urlEncodedStringForDictionary:self.body] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    DLOG(@"Performing the requet: %@", self);
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *respData, NSError *error) {
                               if (error) {
                                   // ignore everything else... there's an error!
                                   self.responseData = nil;
                                   block(nil, self, error);
                               } else {
                                   // ok no errors on the request, try to put into JSON
                                   self.responseData = respData;
                                   NSError *jsonError = nil;
                                   id jsonResult = [NSJSONSerialization JSONObjectWithData:self.responseData 
                                                                                   options:0 
                                                                                     error:&jsonError];
                                   if (jsonError) {
                                       // Error in JSON conversion, call our callback and let
                                       // them know
                                       block(nil, self, jsonError);
                                   } else {
                                       block(jsonResult, self, nil);
                                   }
                               }
                               
                           }];
}

- (void)performRequestOnURL:(NSURL *)anURL withCompletionBlock:(PFMRequestResultBlock)block 
{
    self.url = anURL;
    [self performRequestWithCompletionBlock:block];
}

- (NSString *)urlEncodedStringForDictionary:(NSDictionary *)aDictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (id key in aDictionary) {
        id value = [aDictionary objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", 
                          [self urlEscapeString:key], 
                          [self urlEscapeString:value]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString:@"&"];
}

-(NSString*)urlEscapeString:(NSString *)unencodedString 
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Request URL: %@\nHeaders: %@, Data: %@", self.url, self.headers, self.body];
}



@end
