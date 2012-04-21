//
//  PFMAPIRequest.h
//  PFMKit
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMRequest.h"

@interface PFMAPIRequest : PFMRequest

- (id)initWithApplicationId:(NSString *)anAppId apiKey:(NSString *)anApiKey;
- (void)performRequestWithPath:(NSString *)path completionBlock:(PFMRequestResultBlock)block;

@end
