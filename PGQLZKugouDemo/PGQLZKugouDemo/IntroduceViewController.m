//
//  IntroduceViewController.m
//  KugouDemo
//
//  Created by ios on 16/7/21.
//  Copyright © 2016年 LZ. All rights reserved.
//

#import "IntroduceViewController.h"
#import "BasicHeader.h"
@interface IntroduceViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIButton * joinButton;
@property (strong, nonatomic)  UIScrollView * scrollView;
@property (nonatomic) NSArray * imgs;
@end

@implementation IntroduceViewController

- (NSArray *)imgs{
    if (!_imgs) {
        _imgs = [NSArray arrayWithContentsOfFile: PATH_FORBUNDLE(@"IntroducePlist",@"plist")];
    }
    return _imgs;
}

- (UIButton *)joinButton{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"立即进入" forState:UIControlStateNormal];
        _joinButton.backgroundColor = [UIColor cyanColor];
        _joinButton.layer.cornerRadius = 5;
        _joinButton.hidden = YES;
        _joinButton.frame = CGRectMake(self.view.width * 0.25, self.view.height * 0.7, self.view.width * 0.5, 35);
    }
    return _joinButton;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self addSubViewToScrollView];
    
    [[_joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[BaseViewController new] animated:YES];
    }];
    
}

- (void)addSubViewToScrollView{
    for (NSInteger i = 0; i < self.imgs.count; i++) {
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.imgs[i]]];
        imgView.image = image;
        [self.scrollView addSubview:imgView];
    }
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //隐藏滚动条 设置翻页 关闭弹簧效果
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    //设置滚动范围
    self.scrollView.contentSize = CGSizeMake(self.imgs.count * PL_SRCEEN_WIDTH,0 );
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.joinButton];
}

- (IBAction)pushMainControllerClick:(UIButton *)sender {
    [self.navigationController pushViewController:[[BaseViewController alloc] init] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth/ 2) / pageWidth)+ 1;
    NSLog(@"%d",currentPage);
    if (currentPage == 2) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.joinButton.hidden = NO;
        }];
    }
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
