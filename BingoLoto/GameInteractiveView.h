//
//  GameInteractiveView.h
//  BingoLoto
//
//  Created by Johann Huguenin on 12.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameInteractiveView : UIView // To handle the touches
{
    
}

@property (nonatomic, retain) UIImageView*displayView;
@property (nonatomic, assign) CGRect displayArea;

- (void)setupView:(UIViewController*)aController withExitButton:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
