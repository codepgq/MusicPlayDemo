//
//  BaseViewModel.m
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 PL. All rights reserved.
//

#import "BaseViewModel.h"
#import "BasicHeader.h"
@implementation BaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self setScrollTurnToPage];
}

- (void)setScrollTurnToPage{
    /**
     创建一个事件
     */
    self.scrollCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        //返回一个信号
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
}
@end
