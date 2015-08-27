//
//  YQPageMenuView.h
//  YQPageMenuDemo
//
//  Created by 易乔 on 15/8/27.
//  Copyright (c) 2015年 yiqiao. All rights reserved.
//

#define MARGIN_X                        8.0f
#define MARGIN_Y                        8.0f
#define MENU_ITEM_MARGIN_X              16.f
#define MENU_ITEM_MARGIN_Y              16.f
#define TITLE_HEIGHT                    14.f
#define INDICATOR_HEIGHT                6.f
#define INDICATOR_WIDTH                 14.f
#define INDICATOR_MARGIN_X              4.0f
#define HORIZONTAL_NUMBER_DEFAULT       2
#define VERTICAL_NUMBER_DEFAULT         2


#import <UIKit/UIKit.h>

@interface YQPageMenuView : UIView <UIScrollViewDelegate>

@property (copy, nonatomic) NSString *menuTitle;
//default 2
@property (assign, nonatomic) int horizontalNumber;
//default 2
@property (assign, nonatomic) int verticalNumber;
@property (strong, nonatomic) UIColor *headColor;
@property (strong, nonatomic) NSMutableArray *viewItem;
@property (assign, nonatomic) int pageIndex;

- (instancetype)initWithFrame:(CGRect)frame horizontalNumber:(int)horizontalNumber verticalNumber:(int)verticalNumber menuTitle:(NSString *)title;

- (void)insertViewItems:(NSArray *)views;

- (void)removeAllViewItems;

- (void)insertViewItem:(UIView *)view atIndex:(int)index;

- (void)removeViewItemAtIndex:(int)index;

@end
