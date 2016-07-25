//
//  UIImage+pgqImageExtension.m
//  Category
//
//  Created by ios on 16/7/11.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "UIImage+pgqImageExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>



@implementation UIImage (pgqImageExtension)

+ (__kindof UIImage *)pgq_waterImageWith:(UIImage * _Nonnull)image waterText:(NSString * _Nullable)text textColor:(UIColor * _Nullable)textColor textSize:(float)textSize{
    //1.获取上下文
    UIGraphicsBeginImageContext(image.size);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //3.绘制水印文字
    CGRect rect;
    CGSize size;
    //计算文字大小所占的空间
    UIFont * font = [UIFont boldSystemFontOfSize:17];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(image.size.width, MAXFLOAT);
    // 获得系统版本
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    } else {
        size = [text sizeWithFont:font constrainedToSize:maxSize];
    }
    rect = CGRectMake(image.size.width - size.width, image.size.height - size.height+5, size.width, size.height);
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:textSize],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:textColor
                          };
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    //4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    return watermarkImage;
}
static SaveImageSuccessBlock _successBlock;
static SaveImageFailBlock _failBlock;
- (void)pgq_SaveImageToIphoneWithAlbumName:(NSString * _Nullable)albumName saveSuccess:(SaveImageSuccessBlock _Nullable)successBlock saveFail:(SaveImageFailBlock _Nullable)failBlock;{
    
    _successBlock = successBlock;
    _failBlock = failBlock;
    
    if (albumName.length) {
        //创建相册 并存入照片
        [self createAlbum:albumName image:self];
    }
    else{
        /**
         *  将图片保存到iPhone本地相册
         *  UIImage *image            图片对象
         *  id completionTarget       响应方法对象
         *  SEL completionSelector    方法
         *  void *contextInfo
         */
        UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

//创建相册 并存入照片
- (void)createAlbum:(NSString*)albumName image:(UIImage*)image
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
        
        //创建相簿成功
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        //保存图片
        [self saveToAlbumWithMetadata:nil imageData:data customAlbumName:albumName completionBlock:^
         {
             _successBlock();
         }
                         failureBlock:^(NSError *error)
         {
             _failBlock();
         }];
        
    } failureBlock:^(NSError *error) {
        //失败
        _failBlock();
    }];
}


- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        if (_successBlock) {
            _successBlock();
            _successBlock = nil;
        }else if(_psBlock){
            _psBlock(YES);
            _psBlock = nil;
        }else
        NSLog(@"success!");
        
    }else{
        if (_failBlock) {
            _failBlock();
            _failBlock = nil;
        }
        else if(_psBlock){
            _psBlock(NO);
            _psBlock = nil;
        }else
        NSLog(@"fail!");
    }
}


+(UIImage * _Nullable)pgq_imageCompressForSize:(UIImage * _Nonnull)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail - 压缩失败");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+(UIImage * _Nullable)pgq_imageCompressForWidth:(UIImage * _Nonnull)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail - 压缩失败");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)pgq_drawRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, imageRef);
    
    UIImage* clipImage = [UIImage imageWithCGImage:imageRef];
    
    //    CGImageCreateWithImageInRect(CGImageRef  _Nullable image, <#CGRect rect#>)
    
    //    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();      // 不同的方式
    
    UIGraphicsEndImageContext();
    
    //    NSData* data = [NSData dataWithData:UIImagePNGRepresentation(clipImage)];
    
    //    BOOL flag = [data writeToFile:@"/Users/gua/Desktop/Image/后.png" atomically:YES];
    
    //    GGLogDebug(@"========压缩后=======%@",clipImage);
    
    return clipImage;
}

static PrintScreenBlock _psBlock = nil;
+ (void)pgq_printScreenWithCurrentClass:(UIViewController * _Nonnull)VC resultBlock:(PrintScreenBlock _Nullable)block{
    _psBlock = block;
    //延迟两秒保存
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController * controller = VC;
        //获取图形上下文
        //    UIGraphicsBeginImageContext(self.view.frame.size);
        UIGraphicsBeginImageContext(controller.view.frame.size);
        //将view绘制到图形上下文中
        
        //    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        [controller.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        //将截屏保存到相册
        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
        
        [newImage pgq_SaveImageToIphoneWithAlbumName:nil saveSuccess:nil saveFail:nil];
    });
}


@end
