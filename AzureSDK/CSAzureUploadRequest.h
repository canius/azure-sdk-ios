//
//  CSAzureUploadRequest.h
//  AzureSDK
//
//  Created by canius.chu on 16/1/15.
//  Copyright (c) 2015 beyova. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CSAzureUploadSessionProgressBlock) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);

@interface CSAzureUploadRequest : NSObject

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSData *body;
@property (nonatomic,strong) NSString *mime;
@property (nonatomic,strong) NSString *disposition;
@property (nonatomic,copy) CSAzureUploadSessionProgressBlock progressHandler;

-(NSURLRequest *)buildUrlRequest;

@end
