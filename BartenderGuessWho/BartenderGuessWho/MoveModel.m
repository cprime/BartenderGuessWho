//
//  MoveModel.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "MoveModel.h"

@implementation MoveModel

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
    @"kinveyId" : KCSEntityKeyId,
    @"game" : @"game",
    @"player" : @"player",
    @"question" : @"question",
    @"quessedCocktail" : @"quessedCocktail",
    @"confirmed": @"confirmed",
    };
}

@end
