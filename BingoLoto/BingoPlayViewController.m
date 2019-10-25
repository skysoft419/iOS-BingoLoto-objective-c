//
//  BingoPlayViewController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 12.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "BingoPlayViewController.h"
#import "GameInteractiveView.h"
#import "AppManager.h"
#import "RageIAPHelper.h"

@implementation BingoPlayViewController

-(void)loadView
{
    self.view=[[GameInteractiveView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

-(CGRect)constrainInRect:(CGRect)aDest withRatio:(CGSize)aRatio
{
    CGRect aRect=aDest;
    CGFloat withToHeightRatio=aRatio.width/aRatio.height;
    CGFloat currentWithToHeightRatio=aRect.size.width/aRect.size.height;
    
    if(currentWithToHeightRatio>withToHeightRatio)
    {
        aRect.size.width=aRect.size.height*withToHeightRatio;
    }
    else
    {
        aRect.size.height=aRect.size.width/withToHeightRatio;
    }
    
    aRect.origin.x=aDest.origin.x+(aDest.size.width-aRect.size.width)*0.5f;
    aRect.origin.y=aDest.origin.y+(aDest.size.height-aRect.size.height)*0.5f;
    
    return aRect;
}

-(void)exitToMainMenu:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    [[AppManager sharedInstance] buttonBackSound];

}

-(void)upgradeToPremium:(id)sender
{
    if ([[RageIAPHelper sharedInstance] canMakePayments]) {
        SKProduct *product = [[RageIAPHelper sharedInstance].skProducts objectAtIndex:0];
        [[RageIAPHelper sharedInstance] buyProduct:product];
    } else {
        [[AppManager sharedInstance] showAlert:@"Purchases are disabled in your device" message:nil controller:self];
    }
}

- (void)viewDidLoad
{
    GameInteractiveView*theView=((GameInteractiveView*)self.view);
    CALayer*mainLayer=theView.displayView.layer;
    CGSize ratio=CGSizeMake(1.0, 1.0);
    
    [super viewDidLoad];
    
    [theView setupView:self withExitButton:YES];
    
    // Do any additional setup after loading the view.
    
    if(self.variant==MV_90)
    {
        ratio=CGSizeMake(1.75, 1.0);
        numbersLayer=[NumberGridLayer bingo90Play];
    }
    else
    {
        numbersLayer=[NumberGridLayer bingo75Play];
    }
    
    numbersLayer.frame=[self constrainInRect:theView.displayArea withRatio:ratio];
//    [[AppManager sharedInstance] filledLineSound];

    [mainLayer addSublayer:numbersLayer];
    
    //added by PingLi
    if(![[AppManager sharedInstance] isPurchased]){
        self.interstitial=[[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-3021513607149156/4197187504"];
        [self.interstitial loadRequest:[[GADRequest alloc]init]];
        self.interstitial.delegate=self;
        self.numberClickedCount = 0;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAd) name:@"ShowAd" object:nil];
}

-(void)handleUserActions:(NSNotification*)aNotification
{
    CALayer*aLayer=[aNotification object];
    
    if(aLayer)
    {
        [numbersLayer touchedLayer:aLayer];
    }

}

- (void) showAd
{
    if(![[AppManager sharedInstance] isPurchased]){
//                self.numberClickedCount++;
        //        if(self.numberClickedCount % 3 == 0){
        if(self.interstitial.isReady)
        {
            [self.interstitial presentFromRootViewController:self];
        }
        else
        {

            NSLog(@"Ad wasn't ready");
        }
        //        }
    }
}

- (void)interstitialDidDismissScreen:(nonnull GADInterstitial *)ad
{
    self.interstitial=[[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-3021513607149156/4197187504"];
    [self.interstitial loadRequest:[[GADRequest alloc]init]];
    self.interstitial.delegate=self;
}

@end
