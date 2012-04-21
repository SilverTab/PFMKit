//
//  PFMUser.m
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMUser.h"
#import "PFMAPIRequest.h"
#import "PFMConfig.h"

@implementation PFMUser

@synthesize sessionToken=_sessionToken, username=_username, password=_password;

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PFMUserResultBlock)block;
{
    
    PFMAPIRequest *loginRequest = [[PFMAPIRequest alloc] initWithApplicationId:PARSE_APPLICATION_ID
                                                                        apiKey:PARSE_REST_API_KEY];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:username, 
                          @"username",
                          password,
                          @"password",nil];
    loginRequest.body = body;
    [loginRequest performRequestWithPath:@"login" 
                         completionBlock:^(id data, PFMRequest *request, NSError *error) {
                             if (!error) {
                                 NSMutableDictionary *mutableData = [data mutableCopy];
                                 PFMUser *aUser = (PFMUser *)[PFMUser objectWithoutDataWithClassName:@"User" 
                                                                                 objectId:[data objectForKey:@"objectId"]];
                                 aUser.username = [data objectForKey:@"username"];
                                 aUser.sessionToken = [data objectForKey:@"sessionToken"];
                                 [mutableData removeObjectForKey:@"username"];
                                 [mutableData removeObjectForKey:@"sessionToken"];
                                 [aUser setValuesFromDictionary:mutableData];
                                 
                                 block(aUser, error);
                             } else {
                                 block(nil, error);
                             }
                         }];
    
}


@end
