//
//  CSAzureUploadSession.h
//  AzureSDK
//
//  Created by canius.chu on 16/1/15.
//  Copyright (c) 2015 beyova. All rights reserved.
//
//  http://msdn.microsoft.com/zh-cn/library/azure/dd179451.aspx

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>
#import "CSAzureUploadRequest.h"

extern NSString * const CSAzureUploadSessionErrorDomain;
extern NSString * const CSAzureUploadSessionErrorMessageKey;
extern NSString * const CSAzureUploadSessionErrorURLResponseKey;

@interface CSAzureUploadSession : NSObject

-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

-(BFTask *)upload:(CSAzureUploadRequest *)request;

@end