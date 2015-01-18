//
//  NSURLSessionTask+CSAdditions.h
//  AzureSDK
//
//  Created by canius on 15/1/18.
//  Copyright (c) 2015年 beyova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionTask (CSAdditions)

@property (nonatomic,strong,readonly) NSString *taskIdentifierString;

@end
