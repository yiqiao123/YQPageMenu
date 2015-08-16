//
//  ViewController.h
//  YQPageMenuDemo
//
//  Created by 易乔 on 15/8/12.
//  Copyright (c) 2015年 yiqiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)changeColor:(id)sender;
- (IBAction)addItems:(id)sender;
- (IBAction)removeAllItems:(id)sender;
- (IBAction)addItem:(id)sender;
- (IBAction)deleteItem:(id)sender;
- (IBAction)changeTitle:(id)sender;

- (IBAction)numberChange:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *horizontalNumber;
@property (strong, nonatomic) IBOutlet UITextField *verticalNumber;
- (IBAction)textFieldDoneEditing:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *addIndex;
@property (strong, nonatomic) IBOutlet UITextField *removeIndex;

@end

