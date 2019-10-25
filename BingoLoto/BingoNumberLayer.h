//
//  BingoNumberLayer.h
//  BingoLoto
//
//  Created by Johann Huguenin on 02.04.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

extern const NSInteger kGrayedOut; // Cell filled with color
extern const NSInteger kStaredOut; // Cell filled with a start (Bingo 75 only)
extern const NSInteger kQuestionedOut; // Demo mode will have a question mark for 1 number in the card

NS_ASSUME_NONNULL_BEGIN

@interface BingoNumberLayer : CALayer
{
    
}

@property (assign) NSInteger value;
@property (assign) CGFloat border;
@property (retain) UIColor*color;

+(BingoNumberLayer*)layerWithFrame:(CGRect)aFrame value:(NSInteger)aValue color:(UIColor*)aColor thickness:(CGFloat)borderWidth;

- (void)drawInContext:(CGContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
