//
//  MoveModel.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveModel : NSObject<KCSPersistable>

@property (strong, nonatomic) NSString *kinveyId;
@property (strong, nonatomic) NSString *game;
@property (strong, nonatomic) NSString *player;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *quessedCocktail;
@property (strong, nonatomic) NSNumber *confirmed;

@end
