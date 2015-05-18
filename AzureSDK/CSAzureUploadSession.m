//
//  CSAzureUploadSession.m
//  AzureSDK
//
//  Created by canius.chu on 16/1/15.
//  Copyright (c) 2015 beyova. All rights reserved.
//

#import "CSAzureUploadSession.h"
#import <TMCache/TMMemoryCache.h>

NSString * const CSAzureUploadSessionErrorDomain = @"com.beyova.azure.upload.session.error";
NSString * const CSAzureUploadSessionErrorMessageKey = @"com.beyova.azure.upload.session.error.message";
NSString * const CSAzureUploadSessionErrorURLResponseKey = @"com.beyova.azure.upload.session.error.response";

static void * CSAzureUploadSessionTaskStateChangedContext = &CSAzureUploadSessionTaskStateChangedContext;

@interface CSAzureUploadSession () <NSURLSessionDataDelegate>
{
    NSURLSession *session;
    TMMemoryCache *taskCache;
}
@end

@implementation CSAzureUploadSession

- (instancetype)init
{
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (self) {
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
        taskCache = [[TMMemoryCache alloc] init];
        taskCache.removeAllObjectsOnEnteringBackground = NO;
        taskCache.removeAllObjectsOnMemoryWarning = NO;
    }
    return self;
}

-(BFTask *)upload:(CSAzureUploadRequest *)request
{
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    
    NSURLSessionUploadTask *sessionUploadTask = [session uploadTaskWithRequest:[request buildUrlRequest] fromData:request.body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        
        if (error) {
            [tcs setError:error];
        }
        else if (resp.statusCode / 100 != 2) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:resp.statusCode],
                                       CSAzureUploadSessionErrorMessageKey : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
                                       CSAzureUploadSessionErrorURLResponseKey : resp
                                       };
            
            error = [NSError errorWithDomain:CSAzureUploadSessionErrorDomain
                                        code:1
                                    userInfo:userInfo];
            
            [tcs setError:error];
        }
        else {
            [tcs setResult:nil];
        }
        
    }];
    
    if (request.progressHandler) {
        [sessionUploadTask addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:CSAzureUploadSessionTaskStateChangedContext];
        [taskCache setObject:request.progressHandler forKey:[CSAzureUploadSession taskIdentifierStringByTask:sessionUploadTask]];
    }
    
    [sessionUploadTask resume];
    
    return tcs.task;
}

+(NSString *)taskIdentifierStringByTask:(NSURLSessionTask *)task
{
    return [[NSString alloc] initWithFormat:@"%lu",(unsigned long)task.taskIdentifier];
}

#pragma mark - KVO CSAzureUploadSessionTaskStateChangedContext

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CSAzureUploadSessionTaskStateChangedContext) {
        NSURLSessionTaskState state = [change[NSKeyValueChangeNewKey] integerValue];
        if (state == NSURLSessionTaskStateCanceling || state == NSURLSessionTaskStateCompleted) {
            NSURLSessionTask *task = (NSURLSessionTask *)object;
            [task removeObserver:self forKeyPath:@"state" context:CSAzureUploadSessionTaskStateChangedContext];
            [taskCache removeObjectForKey:[CSAzureUploadSession taskIdentifierStringByTask:task]];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [taskCache objectForKey:[CSAzureUploadSession taskIdentifierStringByTask:task]
                      block:^(TMMemoryCache *cache, NSString *key, id object) {
                          if (object) {
                              CSAzureUploadSessionProgressBlock progressHandler = (CSAzureUploadSessionProgressBlock)object;
                              progressHandler(bytesSent,totalBytesSent,totalBytesExpectedToSend);
                          }
                      }];
}

@end
