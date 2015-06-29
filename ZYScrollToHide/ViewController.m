//
//  ViewController.m
//  ZYScrollToHide
//
//  Created by zhangyang@ifensi.com on 15/6/26.
//  Copyright (c) 2015年 张杨. All rights reserved.
//

#import "ViewController.h"
#import "AFSwipeToHide.h"

@interface ViewController ()<AFSwipeToHideDelegate>

@property (assign, nonatomic) CGFloat headerHeight;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) AFSwipeToHide *swipeToHide;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomSpace;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    _titleLabel.text = @"我是导航条";
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:_titleLabel];
    _headerHeight = self.navigationController.navigationBar.frame.size.height + [self statusBarHeight];
    _swipeToHide = [[AFSwipeToHide alloc] init];
    _swipeToHide.scrollDistance = _headerHeight;
    _swipeToHide.delegate = self;
    
    self.tableView.delegate = (id<UITableViewDelegate>)_swipeToHide;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self updateElements];
}

- (void)updateElements {
    AFSwipeToHide *swipeToHide = _swipeToHide;
    CGFloat percentHidden = swipeToHide.percentHidden;
    
    self.toolbarBottomSpace.constant = -percentHidden * 44.0;
    CGRect rect = self.navigationController.navigationBar.frame;
    NSLog(@"之前--y-------->%f",rect.origin.y);
    rect.origin.y = - percentHidden * _headerHeight + [self statusBarHeight];
    NSLog(@"之后--y-------->%f",rect.origin.y);
    self.navigationController.navigationBar.frame = rect;
    _titleLabel.textColor = [[UIColor redColor]colorWithAlphaComponent:(0.8 - percentHidden)];

}

#pragma mark - Sizing utils

- (CGFloat)statusBarHeight {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

#pragma mark - AFUSwipeToHide delegate

- (void)swipeToHide:(AFSwipeToHide *)swipeToHide didUpdatePercentHiddenInteractively:(BOOL)interactive {
    [self updateElements];
    
    if (!interactive) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:0.0 options:0 animations:^{
            [self.view layoutIfNeeded];
            
        } completion:nil];
    }
}

#pragma mark - Just a simple table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Item %i", ((int)indexPath.row + 1)];
    
    return cell;
}




@end
