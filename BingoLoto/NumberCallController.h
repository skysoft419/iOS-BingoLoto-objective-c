//
//  NumberCallController.h
//  BingoLoto
//
//  Created by Johann Huguenin on 26.01.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NumberCallController : NSObject
{
    NSUInteger start;
    NSUInteger end;
    
    //NSTimeInterval callSpeed;
    
    NSMutableArray*numbersToCall;
    NSMutableSet*calledNumbers;
}

-(id)initWithRangeFrom:(NSUInteger)aStart to:(NSUInteger)anEnd;

-(void)setStart:(NSUInteger)aStart end:(NSUInteger)anEnd;

///** Start or restart number calling */
//-(void)start;
//
///** Pause number calling */
//-(void)pause;

/** Reset number calling to a state where ready to start */
-(void)reset;

-(void)callNumber;
-(NSArray*)getNumbersToCall;

@end

NS_ASSUME_NONNULL_END
