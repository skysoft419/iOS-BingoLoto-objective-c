//
//  PDFDisplayAndShareViewController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 20.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "PDFDisplayAndShareViewController.h"
#import <PDFKit/PDFKit.h>

@interface PDFDisplayAndShareViewController ()

@end

@implementation PDFDisplayAndShareViewController

+(UINavigationController*)createPDFViewer:(NSString*)aPath
{
    PDFDisplayAndShareViewController*pdf=[[PDFDisplayAndShareViewController alloc]init];
    
    pdf.documentPath=aPath;
    
    return [[UINavigationController alloc]initWithRootViewController:pdf];
}

// Use this function to create a UIActivityViewController. It manages for you the UINoEventWindow issue happening on some devices (unable to interact with content because this layer is receiving the taps).
+ (UIActivityViewController*)createActivityControllerWithActivityItems:(NSArray *)activityItems
                                                 applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities
                                                               subject:(NSString *)subject
                                                     completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:applicationActivities];
    
    if (subject)
    {
        [activityViewController setValue:subject forKey:@"subject"];
    }
    
    activityViewController.completionWithItemsHandler = handler;
    
    return activityViewController;
}

- (void)presentActivityController:(UIActivityViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *presenter = self;
    
    controller.popoverPresentationController.sourceView = presenter.view;
    controller.popoverPresentationController.sourceRect = presenter.view.bounds;
    controller.popoverPresentationController.permittedArrowDirections = 0;
    controller.popoverPresentationController.delegate = self;
    
    [presenter presentViewController:controller animated:animated completion:completion];
}

-(IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

-(IBAction)share:(id)sender
{
    NSArray*sharingItems=[NSArray arrayWithObject:[NSURL fileURLWithPath:self.documentPath]];
    UIActivityViewController *activities = [PDFDisplayAndShareViewController createActivityControllerWithActivityItems:sharingItems
                                                                                   applicationActivities:nil
                                                                                                subject:NSLocalizedString(@"Share grids", @"")
                                                                                       completionHandler:nil];
    
    [self presentActivityController:activities animated:YES completion:nil];
}

- (void)viewDidLoad
{
    PDFView*theView=(PDFView*)self.view;
    PDFDocument*aDocument=[[PDFDocument alloc]initWithURL:[NSURL fileURLWithPath:self.documentPath]];
    
    self.title=NSLocalizedString(@"Generated Grids", "");
    
    [super viewDidLoad];
   
    [theView setBackgroundColor:[UIColor grayColor]];
    [theView setDocument:aDocument];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
}

-(void)loadView
{
    self.view=[[PDFView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

@end
