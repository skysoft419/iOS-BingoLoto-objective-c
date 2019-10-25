//
//  Constants.h
//  BingoLoto
//
//  Created by Ping on 5/30/19.
//  Copyright (c) 2019 Ping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface AppManager : NSObject

+(AppManager *) sharedInstance;
-(AppManager *) init;
- (void) soundPlay:(NSString*)fileName;
- (void) buttonBackSound;
- (void) fullLineSound;
- (void) filledLineSound;
- (void) openMenuSound;
- (void) pauseGameSound;
- (void) playSound;
- (void) printerSound;
- (void) tappingSound;
- (BOOL) isSoundOn;
- (BOOL) isSpeechOn;
- (float) speechSpeed;
- (BOOL) isDocA4;
- (BOOL) isPurchased;
- (void) setPurchased:(BOOL) purchased;
- (NSInteger) languageSelect;
- (void) showAlert:(NSString*)title message:(NSString*)message controller:(UIViewController*)controller;
@end
