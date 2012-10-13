//
//  GameRootViewController.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameModel;

@interface GameRootViewController : UIViewController

@property (strong, nonatomic) GameModel *game;

@end
