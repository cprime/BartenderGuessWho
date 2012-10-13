//
//  Move.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "Move.h"

@implementation Move

- (NSDictionary *)hostToKinveyPropertyMapping
{
    // Only define the dictionary once
    static NSDictionary *mapping = nil;
    
    // If it's not initialized, initialize here
    if (mapping == nil){
        // Assign the mapping
        mapping = @{
        @"objectId" : KCSEntityKeyId,
        @"game" : @"game",
        @"player" : @"player",
        @"question" : @"question",
        @"quessedCocktail" : @"quessedCocktail",
        };
    }
    
    return mapping;
}

@end
