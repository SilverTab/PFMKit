//
//  PFMConstants.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Version
#define PARSE_VERSION @"1.0.18"
#define PARSE_API_VERSION @"1"
#define PARSE_BASE_URL @"https://api.parse.com"
// Some constants
extern NSString * PFMRequestErrorDomain;


// PFMRequest Errors
enum {
    ENOURL = 1,
    ENOAUTH
};

// Blocks
@class PFMUser;
typedef void (^PFMUserResultBlock)(PFMUser *user, NSError *error);
