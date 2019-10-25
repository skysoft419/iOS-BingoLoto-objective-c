//
//  GameInteractiveView.m
//  BingoLoto
//
//  Created by Johann Huguenin on 12.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "GameInteractiveView.h"
#import "Common/AppManager.h"

@implementation GameInteractiveView // To handle the touches

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        UIImageView*background=[[UIImageView alloc]initWithFrame:frame];
        
        background.image=[UIImage imageNamed:@"Background.png"];
        background.contentMode=UIViewContentModeScaleAspectFill;
        
        self.displayView=background;
        
        [self addSubview:background];
    }
    
    return self;
}

- (void)setupView:(UIViewController*)aController withExitButton:(BOOL)flag
{
    static const CGFloat sideMargin=16.0f;
    static const CGFloat verticalMargin=60.0f;
    self.displayArea=CGRectInset(self.bounds, sideMargin, verticalMargin);
   
    if(flag)
    {
        UIButton* exitButton=[[UIButton alloc]initWithFrame:CGRectMake(self.displayArea.origin.x+self.displayArea.size.width-(verticalMargin*1.5)-sideMargin, sideMargin, (verticalMargin*1.5), verticalMargin)];
        
        [exitButton setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
        [exitButton addTarget:aController action:@selector(exitToMainMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exitButton];
    }
    
    if(![[AppManager sharedInstance] isPurchased]){
        UIButton* upgradeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [upgradeButton setTitle:NSLocalizedString(@"Upgrade to premium version to get all numbers", @"") forState:UIControlStateNormal];
        upgradeButton.titleLabel.font = [UIFont fontWithName:@"Akrobat-Bold" size:18];
        upgradeButton.tintColor = UIColor.whiteColor;
        [upgradeButton sizeToFit];

        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
        {
            upgradeButton.frame = CGRectMake(self.displayArea.origin.x+(self.displayArea.size.width-upgradeButton.frame.size.width)/2, aController.view.frame.size.height - upgradeButton.frame.size.height - 2 , upgradeButton.frame.size.width, upgradeButton.frame.size.height);
        }else{
            upgradeButton.frame = CGRectMake(self.displayArea.origin.x+(self.displayArea.size.width-upgradeButton.frame.size.width)/2, aController.view.frame.size.height - upgradeButton.frame.size.height - 10 , upgradeButton.frame.size.width, upgradeButton.frame.size.height);
        }

        [upgradeButton addTarget:aController action:@selector(upgradeToPremium:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upgradeButton];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:aController];
    
    [[NSNotificationCenter defaultCenter]addObserver:aController selector:@selector(handleUserActions:) name:@"TouchedLayer" object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*aTouch=[touches anyObject];
    CGPoint point = [aTouch locationInView:[aTouch view]];
    CALayer *layer = [(CALayer *)self.layer.presentationLayer hitTest:point];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TouchedLayer" object:layer];
}

@end
