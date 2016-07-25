//
//  BaseViewModel.h
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 PL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGQ_ScrollModel;
@class RACCommand;
@interface BaseViewModel : UIView

/**
 *  用户scrollView联动
 */
@property (nonatomic,strong) PGQ_ScrollModel * scrollModel;
/**
 *  处理ScrollView滑动和点击滑到相应的页面
 */
@property (nonatomic,strong) RACCommand * scrollCommand;
@end
