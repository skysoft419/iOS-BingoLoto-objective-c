//
//  GameUserInteractionLayer.m
//  BingoLoto
//
//  Created by Johann Huguenin on 10.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "GameUserInteractionLayer.h"

@implementation GameUserInteractionLayer

+(GameUserInteractionLayer*)createWithFrame:(CGRect)aFrame actionsTarget:(NSObject*)aTarget
{
    GameUserInteractionLayer*aLayer=[GameUserInteractionLayer layer];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat aspect_rate = aFrame.size.width/aFrame.size.height;
    aFrame.size.width = screenWidth*9/16;
    aFrame.size.height = screenWidth*3/16;
    if (aspect_rate > 2.2) {
        CGFloat pos_x = screenWidth*2.7/16;
        CGFloat pos_y = screenWidth*1.04/16;
        aLayer.frame=aFrame;
        aLayer.position = CGPointMake(aLayer.position.x + pos_x, aLayer.position.y + pos_y);
    }else{
        CGFloat pos_x = (screenWidth - screenWidth*7/10)/2;
        CGFloat pos_y = (screenHeight - screenWidth*3/10)/2;
        aLayer.frame=aFrame;
        aLayer.position = CGPointMake(aLayer.position.x + pos_x, aLayer.position.y + pos_y);
    }
    aLayer.actionsTarget=aTarget;
    
    return aLayer;
}

-(id)init
{
    self=[super init];
    
    buttonsToSelectors=[[NSMutableDictionary alloc]init];
    
    return self;
}

-(void)addButton:(NSString*)anIdentifier selector:(NSString*)aSelectorString
{
    CALayer *layer = [CALayer layer];
    
    NSString*imageFile = [anIdentifier stringByAppendingFormat:@".png"];
    layer.contents = (id) [UIImage imageNamed:imageFile].CGImage;
    layer.borderColor = [UIColor blackColor].CGColor;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.name = anIdentifier;
    [self addSublayer:layer];
    
    [buttonsToSelectors setObject:aSelectorString forKey:anIdentifier];
    [self spreadButtonsHorizontally];
}

-(void)performActionForLayer:(CALayer*)aLayer
{
    if(aLayer)
    {
        NSString*aSelector=[buttonsToSelectors objectForKey:aLayer.name];
        
        if(aSelector)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            (void)[self.actionsTarget performSelector:NSSelectorFromString(aSelector) withObject:self];
#pragma clang diagnostic pop
        }
    }
}

-(void)spreadButtonsHorizontally
{
    static const CGFloat kGutter=16.0f;
    
    CGRect r=CGRectInset(self.bounds, 0, 0);
    NSArray*children=[self sublayers];
    NSInteger count=[children count];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if(count>0)
        {
            //        r.size.height = self.bounds.size.height*2 / 5;
            r.size.width-=kGutter*(count-1);
            r.size.width/=count;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            for(CALayer*aLayer in children)
            {
                aLayer.frame=r;
                r.origin.x+=r.size.width;
                r.origin.x+=kGutter;
            }
            
            [CATransaction commit];
        }
        
    }else{
        if(count>0)
        {//        r.size.height = self.bounds.size.height*2 / 5;
            r.size.width-=kGutter*(count-1);
            r.size.width/=count;
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            for(CALayer*aLayer in children)
            {
                aLayer.frame=r;
                r.origin.x+=r.size.width;
                r.origin.x+=kGutter;
            }
            
            [CATransaction commit];
        }
    }
    
}

@end
