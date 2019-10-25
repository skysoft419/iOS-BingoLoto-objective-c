//
//  BingoAsPDFDocument.m
//  BingoLoto
//
//  Created by Johann Huguenin on 19.02.19.
//  Copyright Â© 2019 Sensetrails Sarl. All rights reserved.
//

#include <UIKit/UIKit.h>
#import "BingoAsPDFDocument.h"
#import "NumberGridLayer.h"
#import "Common/AppManager.h"

static const CGSize  PAGE_A4={595,842};
static const CGSize  PAGE_US_LETTER={612,792};
//static const CGFloat margin=28.35; // 1 cm margin all around the page. Grids will be centered vertically
static CGFloat margin=40;
static const CGFloat centerMargin=14.17;
CGFloat logoYPos = 0;

@implementation BingoAsPDFDocument

-(BOOL)generateGrids
{
    if([[AppManager sharedInstance] isDocA4])
        self.size = A4;
    else
        self.size = US_LETTER;
    NSString*pdfFileName=[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"BingoLoto%@.%@", (self.variant==MV_75 ? @"75" : @"90"), @"pdf"]];
    
    if(UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil))
    {
        /* Create a page */
        
        CGRect pageRect=CGRectZero;
        
        if(self.size==US_LETTER)
        {
            pageRect.size=PAGE_US_LETTER;
        }
        else
        {
            pageRect.size=PAGE_A4;
        }
        
        UIGraphicsBeginPDFPageWithInfo(pageRect, nil);
        
        /* Print logo up */
        
        /* Add Grids: Depending on variant we can place 2x2 (75) or 1x2 (90 on US) or 1x3 (90 on A4) */
        
       
        if(self.variant==MV_75)
        {
            margin = 28;
            logoYPos = 20;
            CGFloat gridSize=(pageRect.size.width-(2.0f*margin)-centerMargin)*0.5f;
            
            NumberGridLayer*aGrid=[NumberGridLayer bingo75Play];
            CGRect gridPosition=CGRectMake(margin, (pageRect.size.height*0.5f)+(centerMargin*0.5f), gridSize, gridSize);
            
            [aGrid renderInPDF:UIGraphicsGetCurrentContext() inFrame:gridPosition];
            
            aGrid=[NumberGridLayer bingo75Play];
            gridPosition=CGRectMake(margin, (pageRect.size.height*0.5f)-(centerMargin*0.5f)-gridSize, gridSize, gridSize);
            
            [aGrid renderInPDF:UIGraphicsGetCurrentContext() inFrame:gridPosition];
            
            aGrid=[NumberGridLayer bingo75Play];
            gridPosition=CGRectMake(margin+gridSize+centerMargin, (pageRect.size.height*0.5f)+(centerMargin*0.5f), gridSize, gridSize);
            
            [aGrid renderInPDF:UIGraphicsGetCurrentContext() inFrame:gridPosition];
            
            aGrid=[NumberGridLayer bingo75Play];
            gridPosition=CGRectMake(margin+gridSize+centerMargin, (pageRect.size.height*0.5f)-(centerMargin*0.5f)-gridSize, gridSize, gridSize);
            
            [aGrid renderInPDF:UIGraphicsGetCurrentContext() inFrame:gridPosition];
            
        }
        else
        {
            margin = 100;
            logoYPos = 0;
            CGFloat numberOfRows=self.size==A4 ? 4.0 : 3.0;
            CGFloat gridSizeWidth=(pageRect.size.width-(2.0f*margin));
            CGFloat gridSizeHeight=(pageRect.size.height-(2.0f*margin));
            
            gridSizeHeight-=(numberOfRows-1.0)*centerMargin;
            gridSizeHeight/=numberOfRows;
            
            for(CGFloat x=0.0;x<numberOfRows;x+=1.0)
            {
                NumberGridLayer*aGrid=[NumberGridLayer bingo90Play];
                CGRect gridPosition=CGRectMake(margin, pageRect.size.height-margin-gridSizeHeight-(x*(gridSizeHeight+centerMargin)), gridSizeWidth, gridSizeHeight);
                
                [aGrid renderInPDF:UIGraphicsGetCurrentContext() inFrame:gridPosition];
            }
        }
        
        [self drawPageInfo:pageRect inContext:UIGraphicsGetCurrentContext()];
        
        /* Print link and other information at bottom of the page */
        
        //UIGraphicsSetPDFContextURLForRect(<#NSURL * _Nonnull url#>, <#CGRect rect#>)
        
        /* Save to file */
        
        UIGraphicsEndPDFContext();
        
        //NSLog(@"PDF document path is %@", pdfFileName);
        
        self.documentPath=pdfFileName;
        
        return YES;
    }
    
    self.documentPath=nil;
    
    return NO;
}

- (void) drawPageInfo:(CGRect) rect inContext:(CGContextRef)ctx {
    CGContextSetFillColorWithColor(ctx, [[UIColor darkTextColor] CGColor]);
    
    UIGraphicsPushContext(ctx);
    
    UIImage* headerImage = [UIImage imageNamed:@"Logo"];
    int imageWidth = 200;
    [headerImage  drawInRect:CGRectMake((rect.size.width - imageWidth)/2, logoYPos, imageWidth, imageWidth/headerImage.size.width * headerImage.size.height)];
    
    NSString *waterMark = @"Designed with Free version of BingoLoto";
    UIFont *font1 = [UIFont systemFontOfSize:20];
    
    if([[AppManager sharedInstance] isPurchased]){
        waterMark = @"Designed with BingoLoto";
        font1 = [UIFont systemFontOfSize:16];
    }
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    CGRect markRect = CGRectMake(0, rect.size.height - 50, rect.size.width, 30);
    NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      font1, NSFontAttributeName,
                                      style, NSParagraphStyleAttributeName,
                                      [UIColor colorWithRed:0 green:124.0f/255.0f blue:225.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                      [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    [waterMark drawInRect:markRect withAttributes:attrsDictionary1];
    
    UIGraphicsPopContext();
}

@end

