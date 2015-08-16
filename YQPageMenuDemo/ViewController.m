//
//  ViewController.m
//  YQPageMenuDemo
//
//  Created by 易乔 on 15/8/12.
//  Copyright (c) 2015年 yiqiao. All rights reserved.
//

#import "ViewController.h"
#import "YQPageMenuViewController.h"

@interface ViewController ()
@property (strong, nonatomic) YQPageMenuViewController *pmvc;
@end

@implementation ViewController{
    int color;
    int title;
}

@synthesize pmvc;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    pmvc = [[YQPageMenuViewController alloc] initWithFrame:(CGRect){50,200,300, 200} horizontalNumber:2 verticalNumber:2 menuTitle:@"sgssd"];
    pmvc.tintColor = [UIColor redColor];
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
    [pmvc insertViewItems:@[button1, button2, button3, button4, button5]];
    
    [self addChildViewController:pmvc];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:pmvc.view];
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
        pmvc.tintColor = [UIColor greenColor];
        color = 0;
    } else {
        pmvc.tintColor = [UIColor blueColor];
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
    [pmvc insertViewItems:@[button1, button2, button3, button4, button5]];
}

- (IBAction)removeAllItems:(id)sender {
    [pmvc removeAllViewItems];
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
    [pmvc insertViewItem:button1 atIndex:index];
}

- (IBAction)deleteItem:(id)sender {
    int index = (int)[self.removeIndex.text integerValue];
    if (index < 0) {
        index = 0;
    }
    [pmvc removeViewItemAtIndex:index];
    
}
- (IBAction)changeTitle:(id)sender {
    if (title) {
        pmvc.menuTitle = @"123";
        title = 0;
    } else {
        pmvc.menuTitle = @"345";
        title = 1;
    }
}

- (IBAction)numberChange:(id)sender {
    pmvc.horizontalNumber = (int)[self.horizontalNumber.text integerValue];
    pmvc.verticalNumber = (int)[self.verticalNumber.text integerValue];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
