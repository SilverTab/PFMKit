//
//  PFMConstants.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Logging/Debug macros
#ifdef DEBUG
#define DLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLOG(...)
#endif

// Version
#define PARSE_VERSION @"1.0.18"
#define PARSE_API_VERSION @"1"
#define PARSE_BASE_URL @"https://api.parse.com"
// Some constants
extern NSString * PFMRequestErrorDomain;
extern NSString * ParseErrorDomain;

// PFMRequest Errors
enum {
    ENOURL = 1,
    ENOAUTH
};



// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


// Blocks
@class PFMUser;
typedef void (^PFMUserResultBlock)(PFMUser *user, NSError *error);
typedef void (^PFMBooleanResultBlock)(BOOL succeeded, NSError *error);