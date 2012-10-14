//
//  GameModel.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject<KCSPersistable>

@property (strong, nonatomic) NSString *kinveyId;
@property (strong, nonatomic) NSString *player1;
@property (strong, nonatomic) NSString *player2;
@property (strong, nonatomic) NSString *cocktail1;
@property (strong, nonatomic) NSString *cocktail2;
@property (strong, nonatomic) NSString *winner;

@property (readonly, nonatomic) BOOL isPlayer1;
@property (readonly, nonatomic) BOOL isGameCompleted;

@end
