//
//  ViewController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 26.01.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "NumberCallViewController.h"
#import "NumberCallController.h"
#import "SpeechController.h"
#import "GameUserInteractionLayer.h"
#import "Common/AppManager.h"
#import "IAP/RageIAPHelper.h"

@interface NumberCallViewController ()
{
    CALayer*gridLayer;
    SpeechController*speech;
    NSTimer*callTimer;
    NSTimeInterval callSpeed;
    NSUInteger start;
    NSUInteger end;
    NSUInteger columns;
    NSUInteger rows;
    CGRect tb;
}

@property (retain) NumberCallController*controller;
@property (retain) GameUserInteractionLayer*menu;
@property (retain) GADInterstitial*interstitial;
@property (retain) CAShapeLayer *shadow;
@end

@implementation NumberCallViewController

-(IBAction)pause:(id)sender //Tap anywhere on screen to pause
{
    [callTimer invalidate];
    callTimer=nil;
    
    /* Display the continue/restart/exit menu */
    self.menu=[GameUserInteractionLayer createWithFrame:CGRectInset(gridLayer.bounds, 0,0) actionsTarget:self];

    [self.menu addButton:@"Continue" selector:@"start:"];
    [self.menu addButton:@"Start" selector:@"restart:"];
    [self.menu addButton:@"Exit" selector:@"exit:"];
// Black background
    self.shadow = [CAShapeLayer layer];
    self.shadow.path = [UIBezierPath bezierPathWithRoundedRect:[[UIScreen mainScreen] bounds] cornerRadius:0].CGPath;
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
        self.shadow.position = CGPointMake(-30, -30);
    else
        self.shadow.position = CGPointMake(-40, -40);
    self.shadow.fillColor = [UIColor blackColor].CGColor;
    self.shadow.lineWidth = 0;
    self.shadow.opacity = 0.6;
    [gridLayer addSublayer:self.shadow];
    [gridLayer addSublayer:self.menu];
    if(![[AppManager sharedInstance] isPurchased]){
        if(self.interstitial.isReady)
        {
            [self.interstitial presentFromRootViewController:self];
        }
        else
        {

            NSLog(@"Ad wasn't ready");
        }
    }

    [[AppManager sharedInstance] pauseGameSound];
}

-(IBAction)start:(id)sender //Start or continue game
{
    /* Dismiss the menu */
    self.shadow.opacity = 0.0;

    [self.menu removeFromSuperlayer];
    self.menu=nil;
    
    /* Start the number calling */
    callTimer=[NSTimer scheduledTimerWithTimeInterval:callSpeed repeats:YES block:^(NSTimer *timer)
               {
                   [self.controller callNumber];
               }];
    [[AppManager sharedInstance] playSound];

}

-(IBAction)restart:(id)sender //Reset and restart game
{
    self.shadow.opacity = 0.0;

    [callTimer invalidate];
    callTimer=nil;
    
    [self.controller reset]; // -> The grid is reset to initial game state
    
    /* Display the start/exit menu */
    self.menu=[GameUserInteractionLayer createWithFrame:CGRectInset(gridLayer.bounds, 0,0) actionsTarget:self];
    [self.menu addButton:@"Continue" selector:@"start:"];
    [self.menu addButton:@"Exit" selector:@"exit:"];
    
    [gridLayer addSublayer:self.menu];
    [[AppManager sharedInstance] playSound];
// Black background
    self.shadow = [CAShapeLayer layer];
    self.shadow.path = [UIBezierPath bezierPathWithRoundedRect:[[UIScreen mainScreen] bounds] cornerRadius:0].CGPath;
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
        self.shadow.position = CGPointMake(-30, -30);
    else
        self.shadow.position = CGPointMake(-40, -40);
    self.shadow.fillColor = [UIColor blackColor].CGColor;
    self.shadow.lineWidth = 0;
    self.shadow.opacity = 0.6;
    [gridLayer addSublayer:self.shadow];
    [gridLayer addSublayer:self.menu];

}

-(IBAction)exit:(id)sender //Back to menu
{
    self.shadow.opacity = 0.0;

    [callTimer invalidate];
    callTimer=nil;
    
    /* Dismiss the menu */
    
    [self.menu removeFromSuperlayer];
    self.menu=nil;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    [[AppManager sharedInstance] pauseGameSound];

}

-(void)setStart:(NSUInteger)aStart end:(NSUInteger)anEnd columns:(NSUInteger)someColumns rows:(NSUInteger)someRows
{
    self.shadow.opacity = 0.0;
    start=aStart;
    end=anEnd;
    columns=someColumns;
    rows=someRows;
    
    [self.controller setStart:start end:end];
}

-(void)loadView
{
    self.view=[[GameInteractiveView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    GameInteractiveView*theView=((GameInteractiveView*)self.view);
//    CALayer*mainLayer=theView.displayView.layer;
    
    [super viewDidLoad];
    
    [theView setupView:self withExitButton:NO];
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetGrid:) name:@"GameDidReset" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callNumber:) name:@"CalledNumber" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart:) name:@"GameDidEnd" object:nil];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleUserActions:) name:@"TouchedLayer" object:nil];

    self.controller=[[NumberCallController alloc]initWithRangeFrom:start to:end];
    
    if([[AppManager sharedInstance] isSpeechOn])
    {
        speech=[[SpeechController alloc]init];
    }
    float speed = [[AppManager sharedInstance] speechSpeed];
    callSpeed=2.5 + (0.62 - speed)*12.5;
    [self restart:nil];
    
    self.interstitial=[[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-3021513607149156/4197187504"];
    [self.interstitial loadRequest:[[GADRequest alloc]init]];
    self.interstitial.delegate=self;
}

- (void)interstitialDidDismissScreen:(nonnull GADInterstitial *)ad
{
    self.interstitial=[[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-3021513607149156/4197187504"];
    [self.interstitial loadRequest:[[GADRequest alloc]init]];
    self.interstitial.delegate=self;
}

-(void)resetGrid:(NSNotification*)aNotification
{
    //CGRect viewB=self.view.bounds;
    self.controller=aNotification.object;
    
    if(self.controller)
    {
        GameInteractiveView*theView=((GameInteractiveView*)self.view);
        CALayer*mainLayer=theView.displayView.layer;
        
        NSArray*theNumbers=[self.controller getNumbersToCall];
        NSUInteger count=[theNumbers count];
        NSUInteger index=0;
        
        //CALayer*mainLayer=self.view.layer;

        CGRect mb=theView.displayArea;//mainLayer.bounds;
        
        CGRect gb=mb;//CGRectInset(mb, 16.0f, 16.0f);
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
            gb = CGRectInset(screenRect, 30,30);
        else
            gb = CGRectInset(screenRect, 40, 40);
        mainLayer.backgroundColor=[UIColor darkGrayColor].CGColor;
        tb=CGRectMake(0.0, 0.0, gb.size.width/columns, gb.size.height/rows);
        [gridLayer removeFromSuperlayer];
        gridLayer=[CALayer layer];
        gridLayer.frame=gb;
        gridLayer.backgroundColor=[UIColor whiteColor].CGColor;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        for(NSUInteger y=0;y<rows;y++)
        {
            for(NSUInteger x=0;x<columns;x++)
            {
                if(index<count)
                {
                    NSNumber*n=[theNumbers objectAtIndex:index];
                    CGPoint p=CGPointMake(x*tb.size.width+(0.5*tb.size.width), y*tb.size.height+(0.5*tb.size.height));
                    
                    /* Compute layer position on grid */
                    
                    CALayer*aLayer=[CATextLayer layer];
                    CATextLayer*bodyLayer=[CATextLayer layer];
                    bodyLayer.string=[n description];
                    [bodyLayer setFont:(__bridge CFTypeRef _Nullable)([UIFont fontWithName:@"Helvetica" size:tb.size.width*0.45])];
                    
                    float fontSize = 0;
                    if(tb.size.height > tb.size.width)
                        fontSize = tb.size.width*0.5;
                    else
                        fontSize = tb.size.height*0.5;

                    bodyLayer.fontSize = fontSize;
                    bodyLayer.alignmentMode=kCAAlignmentCenter;
                    bodyLayer.foregroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
                    bodyLayer.frame = CGRectMake(tb.origin.y,
                                                 tb.origin.x + (tb.size.height-fontSize*1.2)/2,
                                                 tb.size.width,
                                                 fontSize * 1.2);
                    [aLayer addSublayer:bodyLayer];
                    aLayer.borderColor=[UIColor lightGrayColor].CGColor;
                    aLayer.borderWidth=0.5;
                    CGRect r = CGRectMake(tb.origin.y,
                                          tb.origin.x ,
                                          tb.size.width,
                                          tb.size.height);
                    aLayer.bounds=r;
                    aLayer.position=p;
                    [gridLayer addSublayer:aLayer];
                }
                index++;
            }
        }
        [mainLayer addSublayer:gridLayer];//
        [CATransaction commit];
    }
}


-(void)callNumber:(NSNotification*)aNotification
{
    NSNumber*n=aNotification.object;
    NSArray*children=[gridLayer sublayers];
    
    CGPoint p1=gridLayer.position;
    CGPoint p=gridLayer.position;
    NSString*identifier=[n description];
    
    /* Find final position and animate */
    Boolean isGetPosition = false;
    for(CATextLayer*aLayer in children)
    {
        NSArray*children2=[aLayer sublayers];
        for(CATextLayer*aLayer2 in children2)
        {
            if([aLayer2.string isEqualToString:identifier])
            {
                p1=aLayer.position;
                isGetPosition = true;
                break;
            }

        }
        if(isGetPosition)
            break;

    }
    dispatch_async(dispatch_get_main_queue(),^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        CATextLayer*aLayer=[CATextLayer layer];
        CGRect r = CGRectMake(self->tb.origin.y,
                              self->tb.origin.x ,
                              self->tb.size.width,
                              self->tb.size.height);
        CALayer *sublayer = [CALayer layer];
        sublayer.opacity = 1;
        sublayer.frame = CGRectMake(0, 0, r.size.width, r.size.height);
        sublayer.contents = (id) [UIImage imageNamed:@"BingoLoto_Ball_white.png"].CGImage;
        sublayer.contentsGravity = kCAGravityResizeAspect;
        [aLayer addSublayer:sublayer];
        aLayer.contentsScale = [[UIScreen mainScreen] scale];
        aLayer.contentsGravity = kCAGravityResizeAspect;
        float fontSize = 0;
        if(self->tb.size.height > self->tb.size.width)
        {
            fontSize = self->tb.size.width*0.5;
            
        }
        else
            fontSize = self->tb.size.height*0.5;
        
        CATextLayer*bodyLayer=[CATextLayer layer];
        bodyLayer.string=[n description];
        [bodyLayer setFont:(__bridge CFTypeRef _Nullable)([UIFont fontWithName:@"Helvetica" size:self->tb.size.width*0.45])];
        bodyLayer.fontSize = fontSize;
        bodyLayer.alignmentMode=kCAAlignmentCenter;
        bodyLayer.foregroundColor=[UIColor blackColor].CGColor;
        bodyLayer.frame = CGRectMake(self->tb.origin.y,
                                     self->tb.origin.x + (self->tb.size.height-fontSize*1.2)/2,
                                     self->tb.size.width,
                                     fontSize * 1.2);
        bodyLayer.contentsScale = [[UIScreen mainScreen] scale];

        [aLayer addSublayer:bodyLayer];
        
        //    aLayer.string=identifier;
        aLayer.alignmentMode=kCAAlignmentCenter;
        aLayer.foregroundColor=[UIColor blackColor].CGColor;
        aLayer.bounds=r;
        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
            aLayer.position = CGPointMake(p.x-30, p.y-30);
        else
            aLayer.position = CGPointMake(p.x-40, p.y-40);
		
        aLayer.transform=CATransform3DMakeScale(2.0, 2.0, 2.0);
        aLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self->gridLayer addSublayer:aLayer];
        
        [CATransaction commit];
        float speed = [[AppManager sharedInstance] speechSpeed];
        float pause_time = 1.75 + (0.62 - speed)*12.5;
        [NSThread sleepForTimeInterval:pause_time];
//        sleep(1.5/(speed + 1));
        /* Animate to final pos */
//        float duration_time = 1.5 / (speed + 1);
//        float tmp = duration_time*duration_time*duration_time;
        [CATransaction setAnimationDuration:0.5];
        [CATransaction begin];
        aLayer.position=p1;
        aLayer.transform=CATransform3DMakeScale(1.0, 1.0, 1.0);
        
        [CATransaction commit];
    });
  

}

-(void)upgradeToPremium:(id)sender
{
    if ([[RageIAPHelper sharedInstance] canMakePayments]) {
        SKProduct *product = [[RageIAPHelper sharedInstance].skProducts objectAtIndex:0];
        [[RageIAPHelper sharedInstance] buyProduct:product];
    } else {
        [[AppManager sharedInstance] showAlert:@"Purchases are disabled in your device" message:nil controller:self];
    }
}

-(void)handleUserActions:(NSNotification*)aNotification
{
    CALayer*aLayer=[aNotification object];
    
    if(aLayer)
    {
        if(self.menu)
        {
            [self.menu performActionForLayer:aLayer];
        }
        else
        {
            [self pause:aLayer];
        }
    }
}

@end
