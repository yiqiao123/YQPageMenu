//
//  YQPageMenuView.m
//  YQPageMenuDemo
//
//  Created by 易乔 on 15/8/27.
//  Copyright (c) 2015年 yiqiao. All rights reserved.
//

#import "YQPageMenuView.h"

@interface YQPageMenuView(){
    NSMutableArray *_viewItem;
    UIScrollView *_menuView;
    UILabel *_titleLable;
    UIView *_pageIndicatorView;
    int _pageNumber;
    NSValue *_mainFrame;
    UIImage *_selectPageImage;
    UIImage *_unselectPageImage;
    //view item width
    CGFloat _viewWidth;
    //view item width
    CGFloat _viewHeight;
    BOOL _viewItem_semaphore;
}

@end

@implementation YQPageMenuView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _mainFrame = [NSValue valueWithCGRect:frame];
        _viewItem = [NSMutableArray array];
        _horizontalNumber = HORIZONTAL_NUMBER_DEFAULT;
        _verticalNumber = VERTICAL_NUMBER_DEFAULT;
        _headColor = [UIColor blueColor];
        _viewItem_semaphore = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.clipsToBounds = YES;
        self.opaque = YES;
        [self viewInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame horizontalNumber:(int)horizontalNumber verticalNumber:(int)verticalNumber menuTitle:(NSString *)title{
    self = [self initWithFrame:frame];
    if (self) {
        _horizontalNumber = (horizontalNumber < 1) ? HORIZONTAL_NUMBER_DEFAULT : horizontalNumber;
        _verticalNumber = (verticalNumber < 1) ? VERTICAL_NUMBER_DEFAULT : verticalNumber;
        _menuTitle = title;
        [self viewChange];
    }
    return self;
}

#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageIndex = _menuView.contentOffset.x / _menuView.frame.size.width;
}

#pragma mark - private method
- (void)viewInit{
    CGSize bound = self.frame.size;
    float titleWidth = (bound.width - 3 * MARGIN_X) / 2;
    _titleLable = [[UILabel alloc] initWithFrame:(CGRect){MARGIN_X, 0, titleWidth, TITLE_HEIGHT}];
    _pageIndicatorView = [[UIView alloc] initWithFrame:(CGRect){2 * MARGIN_X + titleWidth, 0, titleWidth, TITLE_HEIGHT}];
    _menuView = [[UIScrollView alloc] initWithFrame:(CGRect){0, TITLE_HEIGHT, bound.width, bound.height - TITLE_HEIGHT}];
    _menuView.scrollEnabled = YES;
    _menuView.showsHorizontalScrollIndicator = NO;
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.pagingEnabled = YES;
    _menuView.delegate = self;
    _menuView.clipsToBounds = NO;
    _menuView.delegate = self;
    [self addSubview:_titleLable];
    [self addSubview:_menuView];
    [self addSubview:_pageIndicatorView];
}

- (void)viewChange{
    _titleLable.font = [UIFont systemFontOfSize:13];
    _titleLable.text = self.menuTitle;
    _titleLable.textColor = self.headColor;
    
    _pageNumber = (int)([_viewItem count] - 1) / (self.verticalNumber * self.horizontalNumber) + 1;
    for (UIView *subview in [_menuView subviews]) {
        [subview removeFromSuperview];
    }
    _menuView.contentSize = (CGSize){_pageNumber * _menuView.frame.size.width, 0};
    
    _viewWidth = (_menuView.frame.size.width - MENU_ITEM_MARGIN_X * (self.horizontalNumber + 1)) / self.horizontalNumber;
    _viewHeight = (_menuView.frame.size.height - MENU_ITEM_MARGIN_Y * (self.verticalNumber + 1)) / self.verticalNumber;
    
    for (int i = 0; i < [_viewItem count]; i++) {
        [(UIView *)_viewItem[i] setFrame:[self frameAtIndex:i]];
        [_menuView addSubview:_viewItem[i]];
    }
    self.pageIndex = _menuView.contentOffset.x / _menuView.frame.size.width;
}

- (void)freshPageIndicatorView{
    for (UIView *subview in [_pageIndicatorView subviews]) {
        [subview removeFromSuperview];
    }
    _selectPageImage = [self rectangleWithSize:(CGSize){INDICATOR_WIDTH, INDICATOR_HEIGHT} color:self.headColor isFill:YES];
    _unselectPageImage = [self rectangleWithSize:(CGSize){INDICATOR_WIDTH, INDICATOR_HEIGHT} color:self.headColor isFill:NO];
    if (_pageNumber > 1) {
        float start_x = _pageIndicatorView.frame.size.width - _pageNumber * (INDICATOR_MARGIN_X + INDICATOR_WIDTH) + INDICATOR_MARGIN_X;
        float start_y = (_pageIndicatorView.frame.size.height - INDICATOR_HEIGHT) / 2;
        for (int i = 0; i < _pageNumber; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){start_x + i * (INDICATOR_MARGIN_X + INDICATOR_WIDTH), start_y, INDICATOR_WIDTH, INDICATOR_HEIGHT}];
            if (i == _pageIndex) {
                imageView.image = _selectPageImage;
            } else {
                imageView.image = _unselectPageImage;
            }
            [_pageIndicatorView addSubview:imageView];
        }
    }
}

- (CGRect)frameAtIndex:(int)index{
    int page = index / (self.horizontalNumber * self.verticalNumber);
    //    int x = (index / self.verticalNumber) % self.horizontalNumber;
    //    int y = index % self.verticalNumber;
    int x = index % self.horizontalNumber;
    int y = (index / self.horizontalNumber) % self.verticalNumber;
    return CGRectMake(page * _menuView.frame.size.width + (x + 1) * MENU_ITEM_MARGIN_X + x * _viewWidth, (y + 1) * MENU_ITEM_MARGIN_Y + y * _viewHeight, _viewWidth, _viewHeight);
}

- (UIImage *)rectangleWithSize:(CGSize)size color:(UIColor *)color isFill:(BOOL)isFill{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    CGContextMoveToPoint(context, size.height / 2, 0);
    CGContextAddArcToPoint(context, 0, 0, 0, size.height / 2, size.height / 2);
    CGContextAddArcToPoint(context, 0, size.height, size.height / 2, size.height, size.height / 2);
    CGContextAddLineToPoint(context, size.width - size.height / 2, size.height);
    CGContextAddArcToPoint(context, size.width, size.height, size.width, size.height / 2, size.height / 2);
    CGContextAddArcToPoint(context, size.width, 0, size.width - size.height / 2, 0, size.height / 2);
    CGContextAddLineToPoint(context, size.height / 2, 0);
    if (isFill) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    } else {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokePath(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - public method
- (void)insertViewItems:(NSArray *)views{
    if (_viewItem_semaphore) {
        return;
    }
    _viewItem_semaphore = YES;
    [_viewItem addObjectsFromArray:views];
    if (_menuView) {
        [self viewChange];
    }
    _viewItem_semaphore = NO;
}

- (void)removeAllViewItems{
    if (_viewItem_semaphore) {
        return;
    }
    _viewItem_semaphore = YES;
    [_viewItem removeAllObjects];
    if (_menuView) {
        [self viewChange];
    }
    _viewItem_semaphore = NO;
}

- (void)insertViewItem:(UIButton *)view atIndex:(int)index{
    if (_viewItem_semaphore) {
        return;
    }
    _viewItem_semaphore = YES;
    if (index < 0) {
        _viewItem_semaphore = NO;
        return;
    } else if (index > [_viewItem count]){
        index = (int)[_viewItem count];
    }
    
    //recalculate scroll view content size
    _pageNumber = (int)([_viewItem count] - 1 + 1) / (self.verticalNumber * self.horizontalNumber) + 1;
    _menuView.contentSize = (CGSize){_pageNumber * _menuView.frame.size.width, 0};
    
    //move to operation page
    _pageIndex = index / (self.horizontalNumber * self.verticalNumber);
    CGPoint contentOffset = _menuView.contentOffset;
    contentOffset.x = _menuView.bounds.size.width * _pageIndex;
    [_menuView setContentOffset:contentOffset animated:YES];
    self.pageIndex = _pageIndex;
    
    //move animation
    CGRect frame = [self frameAtIndex:index];
    view.frame = (CGRect){frame.origin.x, -_viewHeight - _menuView.frame.origin.y, _viewWidth, _viewHeight};
    [_menuView addSubview:view];
    
    __block int finishNum = index - 1;
    int viewCount = (int)[_viewItem count];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        view.frame = frame;
    } completion:^(BOOL finished){
        @synchronized(self){
            finishNum++;
            if (finishNum == viewCount) {
                [_viewItem insertObject:view atIndex:index];
                [self viewChange];
                _viewItem_semaphore = NO;
            }
        }
        
    }];
    for (int i = index; i < viewCount; i++) {
        [UIView animateWithDuration:0.5 delay:((i - index) * 0.1) options:UIViewAnimationOptionCurveLinear animations:^{
            [_viewItem[i] setFrame:[self frameAtIndex:(i + 1)]];
        } completion:^(BOOL finished){
            @synchronized(self){
                finishNum++;
                if (finishNum == viewCount) {
                    [_viewItem insertObject:view atIndex:index];
                    [self viewChange];
                    _viewItem_semaphore = NO;
                }
            }
            
        }];
    }
}

- (void)removeViewItemAtIndex:(int)index{
    if (_viewItem_semaphore) {
        return;
    }
    _viewItem_semaphore = YES;
    if (index < 0 || index >= [_viewItem count]) {
        _viewItem_semaphore = NO;
        return;
    }
    
    //move to operation page
    _pageIndex = index / (self.horizontalNumber * self.verticalNumber);
    CGPoint contentOffset = _menuView.contentOffset;
    contentOffset.x = _menuView.bounds.size.width * _pageIndex;
    [_menuView setContentOffset:contentOffset animated:YES];
    self.pageIndex = _pageIndex;
    
    //move animation
    CGRect frame = [_viewItem[index] frame];
    frame.origin.y = -_viewHeight - _menuView.frame.origin.y;
    
    
    __block int finishNum = index;
    int viewCount = (int)[_viewItem count];
    for (int i = index; i < viewCount; i++) {
        [UIView animateWithDuration:0.5 delay:((i - index) * 0.1) options:UIViewAnimationOptionCurveLinear animations:^{
            if (i == index) {
                [_viewItem[i] setFrame:frame];
            } else {
                [_viewItem[i] setFrame:[self frameAtIndex:i - 1]];
            }
        } completion:^(BOOL finished){
            @synchronized(self){
                finishNum++;
                if (finishNum == viewCount) {
                    [_viewItem removeObjectAtIndex:index];
                    [self viewChange];
                    _viewItem_semaphore = NO;
                }
            }
        }];
    }
}

#pragma mark - setter
- (void)setMenuTitle:(NSString *)menuTitle{
    _menuTitle = menuTitle;
    _titleLable.text = _menuTitle;
}

- (void)setHeadColor:(UIColor *)headColor{
    _titleLable.textColor = headColor;
    [self freshPageIndicatorView];
}

- (void)setHorizontalNumber:(int)horizontalNumber{
    if (horizontalNumber < 1) {
        _horizontalNumber = HORIZONTAL_NUMBER_DEFAULT;
    } else {
        _horizontalNumber = horizontalNumber;
    }
    if (_menuView) {
        [self viewChange];
    }
}

- (void)setVerticalNumber:(int)verticalNumber{
    if (verticalNumber < 1) {
        _verticalNumber = HORIZONTAL_NUMBER_DEFAULT;
    } else {
        _verticalNumber = verticalNumber;
    }
    if (_menuView) {
        [self viewChange];
    }
}

- (void)setPageIndex:(int)pageIndex{
    _pageIndex = pageIndex;
    if (_pageIndicatorView) {
        [self freshPageIndicatorView];
    }
}

@end
