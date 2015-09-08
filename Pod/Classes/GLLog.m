//
//  KFLog.m
//  Core-KF
//
//  Created by Bruno Berisso on 2/28/13.
//  Copyright (c) 2014 KnowledgeFactor. All rights reserved.
//

#import "GLLog.h"
#import <sys/utsname.h>
#import "GLMacros.h"
#import <UIKit/UIKit.h>

#define LOG_FILE_EXPIRE_TIME    300.0
#define LOG_OMIT_REGEX_TOKEN_START    @"_\\$"
#define LOG_OMIT_REGEX_TOKEN_END      @"\\$_"
#define LOG_OMIT_TOKEN_START          @"_$"
#define LOG_OMIT_TOKEN_END            @"$_"

#define WRITEGROUP_TIME_OUT     3000000000


@implementation GLLog

static dispatch_group_t writeGroup = NULL;
static dispatch_queue_t writeQueue = NULL;

#pragma mark - Private

+ (NSString *)logFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentsPath stringByAppendingPathComponent:@"Log.txt"];
}

+ (void)setupWriteQueue {
    writeGroup = dispatch_group_create();
    writeQueue = dispatch_queue_create("com.globant.GLLogWriterQueue", DISPATCH_QUEUE_SERIAL);
}

+ (void)cleanUp:(NSNotification *)notification {
    dispatch_group_wait(writeGroup, dispatch_time(DISPATCH_TIME_NOW, WRITEGROUP_TIME_OUT));
    writeQueue = NULL;
}

+ (void)writeMessage:(NSString *)msg toFile:(NSString *)filePath {
    dispatch_group_async(writeGroup, writeQueue, ^{
        NSString *_logMsg = [self parseMessage:msg];
        NSFileHandle *fileHandl = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandl seekToEndOfFile];
        [fileHandl writeData:[[_logMsg stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandl closeFile];
    });
}

+ (NSString *)parseMessage:(NSString *)logMsg {
    
    NSString *regexStr              = [NSString stringWithFormat:@"(%@.*?%@)", LOG_OMIT_REGEX_TOKEN_START, LOG_OMIT_REGEX_TOKEN_END];
    NSError *error                  = NULL;
    NSMutableString *mLogMsg        = [NSMutableString stringWithString:logMsg] ;
    NSRegularExpression *regex      = [[NSRegularExpression alloc] initWithPattern:regexStr
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];
    
	if(error) {
        DLog(@"Error creating regex with:%@ and error %@", regexStr, [error localizedDescription]);
        error = NULL;
    } else {
        [regex replaceMatchesInString:mLogMsg
                              options:0
                                range:NSMakeRange(0,mLogMsg.length)
                         withTemplate:@"***"];
    }
    
    return [NSString stringWithFormat:@"%@: %@", [NSDate date], mLogMsg];
}

+ (NSError *)createFileAtPath:(NSString *)filePath {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:filePath error:&error];
        
        if (!error) {
            NSDate *modificationDate = [fileAttr valueForKey:NSFileModificationDate];
            if (fabs([modificationDate timeIntervalSinceNow]) > LOG_FILE_EXPIRE_TIME)
                [@"" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
    } else
        [@"" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (!error)
        [[NSURL fileURLWithPath:filePath] setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    return error;
}

+ (NSString *)deviceInfo {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *info = [NSString stringWithFormat:@"---------------------- Device %@ (%@ - %@) - %@ (%@ - %@) ----------------------", [NSString stringWithUTF8String:systemInfo.machine], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], bundleValueForKey(@"CFBundleDisplayName"), bundleValueForKey(@"CFBundleShortVersionString"), bundleValueForKey(@"CFBundleVersion")];
    
    return info;
}

#pragma mark - Setup and Log

+ (void)writeHeader {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *logHeader = [NSString stringWithFormat:@"\n\n\n---------------------- Session started at %@ ----------------------\n%@\n\n\n", [NSDate date], [self deviceInfo]];
    [self writeMessage:logHeader toFile:[self logFilePath]];
}

+ (void)setup {
    NSError *error = [self createFileAtPath:[self logFilePath]];
    
    if (!error)
        error = [self createFileAtPath:[self exceptionsFilePath]];
    
    if (error)
        NSLog(@"KFLog setup error: %@", error);
    else {
        [self setupWriteQueue];
        [self writeHeader];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanUp:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
    }
}

+ (void)log:(NSString *)fmt, ... {
    va_list argList;
    va_start(argList, fmt);
    
    NSString *logString = [[NSString alloc] initWithFormat:fmt arguments:argList];
    
    //#ifndef PRODUCTION_BUILD B-04677 Send Diagnostic: add more details
    [self writeMessage:logString toFile:[self logFilePath]];//When defined write the output of the DLog() calls to a file
    //#endif
    
#ifdef DEBUG
    logString = [logString stringByReplacingOccurrencesOfString:LOG_OMIT_TOKEN_START withString:@""];
    logString = [logString stringByReplacingOccurrencesOfString:LOG_OMIT_TOKEN_END withString:@""];
    NSLog(@"%@",logString);
#endif
}

+ (void)cleanUp {
    [self cleanUp:nil];
}

#pragma mark - Exceptions

+ (NSString *)exceptionsFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentsPath stringByAppendingPathComponent:@"Exceptions.txt"];
}

+ (void)registerExceptionWithInfo:(NSDictionary *)exceptionInfo {
    NSString *message = [NSString stringWithFormat:@"\n\n\nException: %@\n%@", [NSDate date], exceptionInfo];
    [self writeMessage:message toFile:[self exceptionsFilePath]];
}

@end
