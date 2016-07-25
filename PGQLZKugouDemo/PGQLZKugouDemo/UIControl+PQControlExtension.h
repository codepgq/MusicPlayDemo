//
//  UIControl+PQButtonEvent.h
//  PQButtonDelayEvent
//
//  Created by ios on 16/7/20.
//  Copyright © 2016年 PQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (PQControlExtension)

//用来输入重复点击的间隔
@property (nonatomic,assign) NSTimeInterval pq_acceptEventInteval;

@end
