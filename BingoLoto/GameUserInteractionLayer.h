//
//  GameUserInteractionLayer.h
//  BingoLoto
//
//  Created by Johann Huguenin on 10.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameUserInteractionLayer : CALayer
{
    NSMutableDictionary*buttonsToSelectors;
}

@property (assign) NSObject*actionsTarget;

+(GameUserInteractionLayer*)createWithFrame:(CGRect)aFrame actionsTarget:(NSObject*)aTarget;

-(void)addButton:(NSString*)anIdentifier selector:(NSString*)aSelectorString;
-(void)performActionForLayer:(CALayer*)aLayer;
-(void)spreadButtonsHorizontally;

@end

NS_ASSUME_NONNULL_END
