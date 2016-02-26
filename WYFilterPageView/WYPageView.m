//
//  WYFilterPageView.m
//  WYFilterPageView
//
//  Created by 万延 on 16/2/25.
//  Copyright © 2016年 Pinssible. All rights reserved.
//

#import "WYPageView.h"

static CGFloat transformTime = 0.5f;
static BOOL isTransform = NO;

@interface WYPageView ()
{
    
}

@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) UIView *nextView;
@property (atomic, strong) NSMutableArray *array;

@property (nonatomic, strong) CABasicAnimation *rightAnimation;
@property (nonatomic, strong) CABasicAnimation *rightAnimation1;

@property (nonatomic, strong) CABasicAnimation *leftAnimation;
@property (nonatomic, strong) CABasicAnimation *leftAnimation1;

@end

@implementation WYPageView

- (instancetype)initWithFirstView:(UIView *)view andViewArray:(NSMutableArray *)viewArray
{
    if(self = [super init])
    {
        self.frame = CGRectMake(0, 0, 375, 667);
        _array = viewArray;
        
        [self addSubview:self.currentView];
        [self addSubview:self.lastView];
        [self addSubview:self.nextView];
        
        [self.currentView addSubview:view];
        [self initGesture];
    }
    return self;
}

#pragma mark - Private
- (void)initGesture
{
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    [self.currentView addGestureRecognizer:rightSwipeGesture];
    [self.currentView addGestureRecognizer:leftSwipeGesture];
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)sender
{
    if(isTransform)
        return ;
    [self loadLastViewOfCurrentView:self.currentView];
    if([self getSubViewOfView:self.lastView] && UIGestureRecognizerStateEnded == sender.state)
    {
        isTransform = YES;
        [self.currentView.layer addAnimation:self.rightAnimation forKey:nil];
        [self.lastView.layer addAnimation:self.rightAnimation1 forKey:nil];
        [self.currentView.layer setPosition:self.nextView.layer.position];
    }
}

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)sender
{
    if(isTransform)
        return ;
    [self loadNextViewOfCurrentView:self.currentView];
    if([self getSubViewOfView:self.nextView] && UIGestureRecognizerStateEnded == sender.state)
    {
        isTransform = YES;
        [self.currentView.layer addAnimation:self.leftAnimation forKey:nil];
        [self.nextView.layer addAnimation:self.leftAnimation1 forKey:nil];
        [self.currentView.layer setPosition:self.lastView.layer.position];
    }
}

- (CABasicAnimation *)creatAnimation:(NSString *)keyPath from:(UIView *)start to:(UIView *)destination
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.delegate = self;
    animation.duration = transformTime;
    animation.repeatCount = 1;
    animation.fromValue = [NSValue valueWithCGPoint:start.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:destination.layer.position];
    return animation;
}

- (void)loadLastViewOfCurrentView:(UIView *)currentView
{
    UIView *currentSubView = [self getSubViewOfView:currentView];
    if(self.lastView && [self getSubViewOfView:self.lastView])
        [[self getSubViewOfView:self.lastView] removeFromSuperview];
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(pageView:lastViewOfCurrentView:)])
    {
        UIView *tmpLastSubView = [self.dataSource pageView:self lastViewOfCurrentView:currentSubView];
        [self.lastView addSubview:tmpLastSubView];
    }
}

- (void)loadNextViewOfCurrentView:(UIView *)currentView
{
    UIView *currentSubView = [self getSubViewOfView:currentView];
    if(self.nextView && [self getSubViewOfView:self.nextView])
        [[self getSubViewOfView:self.nextView] removeFromSuperview];
    
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(pageView:nextViewOfCurrentView:)])
    {
        UIView *tmpNextSubView = [self.dataSource pageView:self nextViewOfCurrentView:currentSubView];
        [self.nextView addSubview:tmpNextSubView];
    }
}

- (UIView *)getSubViewOfView:(UIView *)view
{
    if([view subviews].count)
    {
        return [view subviews][0];
    }
    else
        return nil;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    CABasicAnimation *startAnimation = (CABasicAnimation *)anim;
    CGPoint desPoint = [startAnimation.toValue CGPointValue];
    if(desPoint.x > CGRectGetMinX(self.frame) && desPoint.x < CGRectGetMaxX(self.frame))
    {
        CGPoint startPoint = [startAnimation.fromValue CGPointValue];
        if(startPoint.x < CGRectGetMinX(self.frame))
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:willTransitionToView:)])
            {
                [self.delegate pageView:self willTransitionToView:self.lastView];
            }
            NSLog(@"right from last");
        }
        else if (startPoint.x > CGRectGetMaxX(self.frame))
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:willTransitionToView:)])
            {
                [self.delegate pageView:self willTransitionToView:self.nextView];
            }
            NSLog(@"left from next");
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation *endAnimation = (CABasicAnimation *)anim;
    CGPoint desPoint = [endAnimation.toValue CGPointValue];
    if(desPoint.x > CGRectGetMinX(self.frame) && desPoint.x < CGRectGetMaxX(self.frame))
    {
        CGPoint startPoint = [endAnimation.fromValue CGPointValue];
        if(startPoint.x < CGRectGetMinX(self.frame))
        {
            [[self getSubViewOfView:self.currentView] removeFromSuperview];
            [self.currentView addSubview:[self getSubViewOfView:self.lastView]];
            NSLog(@"right swipe stop");
        }
        else if (startPoint.x > CGRectGetMaxX(self.frame))
        {[[self getSubViewOfView:self.currentView] removeFromSuperview];
            [self.currentView addSubview:[self getSubViewOfView:self.nextView]];
            NSLog(@"left swipe stop");
        }
        [self.currentView.layer setPosition:desPoint];
        isTransform = NO;
        if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:didTransitionToView:)])
            [self.delegate pageView:self didTransitionToView:self.currentView];
    }
}

#pragma mark - getter
- (UIView *)currentView
{
    if(!_currentView)
    {
        _currentView = [[UIView alloc] initWithFrame:self.frame];
    }
    return _currentView;
}

- (UIView *)lastView
{
    if(!_lastView)
    {
        CGRect rect = self.currentView.frame;
        _lastView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x - self.frame.size.width, rect.origin.y, rect.size.width, rect.size.height)];
    }
    return _lastView;
}

- (UIView *)nextView
{
    if(!_nextView)
    {
        CGRect rect = self.currentView.frame;
        _nextView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x + self.frame.size.width, rect.origin.y, rect.size.width, rect.size.height)];
    }
    return _nextView;
}

- (CABasicAnimation *)rightAnimation
{
    if(!_rightAnimation)
    {
        _rightAnimation = [self creatAnimation:@"position" from:self.currentView to:self.nextView];
    }
    return _rightAnimation;
}

- (CABasicAnimation *)rightAnimation1
{
    if(!_rightAnimation1)
    {
        _rightAnimation1 = [self creatAnimation:@"position" from:self.lastView to:self.currentView];
    }
    return _rightAnimation1;
}

- (CABasicAnimation *)leftAnimation
{
    if(!_leftAnimation)
    {
        _leftAnimation = [self creatAnimation:@"position" from:self.currentView to:self.lastView];
    }
    return _leftAnimation;
}

- (CABasicAnimation *)leftAnimation1
{
    if(!_leftAnimation1)
    {
        _leftAnimation1 = [self creatAnimation:@"position" from:self.nextView to:self.currentView];
    }
    return _leftAnimation1;
}

@end
