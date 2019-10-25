//
//  RageIAPHelper.m
//  In App Purchase Test
//
//  Created by Ping on 5/30/19.
//  Copyright (c) 2019 Ping. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.sensetrails.bingoloto.upgrade",
                                      nil];
        
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
