//
//  PFMUser.m
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMUser.h"
#import "PFMAPIRequest.h"

@interface PFMUser()
@property (nonatomic) BOOL authenticated;

- (void)saveAsCurrentUser;
@end

@implementation PFMUser

@synthesize sessionToken=_sessionToken, username=_username, password=_password;
@synthesize authenticated=_authenticated, email=_email;


+ (PFMUser *)user
{
    PFMUser *newUser = (PFMUser *)[PFMUser objectWithClassName:@"User"];
    newUser.authenticated = NO;
    return newUser;
}

+ (PFMUser *)currentUser
{
    NSDictionary *userAsDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PFMCurrentUser"];
    if (!userAsDic)
        return nil;
    
    PFMUser *user = [PFMUser user];
    [user setValuesFromDictionary:userAsDic];
    user.authenticated = YES;
    return user;
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PFMUserResultBlock)block;
{
    NSDictionary *settingDictionary = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"PFMKit.framework/Resources/Config.plist"]];
    PFMAPIRequest *loginRequest = [[PFMAPIRequest alloc] initWithApplicationId:[settingDictionary objectForKey:@"ParseApplicationID"]
                                                                        apiKey:[settingDictionary objectForKey:@"ParseRestAPIKey"]];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:username, 
                          @"username",
                          password,
                          @"password",nil];
    [loginRequest.body addEntriesFromDictionary:body];
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
                                 aUser.authenticated = YES;
                                 [aUser saveAsCurrentUser];
                                 block(aUser, error);
                             } else {
                                 block(nil, error);
                             }
                         }];
    
}


- (void)signUpInBackgroundWithBlock:(PFMBooleanResultBlock)block
{
    
}

- (void)setValuesFromDictionary:(NSDictionary *)aDic
{
    NSMutableDictionary *mutableDictionary = [aDic mutableCopy];
    self.username = [aDic objectForKey:@"username"];
    self.email = [aDic objectForKey:@"email"];
    self.sessionToken = [aDic objectForKey:@"sessionToken"];
    [mutableDictionary removeObjectForKey:@"username"];
    [mutableDictionary removeObjectForKey:@"email"];
    [mutableDictionary removeObjectForKey:@"sessionToken"];
    [super setValuesFromDictionary:mutableDictionary];
}

- (BOOL)isDataAvailable
{
    return userDataAvailable;
}

- (BOOL)isAuthenticated
{
    return self.authenticated;
}

#pragma mark - Private stuff...


// Saves a user to disk as the "currentUser"
- (void)saveAsCurrentUser
{
    NSDictionary *userAsDic = [self serializeAsDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:userAsDic forKey:@"PFMCurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)serializeAsDictionary
{
    NSMutableDictionary *userAsDic = [[self serializeAsDictionary] mutableCopy];
    // save the basic info...
    if (self.username)
        [userAsDic setObject:self.username forKey:@"username"];
    if (self.email)
        [userAsDic setObject:self.email forKey:@"email"];
    if (self.sessionToken)
        [userAsDic setObject:self.sessionToken forKey:@"sessionToken"];
    return userAsDic;
}

@end
