//
//  NSString+Utils.h
//  Core-KF
//
//  Created by Federico Lagarmilla on 05/08/14.
//  Copyright (c) 2014 KnowledgeFactor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

+ (NSString *)gl_documentDirectory;
- (NSDate *)gl_toDateWithFormat:(NSString*)dateFormat;
- (NSString *)gl_localize;
+ (NSString *)gl_localizedStringWithFormat:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2);
- (BOOL)gl_present;
- (NSURL *)gl_toURL;
+ (NSString *)gl_randomStringWithLength:(int) len;
- (NSString *)stringByUnescapingXMLEntities;

@end
