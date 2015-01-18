//
//  CSAzureUploadSessionTests.m
//  AzureSDK
//
//  Created by canius on 15/1/16.
//  Copyright (c) 2015年 beyova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CSAzureUploadSession.h"

@interface CSAzureUploadSessionTests : XCTestCase
{
    CSAzureUploadSession *session;
}
@end

@implementation CSAzureUploadSessionTests

- (void)setUp {
    [super setUp];
    session = [[CSAzureUploadSession alloc] init];
}

- (void)tearDown {
    session = nil;
    [super tearDown];
}

#pragma mark - tests

- (void)testUploadForText {
    
    CSAzureUploadRequest *request = [CSAzureUploadRequest new];
    request.url = @"https://myaccount.blob.core.windows.net/mycontainer/myblob?sv=2014-02-14&sr=b&sig=mCZqcEtjfzled3kY2eh5etwYaPtZ5Ra3jzuVnxnJASk%3D&se=2015-01-17T10%3A42%3A53Z&sp=wl";
    request.body = [@"This is a test blob from iOS." dataUsingEncoding:NSUTF8StringEncoding];
    request.mime = @"text/plain; charset=utf-8";
    request.disposition = @"test.txt";
    [self uploadByRequest:request];
}

- (void)testUploadForBigData {
    
    CSAzureUploadRequest *request = [CSAzureUploadRequest new];
    request.url = @"https://myaccount.blob.core.windows.net/mycontainer/myblob?sv=2014-02-14&sr=b&sig=Cv8TLaJ6g902eUqwTNTfzuf4EyaWh5p5JOqVTQwDaDY%3D&se=2015-01-17T10%3A39%3A38Z&sp=wl";
    request.body = [[NSMutableData alloc] initWithLength:1*1024*1024];
    
    request.progressHandler = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld %lld %lld",bytesSent,totalBytesSent,totalBytesExpectedToSend);
    };
    
    [self uploadByRequest:request];
}

#pragma mark - others

- (void)uploadByRequest:(CSAzureUploadRequest *)request
{
    [[[session upload:request] continueWithBlock:^id(BFTask *task) {
        
        XCTAssertNil(task.error, @"%@", task.error);
        
        return nil;
        
    }] waitUntilFinished];
}

@end
