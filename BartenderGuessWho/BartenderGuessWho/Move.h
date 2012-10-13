//
//  Move.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Move : NSObject<KCSPersistable>

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *game;
@property (strong, nonatomic) NSString *player;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *quessedCocktail;

@end
