//
//  PMObject.h
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PFMConstants.h"

@interface PFMObject : NSObject {
    BOOL dataAvailable;
}

@property (nonatomic, strong) NSString *objectId;
@property (strong,nonatomic, readonly) NSString *className;
@property (strong, nonatomic, readonly) NSDate *createdAt;
@property (strong, nonatomic, readonly) NSDate *updatedAt;
@property (strong, nonatomic) NSMutableDictionary *storage;


#pragma mark - Methods from the iOS parse API

+ (PFMObject *)objectWithClassName:(NSString *)className;
+ (PFMObject *)objectWithoutDataWithClassName:(NSString *)className objectId:(NSString *)objectId;


- (id)initWithClassName:(NSString *)newClassName;

- (void)setValuesFromDictionary:(NSDictionary *)aDic;
- (BOOL)isDataAvailable;

#pragma mark - Methods not from the iOS parse API
- (NSDictionary *)serializeAsDictionary;

@end
