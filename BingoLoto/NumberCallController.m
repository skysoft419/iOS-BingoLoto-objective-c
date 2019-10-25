//
//  NumberCallController.m
//  BingoLoto
//
//  Created by Johann Huguenin on 26.01.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#import "NumberCallController.h"

@implementation NumberCallController

-(id)initWithRangeFrom:(NSUInteger)aStart to:(NSUInteger)anEnd
{
    self=[super init];
    
    if(self)
    {
        numbersToCall=[[NSMutableArray alloc]init];
        calledNumbers=[[NSMutableSet alloc]init];
        
        //callSpeed=2.0;
        
        assert(aStart<anEnd);
        
        [self setStart:aStart end:anEnd];
    }
    
    return self;
}

-(void)setStart:(NSUInteger)aStart end:(NSUInteger)anEnd
{
    start=aStart;
    end=anEnd;
    
    [self reset];
}

-(void)callNumber
{
    NSUInteger remNumbers=[numbersToCall count];
    NSUInteger anIndex=0;
    
    if(remNumbers>1)
    {
        anIndex=arc4random()%(remNumbers); //arc4random_uniform
    }
    else if([numbersToCall count]==0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GameDidEnd" object:nil];
        
        return;
    }
    
    NSNumber*calledNumber=[numbersToCall objectAtIndex:anIndex];
    
    [calledNumbers addObject:calledNumber];
    [numbersToCall removeObjectAtIndex:anIndex];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CalledNumber" object:calledNumber];
}

/** Reset number calling to a state where ready to start */
-(void)reset
{
    [numbersToCall removeAllObjects];
    [calledNumbers removeAllObjects];
    
    for(NSUInteger i=start;i<=end;i++)
    {
        [numbersToCall addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    srand((unsigned int)time(NULL));
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GameDidReset" object:self];
}

-(NSArray*)getNumbersToCall
{
    return numbersToCall;
}

@end
