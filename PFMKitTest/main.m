//
//  main.m
//  PFMKitTest
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  This is just a super simple test program for PFMKit...
//  Test macros are form Mike Ash: https://github.com/mikeash/MACollectionUtilities/blob/master/main.m

#import "main.h"
#import <PFMKit/PFMKit.h>


static int gFailureCount;

static void Test(void (*func)(void), const char *name)
{
    @autoreleasepool {
        int failureCount = gFailureCount;
        NSLog(@"Testing %s", name);
        func();
        NSLog(@"%s: %s", name, failureCount == gFailureCount ? "SUCCESS" : "FAILED");
    };
}


#define TEST(func) Test(func, #func)

#define TEST_ASSERT(cond, ...) do { \
    if(!(cond)) { \
        gFailureCount++; \
        NSString *message = [NSString stringWithFormat: @"" __VA_ARGS__]; \
        NSLog(@"%s:%d: assertion failed: %s %@", __func__, __LINE__, #cond, message); \
    } \
} while(0)



// Testing with no URL given to the request
static void TestRequestNoURL(void)
{
    __block BOOL done = NO;
    
    PFMRequest *request = [[PFMRequest alloc] init];
    [request performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        TEST_ASSERT(data == nil, @"Data is nil");
        TEST_ASSERT(error != nil, @"An Error should be raised");
        TEST_ASSERT(error.code == ENOURL, @"Error should be ENOURL");
        done = YES;
    }];
    while (!done){}
}

// Testing with a bad URL
static void TestRequestBadURL(void)
{
    __block BOOL done = NO;
    
    PFMRequest *request = [PFMRequest requestWithURL:[NSURL URLWithString:@"http://www.hjdshfkjsdhfkjshdfasssdaf.com"]];
    
    [request performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        TEST_ASSERT(data == nil, @"Data is nil");
        TEST_ASSERT(error != nil, @"An Error should be raised");
        done= YES;
    }];
    while (!done){}
}

// Testing with a request that doesn't return JSON
static void TestRequestNonJSON(void)
{
    __block BOOL done = NO;
    PFMRequest *request = [[PFMRequest alloc] init];
    request.url = [NSURL URLWithString:@"http://www.google.com"];
    [request performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        TEST_ASSERT(data == nil, @"Data is nil");
        TEST_ASSERT(error != nil, @"An Error should be raised");
        done = YES;
    }];
    while (!done){}
}

// Testing a valid request...
static void TestRequestValidRequest(void)
{
    __block BOOL done = NO;
    PFMRequest *request = [[PFMRequest alloc] init];
    request.url = [NSURL URLWithString:@"https://api.twitter.com/1/help/configuration.json"];
    [request performRequestWithCompletionBlock:^(id data, PFMRequest *request, NSError *error) {
        TEST_ASSERT(data != nil, @"Data is not nil");
        TEST_ASSERT(error == nil, @"There should be no error");
        TEST_ASSERT([data isKindOfClass:[NSDictionary class]], @"Result should be a dictionary");
        done = YES;
    }];
    while (!done){}
}


int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        //TEST(TestRequestNoURL);
        //TEST(TestRequestBadURL);
        //TEST(TestRequestNonJSON);
        //TEST(TestRequestValidRequest);
        
        NSString *message;
        if(gFailureCount)
            message = [NSString stringWithFormat: @"FAILED: %d total assertion failure%s", gFailureCount, gFailureCount > 1 ? "s" : ""];
        else
            message = @"SUCCESS";
        NSLog(@"Tests complete: %@", message);

        

    }
    return 0;
}
