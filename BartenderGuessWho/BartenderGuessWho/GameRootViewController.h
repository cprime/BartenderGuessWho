//
//  GameRootViewController.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinkGridView.h"

@class GameModel;

@interface GameRootViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DrinkGridViewDelegate>

@property (strong, nonatomic) GameModel *game;
@property (strong, nonatomic) NSMutableArray *drinks;
@property (strong, nonatomic) NSArray *moves;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIView *drinkGridContainer;
@property (strong, nonatomic) IBOutlet DrinkGridView *drinkGridView;

@property (strong, nonatomic) IBOutlet UIImageView *myCocktailImageView;
@property (strong, nonatomic) IBOutlet UIImageView *otherCocktailImageView;
@property (strong, nonatomic) IBOutlet UILabel *otherPlayerLabel;

@property (strong, nonatomic) IBOutlet UITextField *questionTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *askQuestionButton;

@property (strong, nonatomic) IBOutlet UITableView *movesTableView;

- (IBAction)askQuestionButtonClicked:(id)sender;

@end
