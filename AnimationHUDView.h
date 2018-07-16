//
//  AnimationHUDView.h
//  locationDevice
//
//  Created by Jerry on 2018/7/9.
//  Copyright © 2018年 周玉举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationHUDView : UIView<CAAnimationDelegate>
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,weak)CAShapeLayer * oneLayer;
@property (nonatomic,weak)CAShapeLayer * midLayer;
@property (nonatomic,assign)BOOL firstStep;
@end
