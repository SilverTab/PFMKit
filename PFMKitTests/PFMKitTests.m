//
//  PFMKitTests.m
//  PFMKitTests
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFMKitTests.h"
#import <PFMKit/PFMKit.h>
@implementation PFMKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}



- (void)testRequestBadURL
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    
    PFMRequest *request = [[PFMRequest alloc] init];
    request.url = [NSURL URLWithString:@"http://www.hfkjsdhfsdfsadgasdfsadf.com"];
    [request performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        STAssertNil(data, @"Data should be nil");
        STAssertNotNil(error, @"Error Should not Be Nil:");
        STAssertEqualObjects([error localizedDescription], 
                       @"A server with the specified hostname could not be found.", 
                       @"Error message should be correct");
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    }
    
    dispatch_release(semaphore);
}

- (void)testNonJSONData
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    PFMRequest *request = [[PFMRequest alloc] init];
    request.url = [NSURL URLWithString:@"http://www.google.com"];
    [request performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        STAssertNil(data, @"Data should be nil");
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    }
    
    dispatch_release(semaphore);
}

@end
