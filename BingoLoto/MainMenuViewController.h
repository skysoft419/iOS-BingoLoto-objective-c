//
//  MainMenuViewController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 01.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "BingoDefinitions.h"

NS_ASSUME_NONNULL_BEGIN


@interface MainMenuViewController : UIViewController {
    
    UIActivityIndicatorView *activityIndicatorView;
    
    
    __weak IBOutlet UIButton*playGameButton;
    __weak IBOutlet UIButton*startCallingButton;
    __weak IBOutlet UIButton*generateCardsButton;
    
    __weak IBOutlet UIButton*optionsButton;
    
    __weak IBOutlet UILabel *chooseVariantLabel;
    __weak IBOutlet UIButton*chooseVariant75Button;
    __weak IBOutlet UIButton*chooseVariant90Button;
    __weak IBOutlet UIButton*backToMainButton;
    __weak IBOutlet UIButton *upgradeButton;
    
    NSMutableArray*menuWidgets;
    NSMutableArray*variantWidgets;
    
    MENU_ACTIONS action;
    MENU_VARIANTS variant;
}

- (IBAction)chooseMode:(id)sender;
- (IBAction)chooseVariant:(id)sender;

- (IBAction)showOptions:(id)sender;
- (IBAction)removeAds:(id)sender;

@end

NS_ASSUME_NONNULL_END
