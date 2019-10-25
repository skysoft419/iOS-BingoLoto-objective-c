//
//  BingoNumberLayer.m
//  BingoLoto
//
//  Created by Johann Huguenin on 02.04.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "BingoNumberLayer.h"
#import <CoreText/CoreText.h>
#define UIColorFromRGB(rgbHex) [UIColor colorWithRed:((float)((rgbHex & 0xFF0000) >> 16))/255.0 green:((float)((rgbHex & 0xFF00) >> 8))/255.0 blue:((float)(rgbHex & 0xFF))/255.0 alpha:1.0]

const NSInteger kGrayedOut=-1; // Cell filled with color
const NSInteger kStaredOut=-2; // Cell filled with a start (Bingo 75 only)
const NSInteger kQuestionedOut=-3; // Demo mode will have a question mark for 1 number in the card

@implementation BingoNumberLayer

+(BingoNumberLayer*)layerWithFrame:(CGRect)aFrame value:(NSInteger)aValue color:(UIColor*)aColor thickness:(CGFloat)borderWidth
{
    BingoNumberLayer*aLayer=[[BingoNumberLayer alloc]init];
    
  
    if(aFrame.size.height - aFrame.size.width < 5)
    {
        aLayer.frame=aFrame;
        aLayer.value=aValue;
        aLayer.color=aColor;
        aLayer.border=borderWidth;
        aFrame.size.height = aFrame.size.height * 0.85;
        aFrame.size.width = aFrame.size.width * 0.85;
//        if(aValue == -2){
//            aFrame.size.height = aFrame.size.height * 0.8;
//            aFrame.size.width = aFrame.size.width * 0.8;
//            aLayer.frame=aFrame;
//            aLayer.border=0;
//        }
        aLayer.name=[NSString stringWithFormat:@"%li", aValue];

//        CALayer *sublayer = [CALayer layer];
//        sublayer.opacity = 0.5;
//        sublayer.frame = CGRectMake(aLayer.frame.size.width * 0.075, aLayer.frame.size.width * 0.075, aFrame.size.width, aFrame.size.height);
////        aFrame = CGRectMake(aFrame.size.width * 0.07, aFrame.size.width * 0.07, aFrame.size.width-6, aFrame.size.height-6);
//        sublayer.contents = (id) [UIImage imageNamed:@"BingoLoto_Transparent_Cover.png"].CGImage;
//        //    sublayer.masksToBounds = YES;
//        sublayer.contentsGravity = kCAGravityResizeAspect;
//        sublayer.name=[NSString stringWithFormat:@"%li", aValue];
//        [aLayer addSublayer:sublayer];
    }else
    {
        aFrame.size.height = aFrame.size.height - 1;
        aFrame.size.width = aFrame.size.width - 1;
        
        aLayer.frame=aFrame;
        aLayer.value=aValue;
        aLayer.color=aColor;
        aLayer.border=borderWidth;
        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
            aLayer.border=2;
        aLayer.name=[NSString stringWithFormat:@"%li", aValue];
    }

    return aLayer;
}

-(void)renderText:(NSString*)aString inContext:(CGContextRef)ctx
{
    CGRect tb=self.bounds;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes;
    if(tb.size.height - tb.size.width > 5){
        attributes =@{NSFontAttributeName:[UIFont fontWithName:@"Akrobat-ExtraBold" size:tb.size.height*0.47],
                      NSParagraphStyleAttributeName: paragraphStyle,
                      NSForegroundColorAttributeName:[UIColor blackColor]};
    }else{
        attributes =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:tb.size.height*0.5],
                      NSParagraphStyleAttributeName: paragraphStyle,
                      NSForegroundColorAttributeName:self.color};
    }
    
    CGSize size = [aString sizeWithAttributes:attributes];
    
    UIGraphicsPushContext(ctx);
    
    CGContextSetTextDrawingMode(ctx, kCGTextFill); // This is the default
    
    if (size.width < tb.size.width)
    {
        CGRect r = CGRectMake(tb.origin.x,
                              tb.origin.y + (tb.size.height - size.height)/2,
                              tb.size.width,
                              tb.size.height);
        
        [aString drawInRect:r withAttributes:attributes];
    }
    
    UIGraphicsPopContext();
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    
    switch (self.value)
    {
        case kGrayedOut:
        {
//            self.backgroundColor = [UIColor redColor].CGColor;
//            self.borderColor = [UIColor whiteColor].CGColor;
//            self.border = 3;
//            self.cornerRadius = 10;
//            CGContextFillRect(ctx, self.bounds);
            break;
        }
        case kStaredOut:
        {
            UIImage*aStar=[UIImage imageNamed:@"Star.png"];
            
            CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height);
            CGContextSaveGState(ctx);
            CGContextConcatCTM(ctx, flipVertical);
            
            CGContextClipToMask(ctx, CGRectMake(self.bounds.origin.x + self.bounds.size.width * 0.1,
                                                self.bounds.origin.y + self.bounds.size.width * 0.1,
                                                self.bounds.size.width * 0.8,
                                                self.bounds.size.height * 0.8), aStar.CGImage);
            CGContextFillRect(ctx, CGRectMake(self.bounds.origin.x + self.bounds.size.width * 0.1,
                                              self.bounds.origin.y + self.bounds.size.width * 0.1,
                                              self.bounds.size.width * 0.8,
                                              self.bounds.size.height * 0.8));
            CGContextRestoreGState(ctx);
            
            break;
        }
        case kQuestionedOut:
        {
            [self renderText:@"?" inContext:ctx];
            break;
        }
        default:
        {
            [self renderText:[NSString stringWithFormat:@"%li", self.value] inContext:ctx];
            break;
        }
    }
    
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextSetLineWidth(ctx, self.border);
    CGContextStrokeRect(ctx, self.bounds);
}

@end
