//
//  CSAzureUploadRequest.m
//  AzureSDK
//
//  Created by canius.chu on 16/1/15.
//  Copyright (c) 2015 beyova. All rights reserved.
//

#import "CSAzureUploadRequest.h"

@implementation CSAzureUploadRequest

-(NSURLRequest *)buildUrlRequest
{
    NSURL *url = [NSURL URLWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)_body.length] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"BlockBlob" forHTTPHeaderField:@"x-ms-blob-type"];
    if (_mime.length) {
        [urlRequest setValue:_mime forHTTPHeaderField:@"Content-Type"];
    }
    if (_disposition.length) {
        NSString *disposition = [[NSString alloc] initWithFormat:@"attachment; filename=\"%@\"",
                                      [_disposition stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setValue:disposition forHTTPHeaderField:@"x-ms-blob-content-disposition"];
    }
    return urlRequest;
}

@end
