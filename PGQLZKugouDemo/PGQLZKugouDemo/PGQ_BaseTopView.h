//
//  PGQ_BaseTopView.h
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 PL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PGQ_BaseTopViewClickBlock)(UIButton * button ,NSInteger tag);

@interface PGQ_BaseTopView : UIView

/**
 *  创建一个头视图
 *
 *  @param clickBlock
 *
 *  @return
 */
+ (instancetype)pgq_BaseTopViewWithEvent:(PGQ_BaseTopViewClickBlock)clickBlock;

/**
 *  更新图片
 *
 *  @param image
 */
- (void)updateUserIconWithImage:(UIImage *)image;
/**
 *  更新图片
 *
 *  @param imageNamed 
 */
- (void)updateUserIconWithImageNamed:(NSString *)imageNamed;
/**
 *  更新按钮是不是选中
 *
 *  @param index 
 */
- (void)updateUserSelectedWithIndex:(NSInteger)index;
@end
