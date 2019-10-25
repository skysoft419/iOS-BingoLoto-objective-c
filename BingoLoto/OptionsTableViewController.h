//
//  OptionsTableViewController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 20.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionsTableViewController : UITableViewController

@property (assign) int lastSelectredDoc;
@property (assign) int lastSelectredLan;
@property (strong) NSIndexPath*lastIndexPath;
+(UINavigationController*)create;

- (IBAction)soundOnOffAction:(id)sender;
- (IBAction)speechOnOffAction:(id)sender;
- (IBAction)speechSpeedAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
