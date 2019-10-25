//
//  NumberGridLayer.h
//  BingoLoto
//
//  Created by Johann Huguenin on 11.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingoDefinitions.h"

NS_ASSUME_NONNULL_BEGIN
#define UIColorFromRGB(rgbHex) [UIColor colorWithRed:((float)((rgbHex & 0xFF0000) >> 16))/255.0 green:((float)((rgbHex & 0xFF00) >> 8))/255.0 blue:((float)(rgbHex & 0xFF))/255.0 alpha:1.0]

@interface NumberGridLayer : CALayer
{
    NSUInteger columns;
    NSUInteger rows;
    NSUInteger complatedLinesMV_90;

    CALayer*gridLayer;
    CGRect tb; // Tiles bounds
}

@property (retain) NSArray*numbers;
@property (retain) NSMutableArray*activeNumbers;
@property (retain) NSMutableArray*fullRows;
@property (retain) NSMutableArray*fullColumns;
@property (retain) NSMutableArray*fullDiagonals;

@property (assign) MENU_VARIANTS variant;

+(NumberGridLayer*)bingo90Call;
+(NumberGridLayer*)bingo75Call;

+(NumberGridLayer*)bingo90Play;
+(NumberGridLayer*)bingo75Play;

-(void)setNumbers:(NSArray*)someNumbers Columns:(NSUInteger)someColumns rows:(NSUInteger)someRows; // Numbers are in order of display col,row (x,y) and can have NaN as gray cells
-(void)reset;

-(void)touchedLayer:(CALayer*)aLayer;

/** Render the grid into a frame destination as PDF */
-(void)renderInPDF:(CGContextRef)aContext inFrame:(CGRect)aFrame;

@end

NS_ASSUME_NONNULL_END
