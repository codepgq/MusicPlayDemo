//
//  UIImage+pgqImageExtension.h
//  Category
//
//  Created by ios on 16/7/11.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveImageSuccessBlock)();
typedef void(^SaveImageFailBlock)();
typedef void(^PrintScreenBlock)(BOOL isSave);
@interface UIImage (pgqImageExtension)
/**
 *  为图片添加水印信息
 *
 *  @param image     图片
 *  @param text      文字
 *  @param textColor 文字颜色
 *  @param textSize  文字大小
 *
 *  @return 返回水印图片
 */
+ (__kindof UIImage * _Nullable)pgq_waterImageWith:(UIImage * _Nonnull)image waterText:(NSString * _Nullable)text textColor:(UIColor * _Nullable)textColor textSize:(float)textSize;

/**
 *  保存图片到相册
 *
 *  @param image 图片
 */
- (void)pgq_SaveImageToIphoneWithAlbumName:(NSString * _Nullable)albumName saveSuccess:(SaveImageSuccessBlock _Nullable)successBlock saveFail:(SaveImageFailBlock _Nullable)failBlock;
/**
 *  根据指定宽度等比压缩图片
 *
 *  @param sourceImage 图片
 *  @param defineWidth 宽度
 *
 *  @return 压缩后的图片
 */
+ (UIImage * _Nullable)pgq_imageCompressForWidth:(UIImage * _Nonnull)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 *  根据指定大小压缩图片
 *
 *  @param sourceImage 源图片
 *  @param size        指定大小
 *
 *  @return 压缩后的图片
 */
+ (UIImage * _Nullable)pgq_imageCompressForSize:(UIImage * _Nonnull)sourceImage targetSize:(CGSize)size;
/**
 *  裁剪图片
 *
 *  @param rect 大小
 */
- (UIImage * _Nullable)pgq_drawRect:(CGRect)rect;
/**
 *  截屏
 *
 *  @param VC
 */
+ (void)pgq_printScreenWithCurrentClass:(UIViewController * _Nonnull)VC resultBlock:(PrintScreenBlock _Nullable)block;
@end
