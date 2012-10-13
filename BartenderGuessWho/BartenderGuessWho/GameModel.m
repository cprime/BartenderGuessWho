//
//  GameModel.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

- (NSDictionary *)hostToKinveyPropertyMapping
{
    // Only define the dictionary once
    static NSDictionary *mapping = nil;
    
    // If it's not initialized, initialize here
    if (mapping == nil){
        // Assign the mapping
        mapping = @{
        @"objectId" : KCSEntityKeyId,
        @"player1" : @"player1",
        @"player2" : @"player2",
        @"cocktail1" : @"cocktail1",
        @"cocktail2" : @"cocktail2",
        @"winner" : @"winner",
        };
    }
    
    return mapping;
}

- (BOOL)isPlayer1 {
    if([[[[KCSClient sharedClient] currentUser] kinveyObjectId] isEqual:self.player1]) {
        return YES;
    }
    return NO;
}
- (BOOL)isGameCompleted {
    return self.winner == nil;
}

@end
