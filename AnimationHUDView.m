//
//  AnimationHUDView.m
//  locationDevice
//
//  Created by Jerry on 2018/7/9.
//  Copyright © 2018年 周玉举. All rights reserved.
//  111

#import "AnimationHUDView.h"
@implementation AnimationHUDView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //增加动画
        CGFloat replicatorLayerWidth = 80;
        CALayer *fourRound = [self loadingReplicatorLayer_SquareWithWidth:replicatorLayerWidth];
        [self.layer addSublayer:fourRound];
        fourRound.bounds = CGRectMake(0, 0, replicatorLayerWidth, replicatorLayerWidth);
        fourRound.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    }
    return self;
}

- (CALayer *)loadingReplicatorLayer_SquareWithWidth:(CGFloat)width
{
    //创建单个圆
    CGFloat sigleSquareDiameter = 20;
    self.oneLayer = [self creatShapeLayerWithRadius:sigleSquareDiameter];
    [self.oneLayer addAnimation:[self addReplicatorLayerRotationAnimaitonWithTranslateX:width - sigleSquareDiameter] forKey:@"transform"];
    //复制多个同样的圆
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D = CATransform3DRotate(transform3D, 90.0*M_PI/180.0, 0, 0, 1.0);
    CAReplicatorLayer *replicatorLayer = [self creatReplicatorLayerWithCount:4 tranform:transform3D copyLayer:self.oneLayer];
    self.midLayer = [self addMidShapeLayerWith:width];
    [replicatorLayer addSublayer:self.midLayer];
    return replicatorLayer;
}

- (CAShapeLayer *)addMidShapeLayerWith:(CGFloat)width{
    CAShapeLayer * circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2) radius:width/5 startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
    circle.strokeColor = [UIColor cyanColor].CGColor;
    circle.fillColor = [UIColor cyanColor].CGColor;
    [circle addAnimation:[self addOpacityAnimation] forKey:@"opacity"];
    return circle;
}

- (CAAnimationGroup *)addReplicatorLayerRotationAnimaitonWithTranslateX:(CGFloat)translateX
{
    _firstStep = YES;
    //类方法实例化
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    //移动到起点
    [bezier moveToPoint:CGPointMake(0, 0)];
    /*
     第一个参数：终点
     第二个参数：转折点
     */
    [bezier addQuadCurveToPoint:CGPointMake(40, 55) controlPoint:CGPointMake(100, 20)];
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = bezier.CGPath;
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.3]; // 结束时的倍率
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = 0.8f;
    animaGroup.repeatCount = 1;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.removedOnCompletion = NO;
    animaGroup.animations = @[animation,moveAnim];
    animaGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animaGroup.delegate = self;
    return animaGroup;
}

- (CAAnimationGroup *)addNextReplicatorLayerRotationAnimaitonWithTranslateX:(CGFloat)translateX
{
    _firstStep = NO;
    //类方法实例化
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    //移动到起点
    [bezier moveToPoint:CGPointMake(40, 55)];
    /*
     第一个参数：终点
     第二个参数：转折点
     */
    [bezier addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(20, 60)];
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = bezier.CGPath;
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.3]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = 0.8f;
    animaGroup.repeatCount = 1;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.removedOnCompletion = NO;
    animaGroup.animations = @[animation,moveAnim];
    animaGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animaGroup.delegate = self;
    return animaGroup;
}


#pragma mark - 创建Layer
- (CAShapeLayer *)creatShapeLayerWithRadius:(CGFloat)radius
{
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, 0, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.strokeColor = [UIColor cyanColor].CGColor;
    shape.fillColor = [UIColor cyanColor].CGColor;
    return shape;
}
//中心圆透明度变化--
- (CAAnimation *)addOpacityAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1.6;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //配置起始位置（fromeVaue）和终止位置（toValue）
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0);
    //防止执行完成后移除
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.repeatCount = HUGE;
    return opacityAnimation;
}

- (CAReplicatorLayer *)creatReplicatorLayerWithCount:(NSInteger)count tranform:(CATransform3D) transform  copyLayer:(CALayer*)copyLayer
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = count;
    replicatorLayer.instanceTransform = transform;
    replicatorLayer.frame = copyLayer.frame;
    [replicatorLayer addSublayer:copyLayer];
    return replicatorLayer;
}
//动画组按顺序执行
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (_firstStep) {
        [self.oneLayer addAnimation:[self addNextReplicatorLayerRotationAnimaitonWithTranslateX:150 - 80] forKey:@"transform"];
    }else{
        [self.oneLayer addAnimation:[self addReplicatorLayerRotationAnimaitonWithTranslateX:150 - 80] forKey:@"transform"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
