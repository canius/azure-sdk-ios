//
//  NSURLSessionTask+CSAdditions.m
//  AzureSDK
//
//  Created by canius on 15/1/18.
//  Copyright (c) 2015年 beyova. All rights reserved.
//

#import "NSURLSessionTask+CSAdditions.h"

@implementation NSURLSessionTask (CSAdditions)

-(NSString *)taskIdentifierString
{
    return [[NSString alloc] initWithFormat:@"%lu",(unsigned long)self.taskIdentifier];
}

@end
