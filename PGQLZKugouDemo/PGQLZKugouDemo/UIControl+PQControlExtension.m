//
//  UIControl+PQButtonEvent.m
//  PQButtonDelayEvent
//
//  Created by ios on 16/7/20.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import "UIControl+PQControlExtension.h"
#import <objc/message.h>

@interface UIControl ()

//用来计算时长
@property (nonatomic,assign) NSTimeInterval pq_acceptEventTime;

@end

@implementation UIControl (PQControlExtension)

static const char * pq_ISEVENTINTERVALKEY = "ISEVENTINTERVALKEY";
static const char * pq_ACCEPTEVENTINTERVALKEY = "ACCEPTEVENTINTERVALKEY";
static const char * pq_ACCEPTEVENTTIMEKEY = "pq_ACCEPTEVENTTIMEKEY";
// setter
- (void)setPq_isEventInterval:(BOOL)pq_isEventInterval{
    objc_setAssociatedObject(self, pq_ISEVENTINTERVALKEY, @(pq_isEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPq_acceptEventInteval:(NSTimeInterval)pq_acceptEventInteval{
    objc_setAssociatedObject(self, pq_ACCEPTEVENTINTERVALKEY, @(pq_acceptEventInteval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPq_acceptEventTime:(NSTimeInterval)pq_acceptEventTime{
    objc_setAssociatedObject(self, pq_ACCEPTEVENTTIMEKEY, @(pq_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// getter
- (BOOL)pq_isEventInterval{
    return [objc_getAssociatedObject(self, pq_ISEVENTINTERVALKEY) boolValue];
}

- (NSTimeInterval)pq_acceptEventInteval{
    return [objc_getAssociatedObject(self, pq_ACCEPTEVENTINTERVALKEY) doubleValue];
}

- (NSTimeInterval)pq_acceptEventTime{
    return [objc_getAssociatedObject(self, pq_ACCEPTEVENTTIMEKEY) doubleValue];
}

//swap method
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method systemMethod = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
        Method myselfMethod = class_getInstanceMethod([self class], @selector(pq_sendAction:to:forEvent:));
        
        //添加方法
        BOOL isHasMethod = class_addMethod(self, @selector(sendAction:to:forEvent:), method_getImplementation(myselfMethod), method_getTypeEncoding(myselfMethod));
        //判断存不存在
        if (isHasMethod) {
            class_replaceMethod(self, @selector(sendAction:to:forEvent:), method_getImplementation(myselfMethod), method_getTypeEncoding(myselfMethod));
        }else{
            method_exchangeImplementations(systemMethod, myselfMethod);
        }
    });
}

//myself method
- (void)pq_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
 
    //判断是不是超过间隔
    if (NSDate.date.timeIntervalSince1970 - self.pq_acceptEventTime < self.pq_acceptEventInteval) {
        return;
    }
    
    //如果存在 则赋值
    if (self.pq_acceptEventInteval > 0) {
        self.pq_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    //此时调用的是系统的
    [self pq_sendAction:action to:target forEvent:event];
}

@end
