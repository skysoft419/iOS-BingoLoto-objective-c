//
//  BingoAsPDFDocument.h
//  BingoLoto
//
//  Created by Johann Huguenin on 19.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BingoDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@interface BingoAsPDFDocument : NSObject
{
    CGContextRef pdf;
}

@property (assign) MENU_VARIANTS variant;
@property (assign) PAGE_SIZES size;
@property (retain, nullable) NSString*documentPath;

-(BOOL)generateGrids;

@end

NS_ASSUME_NONNULL_END
