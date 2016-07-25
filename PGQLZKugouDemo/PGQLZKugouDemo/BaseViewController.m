//
//  ViewController.m
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/22.
//  Copyright © 2016年 PL. All rights reserved.
//

#import "BaseViewController.h"
#import "BasicHeader.h"
#import "BaseHeader.h"
@interface BaseViewController ()

@property (nonatomic,strong) PGQ_BaseTopView *topView;
@property (nonatomic,strong) PGQ_BaseBottomView *bottomView;
@property (nonatomic,strong) PGQ_BaseCenterView *centerView;
@property (nonatomic,strong) BaseViewModel * baseVM;

@end

@implementation BaseViewController

- (BaseViewModel *)baseVM{
    if (!_baseVM) {
        _baseVM = [[BaseViewModel alloc]init];
    }
    return _baseVM;
}

- (PGQ_BaseTopView *)topView{
    if (!_topView) {
        _topView = [PGQ_BaseTopView pgq_BaseTopViewWithEvent:^(UIButton *button, NSInteger tag) {
            [self.baseVM.scrollCommand execute:@(tag)];
        }];
    }
    return _topView;
}

- (PGQ_BaseBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [PGQ_BaseBottomView pgqBaseBottomView];
        _bottomView.width = PL_SRCEEN_WIDTH;
        _bottomView.y = self.view.bounds.size.height - 50;
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self initUI];
    [self event];
}

- (void)event{
    [self.baseVM.scrollCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        [self.topView updateUserSelectedWithIndex:[x integerValue]];
        [self.centerView updateScrollViewContentOffSetWith:[x integerValue]];
    }];
}

- (void)initUI{
    [self.view addSubview:self.topView];
    
    
    UIViewController * controller1 = [[UIViewController alloc] init];
    controller1.view.backgroundColor = [UIColor blueColor];
    
    UIViewController * controller2 = [[UIViewController alloc] init];
    controller2.view.backgroundColor = [UIColor greenColor];
    
    UIViewController * controller3 = [[UIViewController alloc] init];
    controller3.view.backgroundColor = [UIColor redColor];
    
    self.centerView = [PGQ_BaseCenterView pgq_baseConterViewWithVCS:@[controller1,controller2,controller3] PageBlock:^(NSInteger pageIndex) {
        NSLog(@"scroll - pageindex %ld",pageIndex);
        [self.baseVM.scrollCommand execute:@(pageIndex)];
    }];
    [self.view addSubview:self.centerView];
    
    [self.view addSubview:self.bottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
