//
//  PFMRequest.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFMConstants.h"

@class PFMRequest;
typedef void (^PFMRequestResultBlock)(id data, PFMRequest *request, NSError *error); 


@interface PFMRequest : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSMutableDictionary *body;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSData *jsonData;

+ (id)requestWithURL:(NSURL *)anURL;
- (id)initWithURL:(NSURL *)anURL;

- (void)performRequestWithCompletionBlock:(PFMRequestResultBlock)block;
- (void)performRequestOnURL:(NSURL *)anURL withCompletionBlock:(PFMRequestResultBlock)block;


// utility stuff, can still be useful to others...
-(NSString*)urlEscapeString:(NSString *)unencodedString;
- (NSString *)urlEncodedStringForDictionary:(NSDictionary *)aDictionary;

@end
