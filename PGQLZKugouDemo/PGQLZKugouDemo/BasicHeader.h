//
//  BasicHeader.h
//  KugouDemo
//
//  Created by ios on 16/7/21.
//  Copyright © 2016年 LZ. All rights reserved.
//

#ifndef BasicHeader_h
#define BasicHeader_h

//viwecontroller
#import "BaseViewController.h"
#import "UIControl+PQControlExtension.h"
#import "UIImage+pgqImageExtension.h"
#import "IntroduceViewController.h"
//唱
#import "PGQ_SingViewController.h"

//navigationController
#import "PLNavigationViewController.h"

//category
#import "UIView+pgqViewExtension.h"

//third party
#import "Masonry.h"
#import "ReactiveCocoa.h"

//定义一个宏 输入 名字和类别 得到路径
#define PATH_FORBUNDLE(name,type) [[NSBundle mainBundle] pathForResource:name ofType:type]
#define RANDOM_COLOR [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1 * random()%100/100.0]
//屏幕宽高
#define PL_SRCEEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PL_SRCEEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif /* BasicHeader_h */
