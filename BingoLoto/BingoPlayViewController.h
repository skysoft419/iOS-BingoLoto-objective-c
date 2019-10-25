//
//  BingoPlayViewController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 12.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInteractiveView.h"
#import "NumberGridLayer.h"
#import "BingoDefinitions.h"

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface BingoPlayViewController : UIViewController<GADInterstitialDelegate>
{
    NumberGridLayer*numbersLayer;
}

@property (assign) MENU_VARIANTS variant;
@property (retain) GADInterstitial*interstitial;
@property (assign) int numberClickedCount;

-(void)upgradeToPremium:(id)sender;

@end

NS_ASSUME_NONNULL_END
