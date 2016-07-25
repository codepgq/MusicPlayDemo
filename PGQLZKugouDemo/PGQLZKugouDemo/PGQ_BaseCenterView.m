//
//  PGQ_BaseCenterView.m
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 PL. All rights reserved.
//

#import "PGQ_BaseCenterView.h"
#import "BasicHeader.h"
@interface PGQ_BaseCenterView ()<UIScrollViewDelegate>

@property (nonatomic,copy) PGQ_BaseCenterViewPageIndexBlock pageIndexBlock;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray * viewControllers;

@end

@implementation PGQ_BaseCenterView{
    int _pageIndex;
    int _lastPageIndex;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageIndex = -1;
        _lastPageIndex = -1;
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

+ (instancetype)pgq_baseConterViewWithVCS:(NSArray *)vcs PageBlock:(PGQ_BaseCenterViewPageIndexBlock)pageIndexBlock{
    PGQ_BaseCenterView * centerView = [[PGQ_BaseCenterView alloc]initWithFrame:CGRectMake(0, 64, PL_SRCEEN_WIDTH, PL_SRCEEN_HEIGHT-50-64)];
    centerView.pageIndexBlock = pageIndexBlock;
    centerView.viewControllers = vcs;
    [centerView addViewsForScrollView];
    return centerView;
}

- (void)addViewsForScrollView{
    for (NSInteger i = 0; i < self.viewControllers.count; i++) {
        UIViewController * viewController = (UIViewController*)self.viewControllers[i];
        viewController.view.x = i * self.scrollView.width;
        [self.scrollView addSubview:viewController.view];
    }
    self.scrollView.contentSize = CGSizeMake(self.viewControllers.count * self.scrollView.width, 0);
    [self addSubview:self.scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (_pageIndex == _lastPageIndex) {
//        return;
//    }
//    _lastPageIndex = _pageIndex;
    self.pageIndexBlock(_pageIndex);
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _pageIndex = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    NSLog(@"%d",_pageIndex);
}


- (void)updateScrollViewContentOffSetWith:(NSInteger)offset{
    [self.scrollView setContentOffset:CGPointMake(offset * self.scrollView.width, 0) animated:YES];
    _pageIndex = (int)offset;
}

@end

