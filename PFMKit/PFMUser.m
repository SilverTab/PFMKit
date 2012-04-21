//
//  PFMUser.m
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMUser.h"
#import "PFMAPIRequest.h"

@implementation PFMUser

@synthesize sessionToken=_sessionToken;

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PFMUserResultBlock)block;
{
    PFMAPIRequest *loginRequest = [[PFMAPIRequest alloc] initWithApplicationId:@"Z0u8MuhkHOei1gwrx6NgxB0HZhODLJIgKZMBVu3p"
                                                                        apiKey:@"Dm1jLvWCaN41ePbALpYHDCe3izRtg5krQ7ZrH81J"];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:username, 
                          @"username",
                          password,
                          @"password",nil];
    loginRequest.body = body;
    
    [loginRequest performRequestWithPath:@"login" 
                         completionBlock:^(id data, PFMRequest *request, NSError *error) {
                             NSLog(@"YAY got a response: %@", data);
                         }];
    
}


@end
