//
//  essence_test_iosTests.m
//  essence-test-iosTests
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface essence_test_iosTests : XCTestCase

@end

@implementation essence_test_iosTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testConnectToEssenceServer {
    
    
    NSString *b = @"https://api-server.essenceprototyping.com:999/photos/get/58193fe6c225222f7096d092";
    NSURL *dataURL = [NSURL URLWithString:b];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dataURL];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if(error!=nil){
                                          XCTAssertTrue(error != nil, "Can connect to server.");
                                      }else {
                                           XCTAssertFalse(error == nil, "No connection to server.");
                                      }
                                  }];
    [task resume];
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
