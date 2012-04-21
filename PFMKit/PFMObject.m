//
//  PMObject.m
//  MacParse
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMObject.h"

@implementation PFMObject

@synthesize objectId=_objectId, className=_className, createdAt=_createdAt, updatedAt=_updatedAt;
@synthesize storage=_storage;

+ (PFMObject *)objectWithClassName:(NSString *)className
{
    return [[self alloc] initWithClassName:className];
}

+ (PFMObject *)objectWithoutDataWithClassName:(NSString *)className objectId:(NSString *)objectId
{
    PFMObject *newObj = [[self alloc] initWithClassName:className];
    newObj.objectId = objectId;
    return newObj;
}

- (id)init
{
    if (self = [super init]) {
        self.storage = [[NSMutableDictionary alloc] init];
        dataAvailable = NO;
    }
    
    return self;
}


- (id)initWithClassName:(NSString *)newClassName
{
    if (self = [self init]) {
        _className = newClassName;
    }
    return self;
}


- (void)setValuesFromDictionary:(NSDictionary *)aDic
{
    for (NSString *key in aDic) {
        if ([key isEqualToString:@"objectId"]) {
            self.objectId = [aDic objectForKey:@"objectId"];
        } else if ([key isEqualToString:@"createdAt"]) {
            _createdAt = [aDic objectForKey:@"createdAt"];
        } else if ([key isEqualToString:@"updatedAt"]) {
            _updatedAt = [aDic objectForKey:@"updatedAt"];
        } else if ([key isEqualToString:@"className"]) {
            _className = [aDic objectForKey:@"className"];
        } 
        
        else {
            [self.storage setObject:[aDic objectForKey:key] forKey:key];
        }
    }
}

- (NSArray *)allKeys
{
    return self.storage.allKeys;
}

- (id)objectForKey:(id)key
{
    return [self.storage objectForKey:key];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    [self.storage setObject:anObject forKey:aKey];
}

- (BOOL)isDataAvailable
{
    return dataAvailable;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Class  Name: %@\n\
            Object ID: %@\n\
            Created At: %@\n\
            Storage: %@", self.className, self.objectId, self.createdAt, self.storage];
}


@end
