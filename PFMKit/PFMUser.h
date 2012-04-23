//
//  PFMUser.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMObject.h"

@interface PFMUser : PFMObject {
    BOOL userDataAvailable;
}

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *sessionToken;

+ (PFMUser *)user;
+ (PFMUser *)currentUser;
+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PFMUserResultBlock)block;
- (void)signUpInBackgroundWithBlock:(PFMBooleanResultBlock)block;

- (BOOL)isAuthenticated;


@end
