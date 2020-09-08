//
//  SCLifeViewController.m
//  shopping
//
//  Created by gejunyu on 2020/7/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCLifeViewController.h"
#import "SCTagView.h"
#import "SCLifeViewModel.h"
#import "SCLifeSubViewController.h"

@interface SCLifeViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) SCLifeViewModel *viewModel;
@property (nonatomic, strong) SCTagView *tagView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSInteger targetIndex;
@end

@implementation SCLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智能生活";
    
    [self requestCategoryList];
    
}

#pragma mark -requset
- (void)requestCategoryList
{
    [self showLoading];
    [self.viewModel requestCategoryList:self.paramDic success:^(id  _Nullable responseObject) {
        [self stopLoading];
        NSArray *categoryList = self.viewModel.categoryList;
        self.tagView.categoryList = categoryList;
        
        [categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!model.selected) {
                return;
            }
            
            SCLifeSubViewController *vc = self.viewModel.subVcList[idx];
            [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }];
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
        [self showWithStatus:errorMsg];
    }];

}

#pragma mark -UIPageViewControllerDelegate, UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController
{
    SCLifeSubViewController *subVc = (SCLifeSubViewController *)viewController;
    
    NSArray *vcList = self.viewModel.subVcList;
    
    NSInteger index = [vcList indexOfObject:subVc] - 1;
    
    if (index < 0) {
        return nil;
        
    }else {
        SCLifeSubViewController *vc = vcList[index];
        return vc;
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController
{
    SCLifeSubViewController *subVc = (SCLifeSubViewController *)viewController;
    
    NSArray *vcList = self.viewModel.subVcList;
    
    NSInteger index = [vcList indexOfObject:subVc] + 1;
    
    if (index >= vcList.count) {
        return nil;
        
    }else {
        SCLifeSubViewController *vc = vcList[index];
        return vc;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    SCLifeSubViewController *vc = (SCLifeSubViewController *)pendingViewControllers.firstObject;
    _targetIndex = [self.viewModel.subVcList indexOfObject:vc];
    NSLog(@"%li",_targetIndex);
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{

    [self.tagView pushToIndex:_targetIndex];
}

#pragma mark -ui
- (SCTagView *)tagView
{
    if (!_tagView) {
        _tagView = [[SCTagView alloc] initWithFrame:CGRectMake(0, SCREEN_FIX(5), self.view.width, SCREEN_FIX(30))];
        [self.view addSubview:_tagView];
        
        @weakify(self)
        _tagView.selectBlock = ^(NSInteger index) {
            @strongify(self)
            
            SCLifeSubViewController *subVc = self.viewModel.subVcList[index];
            if (subVc != self.pageViewController.parentViewController) {
                [self.pageViewController setViewControllers:@[subVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }
            
            
        };

    }
    return _tagView;
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.bounds = self.view.bounds;
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}


- (SCLifeViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [SCLifeViewModel new];
    }
    return _viewModel;
}


@end
