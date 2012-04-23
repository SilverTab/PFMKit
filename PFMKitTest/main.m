//
//  main.m
//  PFMKitTest
//
//  Created by Jean-Nicolas Jolivet on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  This is just a super simple test program for PFMKit...
//  Test macros are form Mike Ash: https://github.com/mikeash/MACollectionUtilities/blob/master/main.m
//  Some of tests directly related to Parse make some assumptions (i.e. that you
//  setup the config properly, and that you have a User class with a user with
//  "testuser" as its username and password.
//  Sucks for now but eventually the tests will include creating/logging in and
//  logging out and finally deleting the user...

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

// Testing valid user login
static void TestUserLoginValid(void)
{
    __block BOOL done = NO;
    [PFMUser logInWithUsernameInBackground:@"testuser" 
                                  password:@"testuser" 
                                     block:^(PFMUser *user, NSError *error) {
                                         TEST_ASSERT(user != nil, @"User should not be nil");
                                         TEST_ASSERT(error == nil, @"There should be no error");
                                         TEST_ASSERT([[user objectId] length] > 0, @"User should have an id");
                                         TEST_ASSERT([PFMUser currentUser] != nil, @"The current user should be set");

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
        TEST(TestUserLoginValid);
        
        NSString *message;
        if(gFailureCount)
            message = [NSString stringWithFormat: @"FAILED: %d total assertion failure%s", gFailureCount, gFailureCount > 1 ? "s" : ""];
        else
            message = @"SUCCESS";
        NSLog(@"Tests complete: %@", message);
        
        

    }
    return 0;
}

