//
//  PMObject.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PFMConstants.h"

@interface PFMObject : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (strong,nonatomic, readonly) NSString *className;
@property (strong, nonatomic, readonly) NSDate *createdAt;


@end
