//
//  PFMUser.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMObject.h"

@interface PFMUser : PFMObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *sessionToken;

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(PFMUserResultBlock)block;


@end
