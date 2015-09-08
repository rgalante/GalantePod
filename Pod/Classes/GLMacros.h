//
//  GLMacros.h
//  Pods
//
//  Created by Rafael Galante on 7/9/15.
//
//

/* Log */
#define bundleValueForKey(key) [[[NSBundle mainBundle] infoDictionary] objectForKey:key]

#define DLog(fmt, ...) [GLLog log:[@"%s [Line %d] " stringByAppendingString:fmt], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

/* BLOCKS */

#define _ME_WEAK __weak typeof(self) me = self;

#define _WEAK(obj) __weak typeof(obj) me = obj;

/* SINGLETON */
#define GL_SINGLETON_HEADER(_object_name_, _shared_obj_name_) + (_object_name_ *)_shared_obj_name_;
#define GL_SINGLETON(_object_name_, _shared_obj_name_) \
+ (_object_name_ *)_shared_obj_name_ {                     \
static dispatch_once_t pred;                           \
static _object_name_ *shared = nil;                    \
dispatch_once(&pred, ^{                                \
shared = [[_object_name_ alloc] init];             \
});                                                    \
return shared;                                         \
}

