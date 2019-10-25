//
//  NumberGridLayer.m
//  BingoLoto
//
//  Created by Johann Huguenin on 11.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "NumberGridLayer.h"
#import "BingoNumberLayer.h"
#import "AppManager.h"
#define UIColorFromRGB(rgbHex) [UIColor colorWithRed:((float)((rgbHex & 0xFF0000) >> 16))/255.0 green:((float)((rgbHex & 0xFF00) >> 8))/255.0 blue:((float)(rgbHex & 0xFF))/255.0 alpha:1.0]

@implementation NumberGridLayer

+(NumberGridLayer*)bingo90Call
{
    NumberGridLayer*aLayer=[NumberGridLayer layer];
    NSMutableArray*theNumbers=[NSMutableArray arrayWithCapacity:90];
    
    aLayer.frame=CGRectMake(0.0,0.0,320.0,320.0);
    
    for(NSUInteger i=1,j=90;i<=j;i++)
    {
        [theNumbers addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    [aLayer setNumbers:theNumbers Columns:10 rows:9];
    
    return aLayer;
}

+(NumberGridLayer*)bingo75Call
{
    NumberGridLayer*aLayer=[NumberGridLayer layer];
    NSMutableArray*theNumbers=[NSMutableArray arrayWithCapacity:90];
    
    aLayer.frame=CGRectMake(0.0,0.0,320.0,320.0);
    
    for(NSUInteger i=1,j=75;i<=j;i++)
    {
        [theNumbers addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    [aLayer setNumbers:theNumbers Columns:15 rows:5];
    
    return aLayer;
}

+(NumberGridLayer*)bingo90Play
{
    NSUInteger rows=3;
    NSUInteger columns=9;

    NumberGridLayer*aLayer=[NumberGridLayer layer];
    NSMutableArray*theNumbers=[NSMutableArray arrayWithCapacity:rows*columns];
    
    enum GRAY_CELL_MODE
    {
        ONE_UP,
        ONE_CENTER,
        ONE_DOWN,
        TWO_UP,
        TWO_UP_DOWN,
        TWO_DOWN,
        GRAY_CELL_MAX
    };
    
    aLayer.variant=MV_90;
    
    for(NSUInteger i=0,j=rows*columns;i<j;i++)
    {
        [theNumbers addObject:[NSNumber numberWithInt:0]];
    }
    
    aLayer.frame=CGRectMake(0.0,0.0,320.0,320.0);
    
    NSMutableArray*mask=[NSMutableArray arrayWithCapacity:columns]; // Add 3*2 and 6*1 mask here
    
    for(NSUInteger i=0;i<3;i++)
    {
        NSUInteger grayCells=(arc4random_uniform((u_int32_t)TWO_UP))+3; // Add 3*2
        
        [mask addObject:[NSNumber numberWithUnsignedInteger:grayCells]];
    }
    
    for(NSInteger i=0;i<6;i++)
    {
        NSUInteger grayCells=(arc4random_uniform((u_int32_t)TWO_UP)); // Add 6*1
        
        [mask addObject:[NSNumber numberWithUnsignedInteger:grayCells]];
    }
    
    /* Randomize the array */
    
    for (NSUInteger i = mask.count; i > 1; i--)
    {
        [mask exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    
    for(NSInteger i=0;i<columns;i++)
    {
        NSMutableArray*aColumn=[NSMutableArray arrayWithCapacity:3];
        NSUInteger mod=((i+1)==columns) ? 10 : 9;
        
        for(NSUInteger x=0,y=rows;x<y;x++)
        {
            NSUInteger aNumber=1+(i*10)+(arc4random_uniform((u_int32_t)mod));
            NSNumber*numberToAdd=[NSNumber numberWithUnsignedInteger:aNumber];
            
            if([aColumn containsObject:numberToAdd]==NO)
            {
                [aColumn addObject:numberToAdd];
            }
            else
            {
                x--;
            }
        }
        
        [aColumn sortUsingSelector:@selector(compare:)]; // Lower number first
        
        // Replace some numbers in the column with gray cells
        
        NSNumber*grayCellNumber=[NSNumber numberWithInt:-1];
        
        NSUInteger grayCells=[[mask objectAtIndex:i]unsignedIntegerValue];
        
        if(grayCells==ONE_UP || grayCells==TWO_UP || grayCells==TWO_UP_DOWN)
        {
            /* Replace top cell */
            
            [aColumn replaceObjectAtIndex:0 withObject:grayCellNumber];
        }
        
        if(grayCells==ONE_CENTER || grayCells==TWO_UP || grayCells==TWO_DOWN)
        {
            /* Replace top cell */
            
            [aColumn replaceObjectAtIndex:1 withObject:grayCellNumber];
        }
        
        if(grayCells==ONE_DOWN || grayCells==TWO_UP_DOWN || grayCells==TWO_DOWN)
        {
            /* Replace top cell */
            
            [aColumn replaceObjectAtIndex:2 withObject:grayCellNumber];
        }
        
        /* Add to the main number table */
        
        for(NSUInteger x=0;x<rows;x++)
        {
            NSUInteger destIndex=i+x*columns;
            
            [theNumbers replaceObjectAtIndex:destIndex withObject:[aColumn objectAtIndex:x]];
            
        }
    }
//    if(![[AppManager sharedInstance] isPurchased]){
//        NSUInteger questionIndex = arc4random() % 27;
//        while(1)
//        {
//            if([[theNumbers objectAtIndex:questionIndex] intValue] != -1)
//            {
//                [theNumbers replaceObjectAtIndex:questionIndex withObject:[NSNumber numberWithInteger:kQuestionedOut]];
//                break;
//            }else{
//                questionIndex = arc4random() % 27;
//            }
//        }
//    }
    
    [aLayer setNumbers:theNumbers Columns:columns rows:rows];
    
    return aLayer;
}

+(NumberGridLayer*)bingo75Play
{
    NSUInteger rows=5;
    NSUInteger columns=5;
    
    NumberGridLayer*aLayer=[NumberGridLayer layer];
    NSMutableArray*theNumbers=[NSMutableArray arrayWithCapacity:rows*columns];

    aLayer.variant=MV_75;
    
    aLayer.frame=CGRectMake(0.0,0.0,320.0,320.0);

    // Fill the array with random numbers
    
    for(NSUInteger x=0,y=rows*columns;x<y;x++)
    {
        NSUInteger aNumber=1+(arc4random_uniform((u_int32_t)75));
        NSNumber*numberToAdd=[NSNumber numberWithUnsignedInteger:aNumber];
        
        if([theNumbers containsObject:numberToAdd]==NO)
        {
            [theNumbers addObject:numberToAdd];
        }
        else
        {
            x--;
        }
    }
    
    /* Put a gray cell in the center */
    
    NSUInteger destIndex=2+2*columns;
    
    [theNumbers replaceObjectAtIndex:destIndex withObject:[NSNumber numberWithInteger:kStaredOut]];

    if(![[AppManager sharedInstance] isPurchased]){
        NSUInteger questionIndex = arc4random() % 25;
        while (questionIndex == destIndex) {
            questionIndex = arc4random()% 25;
        }
    //    rand();
        [theNumbers replaceObjectAtIndex:questionIndex withObject:[NSNumber numberWithInteger:kQuestionedOut]];
    }
    
    [aLayer setNumbers:theNumbers Columns:columns rows:rows];
    
    return aLayer;
}

-(void)setNumbers:(NSArray*)someNumbers Columns:(NSUInteger)someColumns rows:(NSUInteger)someRows
{
    self.numbers=someNumbers;
    
    columns=someColumns;
    rows=someRows;
}

-(void)reset
{
    NSUInteger index=0;
    complatedLinesMV_90 = 0;
    CGRect mb=self.bounds;
    CGRect gb=CGRectInset(mb, 19.0f, 19.0f);
    
    self.borderWidth = 10;
//    self.borderColor = [UIColor colorWithRed:0.73 green:0.54 blue:0.11 alpha:1.0].CGColor;

    self.backgroundColor=[UIColor whiteColor].CGColor;
    self.borderColor = [UIColorFromRGB(0xB95C6E) CGColor];
    self.cornerRadius = 20;

    self.activeNumbers=[NSMutableArray arrayWithCapacity:columns*rows];
    self.fullRows=[NSMutableArray arrayWithCapacity:rows];
    self.fullColumns=[NSMutableArray arrayWithCapacity:columns];
    self.fullDiagonals=[NSMutableArray arrayWithCapacity:2];
    
    if(mb.size.width != mb.size.height){
        tb=CGRectMake(0.0, 0.0, gb.size.width/columns, gb.size.height/rows);
        
        [gridLayer removeFromSuperlayer];
        
        gridLayer=[CALayer layer];
        CGRect gb_1=CGRectInset(mb, 14.0f, 14.0f);
        gridLayer.frame=gb_1;
        gridLayer.cornerRadius = 10;
        gridLayer.backgroundColor = [UIColorFromRGB(0xC81F20) CGColor];
        gridLayer.borderWidth = 5;
        gridLayer.borderColor = [UIColorFromRGB(0xC81F20) CGColor];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        for(NSUInteger y=0;y<rows;y++)
        {
            for(NSUInteger x=0;x<columns;x++)
            {
                NSNumber*n=[self.numbers objectAtIndex:index];
                CGPoint p=CGPointMake(x*tb.size.width+(0.5*tb.size.width) + 5, y*tb.size.height+(0.5*tb.size.height) + 5);
                
                /* Compute layer position on grid */
                
                BingoNumberLayer*aLayer=[BingoNumberLayer layerWithFrame:tb value:[n integerValue] color:UIColorFromRGB(0xC81F20) thickness:4.0f];
                aLayer.borderColor=[UIColor whiteColor].CGColor;
                if([n integerValue] != -1)
                    aLayer.backgroundColor=[UIColor whiteColor].CGColor;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    aLayer.borderWidth = 5;
                else
                    aLayer.borderWidth = 2;

                aLayer.cornerRadius = 10;
                aLayer.position=p;
                
                [gridLayer addSublayer:aLayer];
                [aLayer setNeedsDisplay];
                
                index++;
            }
        }
        
        gridLayer.position=CGPointMake(mb.size.width*0.5,mb.size.height*0.5);
       // gridLayer.cornerRadius = 9;
    }else{
        self.borderWidth = 5;
        self.cornerRadius = 0;
        // out border
        self.borderColor = [UIColorFromRGB(0xFF0000) CGColor];
        gb=CGRectInset(mb, 5.0f, 5.0f);
        tb=CGRectMake(0.0, 0.0, gb.size.width/columns, gb.size.height/rows);
        [gridLayer removeFromSuperlayer];
        gridLayer=[CALayer layer];
        gridLayer.frame=gb;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        for(NSUInteger y=0;y<rows;y++)
        {
            for(NSUInteger x=0;x<columns;x++)
            {
                NSNumber*n=[self.numbers objectAtIndex:index];
                CGPoint p=CGPointMake(x*tb.size.width+(0.5*tb.size.width), y*tb.size.height+(0.5*tb.size.height));
                
                /* Compute layer position on grid 0x0B3D3B*/
                
                BingoNumberLayer*aLayer=[BingoNumberLayer layerWithFrame:tb value:[n integerValue] color:UIColorFromRGB(0xFF3D3B) thickness:5.0f];
                aLayer.position=p;
                
                [gridLayer addSublayer:aLayer];
                [aLayer setNeedsDisplay];
                
                index++;
            }
        }
        
        gridLayer.position=CGPointMake(mb.size.width*0.5,mb.size.height*0.5);
       // gridLayer.cornerRadius = 9;
    }

    [self addSublayer:gridLayer];
    
    [CATransaction commit];
}

-(void)layoutSublayers
{
    [self reset];
}

-(void)touchedLayer:(CALayer*)aLayer
{
    NSInteger aNumber=[[aLayer name]integerValue];
    if(aNumber > 0)
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowAd" object:nil];
    
    NSNumber*aNumberObject=[NSNumber numberWithInteger:aNumber];
    NSInteger anIndex=[self.numbers indexOfObject:aNumberObject];
    if(anIndex!=NSNotFound)
    {
        CATextLayer*aCell=[[gridLayer sublayers] objectAtIndex:anIndex];
        if(aNumber>0)
        {
            if([self.activeNumbers containsObject:aNumberObject]==NO)
            {
                NSUInteger aRow=anIndex/columns;
                NSUInteger aColumn=anIndex%columns;
                CALayer *sublayer = [CALayer layer];
                sublayer.opacity = 0.5;
// ball mask
                sublayer.frame = CGRectMake(aCell.bounds.size.width * 0.07, aCell.bounds.size.height * 0.07, aCell.bounds.size.width * 0.85, aCell.bounds.size.height * 0.85);
                sublayer.contents = (id) [UIImage imageNamed:@"BingoLoto_Transparent_Cover.png"].CGImage;
                sublayer.contentsGravity = kCAGravityResizeAspect;
                [aCell addSublayer:sublayer];
                
                [self.activeNumbers addObject:aNumberObject];
                
                [self checkCompleteLineWithNumberAtColumn:aColumn row:aRow];
            }
        }
    }
}

-(CATextLayer*)cellAtRow:(NSUInteger)aRow columns:(NSUInteger)aColumn
{
    NSUInteger destIndex=aColumn+aRow*columns;
    
    return [[gridLayer sublayers]objectAtIndex:destIndex];
}

-(NSNumber*)numberForCellAtRow:(NSUInteger)aRow columns:(NSUInteger)aColumn
{
    CATextLayer*aLayer=[self cellAtRow:aRow columns:aColumn];
    NSInteger num=[[aLayer name]integerValue];
    
    return [NSNumber numberWithInteger:num];
}

-(NSArray*)checkLinesAndReturnNewComplete
{
//    NSNumber*greyCell=[NSNumber numberWithInteger:kGrayedOut];
//    NSNumber*starCell=[NSNumber numberWithInteger:kStaredOut];
    NSMutableArray*newLines=[NSMutableArray arrayWithCapacity:rows];
    
    for(NSUInteger y=0;y<rows;y++)
    {
        BOOL allSet=YES;
        
        for(NSUInteger x=0;x<columns;x++)
        {
            NSNumber*aNumber=[self numberForCellAtRow:y columns:x];
            
            if([aNumber integerValue]<=kGrayedOut && [aNumber integerValue] != kQuestionedOut)
            {
                continue;
            }

            if([self.activeNumbers containsObject:aNumber]==NO)
            {
                allSet=NO;
                break;
            }
        }
        
        NSNumber*aLineID=[NSNumber numberWithUnsignedInteger:y];
        
        if(allSet && [self.fullRows containsObject:aLineID]==NO)
        {
            [self.fullRows addObject:aLineID];
            [newLines addObject:aLineID];
        }
    }
    
    return newLines;
}

-(NSArray*)checkColumsAndReturnNewComplete
{
//    NSNumber*greyCell=[NSNumber numberWithInteger:kGrayedOut];
//    NSNumber*starCell=[NSNumber numberWithInteger:kStaredOut];
    NSMutableArray*newColumns=[NSMutableArray arrayWithCapacity:columns];
    
    for(NSUInteger x=0;x<columns;x++)
    {
        BOOL allSet=YES;
        
        for(NSUInteger y=0;y<rows;y++)
        {
            NSNumber*aNumber=[self numberForCellAtRow:y columns:x];
            
            if([aNumber integerValue]<=kGrayedOut && [aNumber integerValue] != kQuestionedOut)
            {
                continue;
            }
            
            if([self.activeNumbers containsObject:aNumber]==NO)
            {
                allSet=NO;
                break;
            }
        }
        
        NSNumber*aColumnID=[NSNumber numberWithUnsignedInteger:x];
        
        if(allSet && [self.fullColumns containsObject:aColumnID]==NO)
        {
            [self.fullColumns addObject:aColumnID];
            [newColumns addObject:aColumnID];
        }
    }
    
    return newColumns;
}

-(NSArray*)checkDiagonalsAndReturnNewComplete
{
//    NSNumber*greyCell=[NSNumber numberWithInteger:-1];
    NSMutableArray*newDiagonals=[NSMutableArray arrayWithCapacity:rows];
    
    assert(rows==columns); // Only square are supported to check diagonal
    
    BOOL allSet=YES;
    NSNumber*diagonalID=[NSNumber numberWithUnsignedInteger:0];
    
    for(NSUInteger x=0,y=0;x<columns;x++,y++)
    {
        NSNumber*aNumber=[self numberForCellAtRow:y columns:x];
        
        if([aNumber integerValue]<=kGrayedOut && [aNumber integerValue] != kQuestionedOut)
        {
            continue;
        }
        
        if([self.activeNumbers containsObject:aNumber]==NO)
        {
            allSet=NO;
            break;
        }
    }
    
    if(allSet && [self.fullDiagonals containsObject:diagonalID]==NO)
    {
        [self.fullDiagonals addObject:diagonalID];
        [newDiagonals addObject:diagonalID];
    }
    
    allSet=YES;
    diagonalID=[NSNumber numberWithUnsignedInteger:1];
    
    for(NSInteger x=columns-1,y=0;x>=0;x--,y++)
    {
        NSNumber*aNumber=[self numberForCellAtRow:y columns:x];
        
        if([aNumber integerValue]<=kGrayedOut && [aNumber integerValue] != kQuestionedOut)
        {
            continue;
        }
        
        if([self.activeNumbers containsObject:aNumber]==NO)
        {
            allSet=NO;
            break;
        }
    }
    
    if(allSet && [self.fullDiagonals containsObject:diagonalID]==NO)
    {
        [self.fullDiagonals addObject:diagonalID];
        [newDiagonals addObject:diagonalID];
    }
    
    return newDiagonals;
}

/* Return all layers that are not a grey cell */
-(NSArray*)validLayersForLine:(NSUInteger)y
{
    NSMutableArray*someLayers=[NSMutableArray arrayWithCapacity:columns];
    
    for(NSUInteger x=0;x<columns;x++)
    {
        CALayer*aLayer=[self cellAtRow:y columns:x];
        
        if([aLayer.name isEqualToString:@"-1"])
        {
            continue;
        }
        
        [someLayers addObject:aLayer];
    }
    
    return someLayers;
}

-(NSArray*)validLayersForColumn:(NSUInteger)x
{
    NSMutableArray*someLayers=[NSMutableArray arrayWithCapacity:columns];
    
    for(NSUInteger y=0;y<rows;y++)
    {
        CALayer*aLayer=[self cellAtRow:y columns:x];
        
        if([aLayer.name isEqualToString:@"-1"])
        {
            continue;
        }
        
        [someLayers addObject:aLayer];
    }
    
    return someLayers;
}

-(NSArray*)validLayersForDiagonal:(NSUInteger)d
{
    NSMutableArray*someLayers=[NSMutableArray arrayWithCapacity:columns];
    NSUInteger shift=(d==0 ? 1 : -1);
    NSUInteger x=(d==0 ? 0 : columns-1);
    
    for(NSUInteger y=0;y<rows;y++,x+=shift)
    {
        CALayer*aLayer=[self cellAtRow:y columns:x];
        
        if([aLayer.name isEqualToString:@"-1"])
        {
            continue;
        }
        
        [someLayers addObject:aLayer];
    }
    
    return someLayers;
}

-(void)animateLayers:(NSArray*)someLayers
{
    /* Trigger animations for a full set of cell in a line */
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^(){
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.5];
        
        for(CALayer*aLayer in someLayers)
        {
            aLayer.transform=CATransform3DMakeScale(1.0, 1.0, 1.0);
            aLayer.backgroundColor=[UIColor colorWithRed:0.42 green:0.94 blue:0.24 alpha:0.75].CGColor;
        }
        
        [CATransaction commit];
        [CATransaction flush];
        
    }];
    
    [CATransaction setAnimationDuration:0.25];
    
    for(CALayer*aLayer in someLayers)
    {
        aLayer.transform=CATransform3DMakeScale(1.2, 1.2, 1.2);
    }
    
    [CATransaction commit];
}

-(void)checkCompleteLineWithNumberAtColumn:(NSInteger)aColumn row:(NSInteger)aRow
{
    if(self.variant==MV_90)
    {
        // Lines, Double lines and full card
        
        NSArray*completeLines=[self checkLinesAndReturnNewComplete];
        [[AppManager sharedInstance] tappingSound];

        for(NSNumber*aLine in completeLines)
        {
            complatedLinesMV_90++;
            NSUInteger y=[aLine unsignedIntegerValue];
            [self animateLayers:[self validLayersForLine:y]];
            if(complatedLinesMV_90 == 3)
                [[AppManager sharedInstance] fullLineSound]	;
            else
                [[AppManager sharedInstance] filledLineSound];
        }
    }
    else if(self.variant==MV_75)
    {
        // Lines, vertical lines, card diagonals
        int complateCount = 0;
        for(NSNumber*aLine in [self checkLinesAndReturnNewComplete])
        {
            NSUInteger y=[aLine unsignedIntegerValue];
            complateCount++;
            [self animateLayers:[self validLayersForLine:y]];
        }
        
        for(NSNumber*aColumn in [self checkColumsAndReturnNewComplete])
        {
            NSUInteger x=[aColumn unsignedIntegerValue];
            [self animateLayers:[self validLayersForColumn:x]];
            complateCount++;
        }
        
        for(NSNumber*aDiagonal in [self checkDiagonalsAndReturnNewComplete])
        {
            NSUInteger d=[aDiagonal unsignedIntegerValue];
            complateCount++;
            [self animateLayers:[self validLayersForDiagonal:d]];
        }
        if(complateCount>0)
            [[AppManager sharedInstance] fullLineSound];
        else
            [[AppManager sharedInstance] tappingSound];
    }
}

-(void)renderInPDF:(CGContextRef)aContext inFrame:(CGRect)aFrame
{
    
    CGRect smallFrame=CGRectInset(aFrame, 2.0, 2.0);
    CGRect tb=CGRectMake(0.0, 0.0, smallFrame.size.width/columns, smallFrame.size.height/rows);
    NSUInteger index=0;
    const CGFloat fillColor[4]={0.5,0.5,0.5,1.0};
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:24], NSParagraphStyleAttributeName: paragraphStyle};
    
    CGContextSetTextDrawingMode(aContext, kCGTextFill); // This is the default

    CGContextSetStrokeColorWithColor(aContext, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(aContext, 0.5f);

    if(columns == 9){
        if(![[AppManager sharedInstance] isPurchased]){
            NSUInteger questionIndex = arc4random() % 27;
            while(1)
            {
                if([[self.numbers objectAtIndex:questionIndex] intValue] != -1)
                {
                    NSMutableArray*tmp = [self.numbers mutableCopy];
                    tmp[questionIndex] = @"-3";
                    self.numbers = tmp;
                    break;
                }else{
                    questionIndex = arc4random() % 27;
                }
            }
        }

    }

    
    for(NSUInteger y=0;y<rows;y++)
    {
        for(NSUInteger x=0;x<columns;x++)
        {
            NSNumber*n=[self.numbers objectAtIndex:index];
            tb.origin=CGPointMake(smallFrame.origin.x+(x*tb.size.width), smallFrame.origin.y+(y*tb.size.height));
            
            /* Compute cell position on grid */
            
            if([n integerValue] == -1)
            {
                // Draw a gray cell here (possibly with a symbol)
                CGContextSetFillColor(aContext, fillColor);
                CGContextFillRect(aContext, tb);
            }
            else
            {
                // Draw the number here, centered in the cell
           
                NSString*numberToDraw=[n description];
                if([n integerValue] == -3){
                    numberToDraw = @"?";

                }
                CGSize size = [numberToDraw sizeWithAttributes:attributes];
                
                if (size.width < tb.size.width)
                {
                    CGRect r = CGRectMake(tb.origin.x,
                                          tb.origin.y + (tb.size.height - size.height)/2,
                                          tb.size.width,
                                          tb.size.height);
                    if([n integerValue] == -2){
                        UIImage*aStar=[UIImage imageNamed:@"Star.png"];
                        [aStar drawInRect:CGRectMake(tb.origin.x + tb.size.width*0.15,
                                                     -tb.size.height*0.1 + tb.origin.y + (tb.size.height - size.height)/2,
                                                     tb.size.width*0.7,
                                                     tb.size.height*0.7)];
                    }else{
                        [numberToDraw drawInRect:r withAttributes:attributes];

                    }

                }
            }
            
            /* Stroke the frame */
            
            CGContextStrokeRect(aContext, tb);
            
            index++;
        }
    }
    
    CGContextSetLineWidth(aContext, 0.75f);
    CGContextStrokeRect(aContext, aFrame);
}

@end
