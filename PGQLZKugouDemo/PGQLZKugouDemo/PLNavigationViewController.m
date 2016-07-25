//
//  PLNavigationViewController.m
//  PL_KGDeomo
//
//  Created by ios on 16/7/21.
//  Copyright © 2016年 PL. All rights reserved.
//

#import "PLNavigationViewController.h"

@interface PLNavigationViewController ()

@end

@implementation PLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
