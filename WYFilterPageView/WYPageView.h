//
//  WYFilterPageView.h
//  WYFilterPageView
//
//  Created by 万延 on 16/2/25.
//  Copyright © 2016年 Pinssible. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WYPageViewDataDelegate;
@protocol WYPageViewDataSource;

@interface WYPageView : UIView

- (instancetype)initWithFirstView:(UIView *)view andViewArray:(NSMutableArray *)viewArray;
@property (nonatomic, strong) UIView *swipeView;

@property (nonatomic, weak) id<WYPageViewDataDelegate> delegate;

@end

@protocol WYPageViewDataDelegate <NSObject>

@optional
- (void)pageView:(WYPageView *)pageView willTransitionToView:(UIView *)view;
- (void)pageView:(WYPageView *)pageView didTransitionToView:(UIView *)view;

@end
