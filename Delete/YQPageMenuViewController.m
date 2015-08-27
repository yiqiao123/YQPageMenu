//
//  YQPageMenuViewController.m
//  YQPageMenuDemo
//
//  Created by 易乔 on 15/8/12.
//  Copyright (c) 2015年 yiqiao. All rights reserved.
//

#import "YQPageMenuViewController.h"
static long privateKVO;
@interface YQPageMenuViewController()
{
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
}
@end


@implementation YQPageMenuViewController

- (void)freshPageIndicatorView{
    for (UIView *subview in [_pageIndicatorView subviews]) {
        [subview removeFromSuperview];
    }
    _selectPageImage = [self rectangleWithSize:(CGSize){INDICATOR_WIDTH, INDICATOR_HEIGHT} color:self.tintColor isFill:YES];
    _unselectPageImage = [self rectangleWithSize:(CGSize){INDICATOR_WIDTH, INDICATOR_HEIGHT} color:self.tintColor isFill:NO];
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

- (void)viewInit{
    CGSize bound = self.view.frame.size;
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
    [self.view addSubview:_titleLable];
    [self.view addSubview:_menuView];
    [self.view addSubview:_pageIndicatorView];
    [self viewChange];
}

- (void)viewChange{
    _titleLable.font = [UIFont systemFontOfSize:13];
    _titleLable.text = self.menuTitle;
    _titleLable.textColor = self.tintColor;
    
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

- (CGRect)frameAtIndex:(int)index{
    int page = index / (self.horizontalNumber * self.verticalNumber);
//    int x = (index / self.verticalNumber) % self.horizontalNumber;
//    int y = index % self.verticalNumber;
    int x = index % self.horizontalNumber;
    int y = (index / self.horizontalNumber) % self.verticalNumber;
    return CGRectMake(page * _menuView.frame.size.width + (x + 1) * MENU_ITEM_MARGIN_X + x * _viewWidth, (y + 1) * MENU_ITEM_MARGIN_Y + y * _viewHeight, _viewWidth, _viewHeight);
}

- (instancetype)initWithFrame:(CGRect)frame horizontalNumber:(int)horizontalNumber verticalNumber:(int)verticalNumber menuTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _mainFrame = [NSValue valueWithCGRect:frame];
        _viewItem = [NSMutableArray array];
        _horizontalNumber = (horizontalNumber < 1) ? HORIZONTAL_NUMBER_DEFAULT : horizontalNumber;
        _verticalNumber = (verticalNumber < 1) ? VERTICAL_NUMBER_DEFAULT : verticalNumber;
        _menuTitle = title;
        _tintColor = [UIColor blueColor];
        
        [self addObserver:self forKeyPath:@"menuTitle" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&privateKVO];
        [self addObserver:self forKeyPath:@"tintColor" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&privateKVO];
        [self addObserver:self forKeyPath:@"horizontalNumber" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&privateKVO];
        [self addObserver:self forKeyPath:@"verticalNumber" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&privateKVO];
        [self addObserver:self forKeyPath:@"pageIndex" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&privateKVO];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == &privateKVO) {
        if ([keyPath isEqualToString:@"menuTitle"]) {
            if (_menuView) {
                _titleLable.text = self.menuTitle;
            }
        } else if ([keyPath isEqualToString:@"tintColor"]){
            if (_menuView) {
                _titleLable.textColor = self.tintColor;
                [self freshPageIndicatorView];
            }
        } else if ([keyPath isEqualToString:@"horizontalNumber"]){
            if ([[change objectForKey:@"new"] integerValue] < 1) {
                _horizontalNumber = HORIZONTAL_NUMBER_DEFAULT;
            }
            if (_menuView) {
                [self viewChange];
            }
        } else if ([keyPath isEqualToString:@"verticalNumber"]){
            if ([[change objectForKey:@"new"] integerValue] < 1) {
                _verticalNumber = VERTICAL_NUMBER_DEFAULT;
            }
            if (_menuView) {
                [self viewChange];
            }
        } else if ([keyPath isEqualToString:@"pageIndex"]){
            if (_menuView) {
                [self freshPageIndicatorView];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"menuTitle" context:&privateKVO];
    [self removeObserver:self forKeyPath:@"tintColor" context:&privateKVO];
    [self removeObserver:self forKeyPath:@"horizontalNumber" context:&privateKVO];
    [self removeObserver:self forKeyPath:@"verticalNumber" context:&privateKVO];
    [self removeObserver:self forKeyPath:@"pageIndex" context:&privateKVO];
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

- (void)insertViewItems:(NSArray *)views{
    [_viewItem addObjectsFromArray:views];
    if (_menuView) {
        [self viewChange];
    }
}

- (void)removeAllViewItems{
    [_viewItem removeAllObjects];
    if (_menuView) {
        [self viewChange];
    }
}

//should called before the next item
//- (void)itemMoveToNext:(int)index{
//    if (index < (int)[_viewItem count] - 1) {
//        CGRect frame = [_viewItem[index + 1] frame];
//        [_viewItem[index] setFrame:frame];
//    } else {
//        float viewWidth = (_menuView.frame.size.width - MARGIN_X * (self.horizontalNumber + 1)) / self.horizontalNumber;
//        float viewHeight = (_menuView.frame.size.height - MARGIN_Y * (self.verticalNumber + 1)) / self.verticalNumber;
//        [_viewItem[index] setFrame:[self framewithViewWidth:viewWidth andViewHeight:viewHeight atIndex:index + 1]];
//    }
//}

- (void)insertViewItem:(UIButton *)view atIndex:(int)index{
    if (index < 0) {
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
                }
            }
            
        }];
    }
}

//should called after the next item
//- (void)itemMoveToBefore:(int)index{
//    if (index > 0) {
//        CGRect frame = [_viewItem[index - 1] frame];
//        [_viewItem[index] setFrame:frame];
//    } else {
//        return;
//    }
//}

- (void)removeViewItemAtIndex:(int)index{
    if (index < 0 || index >= [_viewItem count]) {
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
                }
            }
            
        }];
    }
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[_mainFrame CGRectValue]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.view.clipsToBounds = YES;
    self.view.opaque = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageIndex = _menuView.contentOffset.x / _menuView.frame.size.width;
}


@end
