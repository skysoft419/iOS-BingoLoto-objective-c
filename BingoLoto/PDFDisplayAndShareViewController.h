//
//  PDFDisplayAndShareViewController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 20.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFDisplayAndShareViewController : UIViewController <UIPopoverPresentationControllerDelegate>
{
    
}

@property (retain) NSString*documentPath;

+(UINavigationController*)createPDFViewer:(NSString*)aPath;

@end

NS_ASSUME_NONNULL_END
