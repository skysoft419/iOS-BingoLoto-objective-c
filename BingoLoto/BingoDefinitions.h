//
//  BingoDefinitions.h
//  BingoLoto
//
//  Created by Johann Huguenin on 12.02.19.
//  Copyright © 2019 Sensetrails Sarl. All rights reserved.
//

#ifndef BingoDefinitions_h
#define BingoDefinitions_h

typedef enum MENU_ACTIONS
{
    MA_NO_ACTION=0,
    MA_PLAY=1,
    MA_CALL,
    MA_GENERATE_CARDS
} MENU_ACTIONS;

typedef enum  MENU_VARIANTS
{
    MV_NO_VARIANT=0,
    MV_75=16,
    MV_90=17
} MENU_VARIANTS;

typedef enum  PAGE_SIZES
{
    A4=0,
    US_LETTER
} PAGE_SIZES;

#endif /* BingoDefinitions_h */
