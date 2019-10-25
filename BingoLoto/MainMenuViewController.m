//
//  MainMenuViewController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 01.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "MainMenuViewController.h"
#import "NumberCallViewController.h"
#import "BingoPlayViewController.h"
#import "PDFDisplayAndShareViewController.h"
#import "OptionsTableViewController.h"
#import "BingoAsPDFDocument.h"
#import "UIView+Animations.h"
#import "AppManager.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>

//#define kUpgradeProductID @"com.sensetrails.bingoloto.upgrade"


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView*bg=(UIImageView*)self.view;
    
    [bg setImage:[UIImage imageNamed:@"Background.png"]];
    
    // Do any additional setup after loading the view.
    
    menuWidgets=[[NSMutableArray alloc]init];
    variantWidgets=[[NSMutableArray alloc]init];
    
    [menuWidgets addObject:playGameButton];
    [menuWidgets addObject:startCallingButton];
    [menuWidgets addObject:generateCardsButton];
    [menuWidgets addObject:optionsButton];
    
    [variantWidgets addObject:chooseVariantLabel];
    [variantWidgets addObject:chooseVariant75Button];
    [variantWidgets addObject:chooseVariant90Button];
    [variantWidgets addObject:backToMainButton];
    [AppManager sharedInstance];
    chooseVariantLabel.text = NSLocalizedString(@"Choose a game variant", @"");
    [self switchToMainMenu];
    
    upgradeButton.titleLabel.font = [UIFont fontWithName:@"Akrobat-Bold" size:18];
    upgradeButton.hidden = YES;
    if(![[AppManager sharedInstance] isPurchased]){
        [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                self->upgradeButton.hidden = NO;
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)purchaseMyProduct:(SKProduct*)product {
//    if ([self canMakePurchases]) {
//        SKPayment *payment = [SKPayment paymentWithProduct:product];
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        [[SKPaymentQueue defaultQueue] addPayment:payment];
//    } else {
//        [[AppManager sharedInstance] showAlert:@"Purchases are disabled in your device" message:nil controller:self];
//    }
//}
//

-(void)setVisibility:(BOOL)isVisible forItems:(NSArray*)someWidgets
{
    [CATransaction begin];
    
    for(UIView*aView in someWidgets)
    {
        if(isVisible)
        {
            [aView show];
        }
        else
        {
            [aView hide];
        }
    }
    
    [CATransaction commit];
    [CATransaction flush];
}

-(void)switchToMainMenu
{
    action=MA_NO_ACTION;
    variant=MV_NO_VARIANT;
    
    [self setVisibility:NO forItems:variantWidgets];
    [self setVisibility:YES forItems:menuWidgets];
}

-(void)switchToVariantMenu
{
    
    [self setVisibility:NO forItems:menuWidgets];
    [self setVisibility:YES forItems:variantWidgets];
}

- (IBAction)Back:(id)sender
{
    [[AppManager sharedInstance] buttonBackSound];
    
    [self switchToMainMenu];
}

- (IBAction)chooseMode:(id)sender
{
    
    action=(MENU_ACTIONS)[(UIButton*)sender tag];
    if(action == MA_GENERATE_CARDS)
        [[AppManager sharedInstance] printerSound];
    else
        [[AppManager sharedInstance] openMenuSound];
    
    [self switchToVariantMenu];
}

- (IBAction)chooseVariant:(id)sender
{
    [[AppManager sharedInstance] openMenuSound];
    
    UIViewController*presentController=nil;
    
    variant=(MENU_VARIANTS)[(UIButton*)sender tag];
    
    // Continue game here
    
    switch (action)
    {
        case MA_PLAY:
        {
            BingoPlayViewController*aController=[[BingoPlayViewController alloc]init];
            
            aController.variant=variant;
            presentController=aController;
            
            break;
        }
        case MA_CALL:
        {
            NumberCallViewController*aController=[[NumberCallViewController alloc]init];
            
            if(variant==MV_75)
            {
                [aController setStart:1 end:75 columns:15 rows:5];
            }
            else if(variant==MV_90)
            {
                [aController setStart:1 end:90 columns:10 rows:9];
            }
            
            presentController=aController;
            
            break;
        }
        case MA_GENERATE_CARDS:
        {
            BingoAsPDFDocument*pdf=[[BingoAsPDFDocument alloc]init];
            pdf.variant=variant;
            pdf.size=A4;
            
            [pdf generateGrids];
            
            presentController=[PDFDisplayAndShareViewController createPDFViewer:pdf.documentPath];
            
            break;
        }
        default:
            break;
            
            
    }
    
    if(presentController)
    {
        presentController.modalPresentationStyle=UIModalPresentationFullScreen;
        presentController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:presentController animated:YES completion:^{}];
    }
    
    [self switchToMainMenu];
}

- (IBAction)showOptions:(id)sender
{
    [[AppManager sharedInstance] openMenuSound];
    
    UIViewController*presentController=[OptionsTableViewController create];
    
    presentController.modalPresentationStyle=UIModalPresentationPageSheet;
    presentController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:presentController animated:YES completion:^{}];
    
}

- (IBAction)removeAds:(id)sender {
    if ([[RageIAPHelper sharedInstance] canMakePayments]) {
        SKProduct *product = [[RageIAPHelper sharedInstance].skProducts objectAtIndex:0];
        [[RageIAPHelper sharedInstance] buyProduct:product];
    } else {
        [[AppManager sharedInstance] showAlert:@"Purchases are disabled in your device" message:nil controller:self];
    }
}


- (void)productPurchased:(NSNotification *)notification {
    if([[AppManager sharedInstance] isPurchased]){
        upgradeButton.hidden = YES;
        [[AppManager sharedInstance] showAlert:@"Purchase is completed succesfully" message:nil controller:self];
    }
}

@end
