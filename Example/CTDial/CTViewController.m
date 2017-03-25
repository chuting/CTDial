//
//  CTViewController.m
//  CTDial
//
//  Created by 502353919@qq.com on 03/25/2017.
//  Copyright (c) 2017 502353919@qq.com. All rights reserved.
//

#import "CTViewController.h"
#import "CTDialView.h"
@interface CTViewController ()

@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor =  [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
    
    CTDialView * dialView = [[CTDialView alloc] initWithFrame:CGRectMake(37, 60, 300, 300)];
    [self.view addSubview:dialView];
    
    dialView.value = 20;
    dialView.valueChangeBlock =^(CTDialView *dialView)
    {
      
        NSLog(@"值：%f",dialView.value);
    
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
