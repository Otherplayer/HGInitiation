//
//  HGStaticMacro.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/6/15.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#ifndef HGStaticMacro_h
#define HGStaticMacro_h


/**
 * 忽略警告
 **/

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    //...
//#pragma clang diagnostic pop

#define HGArgumentToString(macro) #macro
#define HGClangWarningConcat(warning_name) HGArgumentToString(clang diagnostic ignored warning_name)

#define HGBeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(HGClangWarningConcat(warningName))
#define HGEndIgnoreClangWarning _Pragma("clang diagnostic pop")


///https://www.jianshu.com/p/eb03e20f7b1c
HGBeginIgnoreClangWarning("-Wunused-function")

/**
 * systemTimeZone
 The time zone currently used by the system. If the current time zone cannot be determined, returns the GMT time zone.
 This is the time zone which the device believes it is in; it is often set automatically, and would then correspond to the device's physical location, but if the user has explicitly set a particular time zone in the Settings App, that's what you'll get.
 * defaultTimeZone
 The default time zone for the current application. If no default time zone has been set, this method invokes systemTimeZone and returns the system time zone.
 Your application is allowed to set its own time zone, so that you can perform actions as if the device were in another zone, but without affecting the system time zone (and thereby other apps). The setting is performed with a call to setDefaultTimeZone:. If you haven't done that, this call is identical to calling systemTimeZone.
 * localTimeZone
 An object that forwards all messages to the default time zone for the current application. The local time zone represents the current state of the default time zone at all times.
 This is where it gets a little bit tricky. localTimeZone gives you nearly the same result as defaultTimeZone. The difference is that the specific NSTimeZone instance you get from localTimeZone will always reflect the setting you've made to the time zone within your app. You can call it once, save the result, and always get the current simulated time zone through that object, no matter the changes made. It is as if, when you use this NSTimeZone instance, the framework is calling defaultTimeZone for you, to be sure that you always get the current value.
 https://stackoverflow.com/questions/5985468/iphone-differences-among-time-zone-convenience-methods
 **/

UIKIT_STATIC_INLINE NSString *HGStringFromDate(NSString *dateFormat, NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}
UIKIT_STATIC_INLINE NSDate *HGDateFromString(NSString *dateFormat, NSString *string) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:string];
}


static NSString *HGIdentifier = @"HGIdentifier";
static NSString * const HGAppLanguage = @"HGAppLanguage";

/**
 * https://blog.spacemanlabs.com/2011/12/cancel-dispatch_after/
 * https://github.com/Spaceman-Labs/Dispatch-Cancel
 **/
typedef void(^HGDelayedBlockHandle)(BOOL cancel);

static HGDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t block) {
    
    if (nil == block) {
        return nil;
    }
    
    // block is likely a literal defined on the stack, even though we are using __block to allow us to modify the variable
    // we still need to move the block to the heap with a copy
    __block dispatch_block_t blockToExecute = [block copy];
    __block HGDelayedBlockHandle delayHandleCopy = nil;
    
    HGDelayedBlockHandle delayHandle = ^(BOOL cancel){
        if (NO == cancel && nil != blockToExecute) {
            dispatch_async(dispatch_get_main_queue(), blockToExecute);
        }
        
        // Once the handle block is executed, canceled or not, we free blockToExecute and the handle.
        // Doing this here means that if the block is canceled, we aren't holding onto retained objects for any longer than necessary.
#if !__has_feature(objc_arc)
        [blockToExecute release];
        [delayHandleCopy release];
#endif
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    
    // delayHandle also needs to be moved to the heap.
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
};

static void cancel_delayed_block(HGDelayedBlockHandle delayedHandle) {
    if (nil == delayedHandle) {
        return;
    }
    
    delayedHandle(YES);
}


HGEndIgnoreClangWarning

#endif /* HGStaticMacro_h */
