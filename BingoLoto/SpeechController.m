//
//  SpeechController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 26.01.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "SpeechController.h"
#import "Common/AppManager.h"

@implementation SpeechController

-(id)init
{
    self=[super init];
    
    if(self)
    {
        syn = [[AVSpeechSynthesizer alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakNumber:) name:@"CalledNumber" object:nil];
    }
    
    return self;
}

-(void)speakNumber:(NSNotification*)aNotification
{
    NSNumber*aNumber=[aNotification object];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[aNumber description]];

    // speech speed control
    float speechSpeed = [[AppManager sharedInstance] speechSpeed];
    utterance.rate=speechSpeed;
    NSString * language = [[[[NSLocale preferredLanguages] firstObject] componentsSeparatedByString:@"-"] objectAtIndex:0];
    NSInteger languageId = [[NSUserDefaults standardUserDefaults] integerForKey:@"languageOpt"];
    if(languageId == 0){
        if(![language isEqual:@"en"] && ![language isEqual: @"fr"] && ![language isEqual: @"de"]){
            language = @"en";
        }
    }else if(languageId == 1)
        language = @"en";
    else if(languageId == 2)
        language = @"de";
    else if(languageId == 3)
        language = @"fr";
    // speech language
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
    
    [syn speakUtterance:utterance];
}

@end
