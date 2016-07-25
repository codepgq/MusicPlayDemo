//
//  PGQ_BaseCenterView.h
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 PL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PGQ_BaseCenterViewPageIndexBlock)(NSInteger pageIndex);
@interface PGQ_BaseCenterView : UIView
/**
 *  创建中间的scrollview
 *
 *  @param pageIndexBlock
 *
 *  @return 
 */
+ (instancetype)pgq_baseConterViewWithVCS:(NSArray *)vcs PageBlock:(PGQ_BaseCenterViewPageIndexBlock)pageIndexBlock;
/**
 *  更新到指定的offset
 *
 *  @param offset
 */
- (void)updateScrollViewContentOffSetWith:(NSInteger)offset;
@end
