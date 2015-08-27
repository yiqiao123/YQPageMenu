//
//  ViewController.m
//  YQPageMenuDemo
//
//  Created by 易乔 on 15/8/12.
//  Copyright (c) 2015年 yiqiao. All rights reserved.
//

#import "ViewController.h"
#import "YQPageMenuView.h"

@interface ViewController ()
//@property (strong, nonatomic) YQPageMenuViewController *pmvc;
@property (strong, nonatomic) YQPageMenuView *pmv;
@end

@implementation ViewController{
    int color;
    int title;
}

@synthesize pmv;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    pmv = [[YQPageMenuView alloc] initWithFrame:(CGRect){(self.view.bounds.size.width - 300) / 2, 200, 300, 200} horizontalNumber:2 verticalNumber:2 menuTitle:@"sgssd"];
    pmv.headColor = [UIColor redColor];
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button3 = [[UIButton alloc] init];
    [button3 setBackgroundColor:[UIColor greenColor]];
    [button3 setTitle:@"button3" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button4 = [[UIButton alloc] init];
    [button4 setBackgroundColor:[UIColor brownColor]];
    [button4 setTitle:@"button4" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button5 = [[UIButton alloc] init];
    [button5 setBackgroundColor:[UIColor blueColor]];
    [button5 setTitle:@"button5" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    [pmv insertViewItems:@[button1, button2, button3, button4, button5]];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:pmv];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)perform:(UIButton *)sender{
    
    NSLog(@"action");
}

- (IBAction)changeColor:(id)sender {
    if (color) {
        pmv.headColor = [UIColor greenColor];
        color = 0;
    } else {
        pmv.headColor = [UIColor blueColor];
        color = 1;
    }
}

- (IBAction)addItems:(id)sender {
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button3 = [[UIButton alloc] init];
    [button3 setBackgroundColor:[UIColor greenColor]];
    [button3 setTitle:@"button3" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button4 = [[UIButton alloc] init];
    [button4 setBackgroundColor:[UIColor brownColor]];
    [button4 setTitle:@"button4" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button5 = [[UIButton alloc] init];
    [button5 setBackgroundColor:[UIColor blueColor]];
    [button5 setTitle:@"button5" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    [pmv insertViewItems:@[button1, button2, button3, button4, button5]];
}

- (IBAction)removeAllItems:(id)sender {
    [pmv removeAllViewItems];
}

- (IBAction)addItem:(id)sender {
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(perform:) forControlEvents:UIControlEventTouchUpInside];
    int index = (int)[self.addIndex.text integerValue];
    if (index < 0) {
        index = 0;
    }
    [pmv insertViewItem:button1 atIndex:index];
}

- (IBAction)deleteItem:(id)sender {
    int index = (int)[self.removeIndex.text integerValue];
    if (index < 0) {
        index = 0;
    }
    [pmv removeViewItemAtIndex:index];
    
}
- (IBAction)changeTitle:(id)sender {
    if (title) {
        pmv.menuTitle = @"123";
        title = 0;
    } else {
        pmv.menuTitle = @"345";
        title = 1;
    }
}

- (IBAction)numberChange:(id)sender {
    pmv.horizontalNumber = (int)[self.horizontalNumber.text integerValue];
    pmv.verticalNumber = (int)[self.verticalNumber.text integerValue];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
