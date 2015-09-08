//
//  KFLog.h
//  Core-KF
//
//  Created by Bruno Berisso on 2/28/13. 
//  Copyright (c) 2014 KnowledgeFactor. All rights reserved.
//

#import <Foundation/Foundation.h>

//LOG FILE KEYs OF EXCEPTIONS
#define APP_ERROR_LOG @"APP_ERROR_LOG_OCURRENCE"
#define APP_ERROR_LOG_REAUTH @"LOG_REAUTH"
#define APP_ERROR_STACK_TRACE @"APP_ERROR_STACK_TRACE"
#define APP_ERROR_NO_DATA_RETURNED @"APP_ERROR_NO_DATA_RETURNED"
#define APP_ERROR_UNEXPECTED @"APP_ERROR_UNEXPECTED"

@interface GLLog : NSObject


//Create the log file if does not exist. If the file was last modified since LOG_FILE_EXPIRE_TIME time (in seconds) from now the file is purgued.
+ (void)setup;

//Write the log message to the STDERR (with 'NSLog()') and to a log file 'Log.txt' in the user documents directory. The format string response to a special token to avoid
//log to the file some portion of the string. Everythig that's come between '_$' and '$_' is replaced for the string '***' in the log file. Once interpreted the tokens are striped
//from the string so it's no appear in the STDERR log
+ (void)log:(NSString *)fmt, ...;

//Free a dedicated GCD queue used to write the log file sequencially in background
+ (void)cleanUp;

//Path to the log file
+ (NSString *)logFilePath;

//Create a file for the exception described by the 'exceptionInfo' dictionary
+ (void)registerExceptionWithInfo:(NSDictionary *)exceptionInfo;

//Path to the exceptions file
+ (NSString *)exceptionsFilePath;

@end
