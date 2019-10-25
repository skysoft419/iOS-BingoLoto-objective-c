//
//  AppManager.m
//  BingoLoto
//
//  Created by Ping on 5/30/19.
//  Copyright (c) 2019 Ping. All rights reserved.
//

#import "AppManager.h"
#import "Constants.h"
#import <objc/runtime.h>

static const char kBundleKey = 0;


@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end


@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation AppManager
AVAudioPlayer *theAudio;
NSURL *soundFileURL;
+ (AppManager*) sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
   
    NSString * language = [[[[NSLocale preferredLanguages] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:0];
    //en,fr-US,    de-US
    //    language.
    NSInteger languageId = [[NSUserDefaults standardUserDefaults] integerForKey:LANGUAGEOPT];
    if(languageId == 0){
        if(![language isEqual:@"en"] && ![language isEqual: @"fr"] && ![language isEqual: @"de"]){
            language = @"en";
        }
    }
    else if(languageId == 1)
        language = @"en";
    else if(languageId == 2)
        language = @"de";
    else if(languageId == 3)
        language = @"fr";
    [NSBundle setLanguage:language];
    
    return _sharedObject;
}

- (AppManager*) init {

    if(![[NSUserDefaults standardUserDefaults] boolForKey:DEFUALTSETTING])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUNDON];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SPEECHON];
        [[NSUserDefaults standardUserDefaults] setFloat:0.5 forKey:SPEECHSPEED];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DOCA4];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:LANGUAGEOPT];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEFUALTSETTING];
    }
    return self;
}

- (void) soundPlay:(NSString *)fileName{
    if ([theAudio isPlaying]) {
        [theAudio stop];
    }
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    NSURL *soundURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL: soundURL error:nil];
    [theAudio prepareToPlay];
    [theAudio setNumberOfLoops:0];
    if (theAudio == nil){
        NSLog(@"%@", @"run");
    }
    else {
        [theAudio play];
    }
}
- (void) buttonBackSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"buttonback"];
}
- (void) fullLineSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"bingosound"];
}
- (void) filledLineSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"filledline"];
}
- (void) openMenuSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"openingamenu"];
}
- (void) pauseGameSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"pausinggamesound"];
}
- (void) playSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"playsound"];
}
- (void) printerSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"printersound"];
}
- (void) tappingSound{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        [self soundPlay:@"tappinganumber"];
}

- (BOOL) isSoundOn{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SOUNDON])
        return YES;
    else
        return NO;
}

- (BOOL) isSpeechOn{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SPEECHON])
        return YES;
    else
        return NO;
}
- (float) speechSpeed{
    return [[NSUserDefaults standardUserDefaults] floatForKey:SPEECHSPEED];
}
- (BOOL) isDocA4{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DOCA4])
        return YES;
    else
        return NO;
}
- (NSInteger) languageSelect{
    return [[NSUserDefaults standardUserDefaults] integerForKey:LANGUAGEOPT];
}

- (BOOL) isPurchased{
//    return true;
    return [[NSUserDefaults standardUserDefaults] boolForKey:PURCHASED];
}

- (void) setPurchased:(BOOL) purchased{
    [[NSUserDefaults standardUserDefaults] setBool:purchased forKey:PURCHASED];
}

- (void) showAlert:(NSString*) title message:(NSString*)message controller:(UIViewController*)controller{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    [alert addAction:okButton];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
