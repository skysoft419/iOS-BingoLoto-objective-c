//
//  UIView+Animations.m
//  BingoLoto
//
//  Created by Johann Huguenin on 01.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "UIView+Animations.h"

const CGFloat kAnimationTime=0.5;

@implementation UIView (CustomAnimations)

-(void)show
{
    [UIView animateWithDuration:kAnimationTime
                     animations:^{
                         self.hidden=NO;
                         self.alpha=1.0;
                     } completion:^(BOOL finished){}];
}

-(void)hide
{
    [UIView animateWithDuration:kAnimationTime
                     animations:^{
                         self.alpha=0.0;
                     }completion:^(BOOL finished){self.hidden=YES;}];
}

@end
