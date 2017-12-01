//
//  PFLineChart.h
//  LineChartDemo
//
//  Created by tenghu on 2017/11/30.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFLineChart : UIView

@property (strong, nonatomic) NSArray * yLabels;  //Y轴上的数据
@property (strong, nonatomic) NSArray * xLabels;  //X轴上的数据
@property (strong, nonatomic) NSArray * yValues;  // 折线图上的点数据
@property (strong, nonatomic) NSArray * colors;   //折线的颜色
@property (strong, nonatomic) NSArray * renderColors;   //折线下面渲染的颜色

@property (nonatomic, assign) CGFloat xLabelWidth;   //每隔多长有一个点
@property (nonatomic, assign) CGFloat yValueMin;    //数据源里最小值
@property (nonatomic, assign) CGFloat yValueMax;   //数据源里最大值
@property (nonatomic, assign) CGFloat bottomValues;   //X轴上数据的高度

- (void)reloadViews;  //加载数据源

@end
