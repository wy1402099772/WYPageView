//
//  WYFilterPageView.m
//  WYFilterPageView
//
//  Created by 万延 on 16/2/25.
//  Copyright © 2016年 Pinssible. All rights reserved.
//

#import "WYPageView.h"

static CGFloat transformTime = 0.3f;

@interface WYPageView ()
{
    BOOL isTransform;
    BOOL isFirstViewHide;
}

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIView *currentView0;
@property (nonatomic, strong) UIView *currentView1;

@end

@implementation WYPageView

- (instancetype)initWithFirstView:(UIView *)view andViewArray:(NSMutableArray *)viewArray
{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _array = viewArray;
        isTransform = NO;
        isFirstViewHide = NO;
        _currentView0 = view;
        [self addSubview:_currentView0];
        
        _currentView1 = nil;
        
        [self addSubview:self.swipeView];
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
    
    
    [self.swipeView addGestureRecognizer:rightSwipeGesture];
    [self.swipeView addGestureRecognizer:leftSwipeGesture];
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)sender
{
    if(isTransform)
        return ;
    if(self.array.count > 1 && UIGestureRecognizerStateEnded == sender.state)
    {
        isTransform = YES;
        CABasicAnimation *animation0 = [self creatAnimationIsIn:YES andDirectionIsRight:YES];
        CABasicAnimation *animation1 = [self creatAnimationIsIn:NO andDirectionIsRight:YES];
        if(isFirstViewHide)
        {
            self.currentView0 = [self getlastView:self.currentView1];
            [self addSubview:self.currentView0];
            [self.currentView0 setFrame:self.bounds];
            [self bringSubviewToFront:self.swipeView];
            [self layoutIfNeeded];
            [self.currentView0.layer addAnimation:animation0 forKey:nil];
            [self.currentView1.layer addAnimation:animation1 forKey:nil];
            [self.currentView1.layer setPosition:[animation1.toValue CGPointValue]];
        }
        else
        {
            self.currentView1 = [self getlastView:self.currentView0];
            [self addSubview:self.currentView1];
            [self.currentView1 setFrame:self.bounds];
            [self.currentView1 setHidden:YES];
            [self bringSubviewToFront:self.swipeView];
            [self layoutIfNeeded];
            [self.currentView1.layer addAnimation:animation0 forKey:nil];
            [self.currentView0.layer addAnimation:animation1 forKey:nil];
            [self.currentView0.layer setPosition:[animation1.toValue CGPointValue]];
        }
    }
}

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)sender
{
    if(isTransform)
        return ;
    if(self.array.count > 1 && UIGestureRecognizerStateEnded == sender.state)
    {
        isTransform = YES;
        CABasicAnimation *animation0 = [self creatAnimationIsIn:YES andDirectionIsRight:NO];
        CABasicAnimation *animation1 = [self creatAnimationIsIn:NO andDirectionIsRight:NO];
        if(isFirstViewHide)
        {
            self.currentView0 = [self getlastView:self.currentView1];
            [self addSubview:self.currentView0];
            [self.currentView0 setFrame:self.bounds];
            [self bringSubviewToFront:self.swipeView];
            [self layoutIfNeeded];
            [self.currentView0.layer addAnimation:animation0 forKey:nil];
            [self.currentView1.layer addAnimation:animation1 forKey:nil];
            [self.currentView1.layer setPosition:[animation1.toValue CGPointValue]];
        }
        else
        {
            self.currentView1 = [self getlastView:self.currentView0];
            [self addSubview:self.currentView1];
            [self.currentView1 setFrame:self.bounds];
            [self.currentView1 setHidden:YES];
            [self bringSubviewToFront:self.swipeView];
            [self layoutIfNeeded];
            [self.currentView1.layer addAnimation:animation0 forKey:nil];
            [self.currentView0.layer addAnimation:animation1 forKey:nil];
            [self.currentView0.layer setPosition:[animation1.toValue CGPointValue]];
        }
    }
}

- (CABasicAnimation *)creatAnimationIsIn:(BOOL)isIn andDirectionIsRight:(BOOL)isRight
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = transformTime;
    animation.repeatCount = 1;
    CGPoint startPosition, destinationPosition;
    if(isIn)
    {
        if(isRight)
        {
            startPosition = [self getCurrentView].layer.position;
            startPosition = CGPointMake(startPosition.x - self.frame.size.width, startPosition.y);
        }
        else
        {
            startPosition = [self getCurrentView].layer.position;
            startPosition = CGPointMake(startPosition.x + self.frame.size.width, startPosition.y);
        }
        destinationPosition = [self getCurrentView].layer.position;
    }
    else
    {
        animation.delegate = self;
        startPosition = [self getCurrentView].layer.position;
        if(isRight)
        {
            destinationPosition = [self getCurrentView].layer.position;
            destinationPosition = CGPointMake(destinationPosition.x + self.frame.size.width, destinationPosition.y);
        }
        else
        {
            destinationPosition = [self getCurrentView].layer.position;
            destinationPosition = CGPointMake(destinationPosition.x - self.frame.size.width, destinationPosition.y);
        }
    }
    animation.fromValue = [NSValue valueWithCGPoint:startPosition];
    animation.toValue = [NSValue valueWithCGPoint:destinationPosition];
    return animation;
}

- (UIView *)getCurrentView
{
    if(isFirstViewHide)
        return self.currentView1;
    else
        return self.currentView0;
}

- (UIView *)getNextView:(UIView *)currentView
{
    NSUInteger index = [self.array indexOfObject:currentView];
    if (NSNotFound == index || self.array.count - 1 == index) {
        return self.array[0];
    }
    else{
        return self.array[index + 1];
    }
}

- (UIView *)getlastView:(UIView *)currentView
{
    NSUInteger index = [self.array indexOfObject:currentView];
    if (NSNotFound == index || 0  == index) {
        return [self.array lastObject];
    }
    else{
        return self.array[index - 1];
    }
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    if(isFirstViewHide)
        self.currentView0.hidden = NO;
    else
        self.currentView1.hidden = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:willTransitionToView:)])
        [self.delegate pageView:self willTransitionToView:isFirstViewHide ? self.currentView0: self.currentView1];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(isFirstViewHide)
    {
        [self.currentView1 setHidden:YES];
        [self.currentView1 removeFromSuperview];
    }
    else
    {
        [self.currentView0 setHidden:YES];
        [self.currentView0 removeFromSuperview];
    }
    isTransform = NO;
    isFirstViewHide = !isFirstViewHide;
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageView:didTransitionToView:)])
        [self.delegate pageView:self didTransitionToView:isFirstViewHide ? self.currentView1: self.currentView0];
}

#pragma mark - getter
- (UIView *)swipeView
{
    if(!_swipeView)
    {
        _swipeView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _swipeView;
}


@end
