//
//  PFLineChart.m
//  LineChartDemo
//
//  Created by tenghu on 2017/11/30.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "PFLineChart.h"

#define YLabelMargin 50

@implementation PFLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)reloadViews {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self strokeChart];
}

#pragma mark - 划线
- (void)strokeChart{
    
    for (int i=0; i<_yValues.count; i++) {
        
        [self.layer addSublayer:[self creatBackground:i]];
        
    }
    
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
      
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapButt;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.lineWidth   = 1.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (_xLabelWidth/2.0)+YLabelMargin;
        CGFloat chartCavanHeight = self.frame.size.height;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        //第一个点
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight)];
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapButt];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade2 =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth+YLabelMargin, chartCavanHeight - grade2 * chartCavanHeight);
                [progressline addLineToPoint:point];
                [progressline moveToPoint:point];
               
            }
            index += 1;
        }
       
        _chartLine.path = progressline.CGPath;
        _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
       
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.01;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
    }
}

#pragma mark - creatBackground
- (CALayer *)creatBackground:(NSInteger)index {
    CALayer *layer = [CALayer layer];
    [layer addSublayer:[self creatGradient:index]];
    return layer;
}
#pragma mark - 进行渲染
- (CALayer *)creatGradient:(NSInteger)idex {  //创建梯度
    
    NSArray *childAry = _yValues[idex];
   
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
    CGFloat xPosition = (_xLabelWidth/2.0)+YLabelMargin;
    CGFloat chartCavanHeight = self.frame.size.height;
    
    float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    
    //第一个点
    [path moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight)];
    NSInteger index = 0;
    for (NSString * valueString in childAry) {
        
        float grade2 =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
        if (index != 0) {
            
            CGPoint point = CGPointMake(xPosition+index*_xLabelWidth+YLabelMargin, chartCavanHeight - grade2 * chartCavanHeight);
            [path addLineToPoint:point];
           
        }
        index += 1;
    }
    [path closePath];
    layer.frame = self.bounds;
    layer.lineWidth = CGFLOAT_MIN;
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.path = path.CGPath;
    
    
    CAGradientLayer *bgLayer = [self gradientLayerForBackground:[_renderColors objectAtIndex:idex]];
    bgLayer.bounds = CGRectMake(YLabelMargin, 0 , 0, 0);
    bgLayer.frame = CGRectMake(YLabelMargin, 0 , self.bounds.size.width , self.bounds.size.height);
    bgLayer.mask = layer;
    
    return bgLayer;

    
}

- (CAGradientLayer *)gradientLayerForBackground:(UIColor *)color {
    
    CAGradientLayer *layer =  [CAGradientLayer layer];
    [layer setColors:@[(__bridge id)color.CGColor,(__bridge id)color.CGColor, (__bridge id)color.CGColor]];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    layer.locations = @[@(0.1f) ,@(0.9f)];
    [layer setStartPoint:CGPointMake(0.5, 0.5)];
    [layer setEndPoint:CGPointMake(0.5, 0.8)];
    
    return layer;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIFont  *font = [UIFont systemFontOfSize:11];//设置
    
    //y轴数据
    [_yLabels enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = CGRectMake(0, self.bounds.size.height-idx*30 , YLabelMargin-10, 30);
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentRight;
        [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor grayColor]} context:nil];
        
    }];
    
    //y轴线
    CGContextSetLineWidth(context, 1.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, YLabelMargin, 0); //设置线的起始点
    CGContextAddLineToPoint(context, YLabelMargin, self.bounds.size.height); //设置线中间的一个点
    CGContextStrokePath(context);//直接把所有的点连起来
    
    //x轴线
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, YLabelMargin, self.bounds.size.height); //设置线的起始点
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height); //设置线中间的一个点
    CGContextStrokePath(context);//直接把所有的点连起来
    
    
}

@end
