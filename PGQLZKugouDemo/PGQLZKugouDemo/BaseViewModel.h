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

@property (nonatomic,strong) PGQ_ScrollModel * scrollModel;
@property (nonatomic,strong) RACCommand * scrollCommand;
@end
