//
//  ViewController.m
//  LineChartDemo
//
//  Created by tenghu on 2017/11/30.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "ViewController.h"
#import "PFLineChart.h"

#define RGB(r,g,b,alph)[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alph]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arrary1 = @[@"0",@"30",@"80",@"50",@"100",@"80",@"100",@"50",@"0"];
    NSArray *arrary2 = @[@"0",@"40",@"90",@"30",@"80",@"100",@"60",@"20",@"0"];
    
    PFLineChart *lineChart = [[PFLineChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 150)];
    lineChart.yValues = @[arrary1,arrary2];
    lineChart.yLabels = @[@"0",@"20",@"40",@"60",@"80",@"100"];
    lineChart.colors = @[RGB(235, 186, 158,1),RGB(160, 235, 227,1)];
    lineChart.renderColors = @[RGB(235, 186, 158,0.3),RGB(160, 235, 227,0.3)];
    lineChart.yValueMin = 0;
    lineChart.yValueMax = 100;
    lineChart.xLabelWidth = 30;
    [lineChart reloadViews];
    [self.view addSubview:lineChart];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
