//
//  ViewController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 26.01.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInteractiveView.h"

@import Firebase;

@interface NumberCallViewController : UIViewController <GADInterstitialDelegate>

-(IBAction)pause:(id)sender; //Tap anywhere on screen to pause

-(IBAction)start:(id)sender; //Start or continue game
-(IBAction)restart:(id)sender; //Reset and restart game
-(IBAction)exit:(id)sender; //Back to menu

-(void)setStart:(NSUInteger)aStart end:(NSUInteger)anEnd columns:(NSUInteger)someColumns rows:(NSUInteger)someRows;
-(void)upgradeToPremium:(id)sender;

@end
