//
//  ViewController.m
//  WYFilterPageView
//
//  Created by 万延 on 16/2/25.
//  Copyright © 2016年 Pinssible. All rights reserved.
//

#import "ViewController.h"
#import "WYPageView.h"

@interface ViewController () <WYPageViewDataDelegate, WYPageViewDataSource>
{
    NSMutableArray *array;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    array = [NSMutableArray array];
    UIView *_currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    UIView *_nextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    UIView *_lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    _currentView.layer.borderColor = [UIColor redColor].CGColor;
    _currentView.layer.borderWidth = 20;
    _nextView.layer.borderColor = [UIColor blueColor].CGColor;
    _nextView.layer.borderWidth = 20;
    _lastView.layer.borderColor = [UIColor greenColor].CGColor;
    _lastView.layer.borderWidth = 20;
    [array addObjectsFromArray:@[ _currentView, _lastView, _nextView]];
    WYPageView *pageView = [[WYPageView alloc] initWithFirstView:_currentView andViewArray:nil];
    pageView.delegate = self;
    pageView.dataSource = self;
    [self.view addSubview:pageView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)pageView:(WYPageView *)pageView nextViewOfCurrentView:(UIView *)view
{
    NSUInteger  index = [array indexOfObject:view];
    if(index == [array count] - 1)
        return array[0];
    else if (index < [array count] - 1)
        return array[index + 1];
    else
    {
        NSLog(@"ERROR!!!");
        return nil;
    }
}
- (UIView *)pageView:(WYPageView *)pageView lastViewOfCurrentView:(UIView *)view
{
    NSUInteger  index = [array indexOfObject:view];
    if(index == 0)
        return [array lastObject];
    else if(index < [array count])
        return array[index - 1];
    else
    {
        NSLog(@"ERROR");
        return nil;
    }
}

@end
