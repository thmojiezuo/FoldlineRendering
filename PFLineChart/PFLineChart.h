//
//  PFLineChart.h
//  LineChartDemo
//
//  Created by tenghu on 2017/11/30.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFLineChart : UIView

@property (strong, nonatomic) NSArray * yLabels;
@property (strong, nonatomic) NSArray * yValues;
@property (strong, nonatomic) NSArray * colors;
@property (strong, nonatomic) NSArray * renderColors;

@property (nonatomic, assign) CGFloat xLabelWidth;
@property (nonatomic, assign) CGFloat yValueMin;
@property (nonatomic, assign) CGFloat yValueMax;

- (void)reloadViews;

@end
