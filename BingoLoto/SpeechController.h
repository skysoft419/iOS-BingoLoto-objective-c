//
//  SpeechController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 26.01.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpeechController : NSObject
{
    AVSpeechSynthesizer *syn;
}

@end

NS_ASSUME_NONNULL_END
