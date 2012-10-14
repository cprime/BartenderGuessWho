//
//  GameRootViewController.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "GameRootViewController.h"
#import "GameModel.h"
#import "DrinkModel.h"
#import "MoveModel.h"
#import "GameMoveTableViewCell.h"
#import "AnswerViewController.h"

#define kGameCheckForGameTime 1000
#define kGameCheckForMoveTime 1000

@interface GameRootViewController ()
@property (strong, nonatomic) KCSCollection *gameCollection;
@property (strong, nonatomic) KCSAppdataStore *gameAppdataStore;
@property (strong, nonatomic) KCSCollection *moveCollection;
@property (strong, nonatomic) KCSAppdataStore *moveAppdataStore;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation GameRootViewController

- (void)setGameState:(GameState)gameState {
    _gameState = gameState;
    
    switch (_gameState) {
        case GameStateWaitingForPlayerToJoin: {
            self.statusLabel.text = @"Waiting for another player.";
            [self startStartOfGameTimer];
            break;
        }
        case GameStateWaitingForPlayerMove: {
            self.statusLabel.text = @"Ask your opponent a yes or no question.";
            break;
        }
        case GameStateWaitingForPlayerResponse: {
            self.statusLabel.text = @"Answer their question.";
            break;
        }
        case GameStateWaitingForOpponentMove: {
            self.statusLabel.text = @"Waiting for your opponent to make a move.";
            [self startPlayerMoveTimer];
            break;
        }
        case GameStateWaitingForOpponentResponse: {
            self.statusLabel.text = @"Waiting for your opponent to answer your question.";
            break;
        }
        case GameStateGameOver: {
            self.statusLabel.text = @"Game over.";
            break;
        }
    }
}

- (void)loadOtherPlayerWithId:(NSString *)playerId {
    [KCSUserDiscovery lookupUsersForFieldsAndValues:@{ KCSEntityKeyId: playerId } completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        self.otherUser = [objectsOrNil lastObject];
        if(self.otherUser) {
            self.otherPlayerLabel.text = [NSString stringWithFormat:@"%@ %@", [self.otherUser getValueForAttribute:@"first_name"], [self.otherUser getValueForAttribute:@"last_name"]];
        }
    } progressBlock:nil];
}

#pragma mark - timer methods

- (void)startStartOfGameTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kGameCheckForGameTime
                                                  target:self
                                                selector:@selector(checkForStartOfGame)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)checkForStartOfGame {
    [self.timer invalidate];
    self.timer = nil;
    
    KCSQuery *query = [KCSQuery queryForJoiningOperator:kKCSAnd
                                              onQueries:
                       [KCSQuery queryOnField:KCSEntityKeyId withExactMatchForValue:[[[KCSClient sharedClient] currentUser] kinveyObjectId]],
                       [KCSQuery queryOnField:@"player2" usingConditional:kKCSNotEqual forValue:@""],
                       nil];
    
    [self.gameCollection fetchWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to start game"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self startStartOfGameTimer];
        } else {
            if(objectsOrNil && [objectsOrNil count] > 0) {
                self.game = [objectsOrNil lastObject];
                [self setGameState:GameStateWaitingForPlayerMove];
                [self loadOtherPlayerWithId:self.game.player2];
            }
        }
    } withProgressBlock:nil];
}

- (void)startPlayerMoveTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kGameCheckForMoveTime
                                                  target:self
                                                selector:@selector(checkForPlayerMove)
                                                userInfo:nil
                                                 repeats:YES];
}
- (void)checkForPlayerMove {
    [self.timer invalidate];
    self.timer = nil;
    
    KCSQuery *query = [KCSQuery queryOnField:@"game" withExactMatchForValue:self.game.kinveyId];
    
    
    [self.moveCollection fetchWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to find recent moves"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self startPlayerMoveTimer];
        } else {
            if([self.moves count] < [objectsOrNil count]) {
                self.moves = [[objectsOrNil sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSComparisonResult result = [[[obj1 metadata] lastModifiedTime] compare:[[obj2 metadata] lastModifiedTime]];
                    if(result == NSOrderedAscending) result = NSOrderedDescending;
                    else if(result == NSOrderedDescending) result = NSOrderedAscending;
                    return result;
                }] mutableCopy];
                [self setGameState:GameStateWaitingForPlayerResponse];
                
                AnswerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnswerViewController"];
                vc.opponent = self.otherUser;
                if([self.moves count] > 0) {
                    vc.move = [self.moves objectAtIndex:0];
                }
                vc.delegate = self;
                vc.modalPresentationStyle = UIModalPresentationFormSheet;
                
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    } withProgressBlock:nil];
}

#pragma mark - actions

- (IBAction)askQuestionButtonClicked:(id)sender {
    if(self.gameState == GameStateWaitingForPlayerToJoin) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to ask question."
                                                        message:@"You must wait for another player to join"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    } else if(self.gameState == GameStateWaitingForOpponentMove) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to ask question."
                                                        message:@"You must wait for your opponent to ask a question"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    } else if(self.gameState == GameStateGameOver) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to ask question."
                                                        message:@"The Game is over"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        MoveModel *move = [[MoveModel alloc] init];
        move.game = self.game.kinveyId;
        move.player = [[[KCSClient sharedClient] currentUser] kinveyObjectId];
        move.question = self.questionTextField.text;
        
        [self.moveAppdataStore saveObject:move withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if(errorOrNil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to ask question."
                                                                message:@"Try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
            
            }
        } withProgressBlock:nil];
    }
}

- (IBAction)cancelGuessDrink:(UITapGestureRecognizer *)tapGr {
    if(tapGr.state == UIGestureRecognizerStateEnded)  {
        [UIView animateWithDuration:.5
                         animations:^{
                             self.fadeOutView.alpha = 0.0;
                             [self.drinkGridView exitSelectionMode];
                         } completion:^(BOOL finished) {
                             [self.fadeOutView removeFromSuperview];
                             self.fadeOutView.hidden = YES;
                         }];
    }
    [self.fadeOutView removeGestureRecognizer:tapGr];
}

- (void)guessOtherPlayersDrink:(UITapGestureRecognizer *)tapGr {
    if(tapGr.state == UIGestureRecognizerStateEnded) {
        if(!self.fadeOutView) {
            self.fadeOutView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.fadeOutView.backgroundColor = [UIColor blackColor];
            self.fadeOutView.alpha = 0;
            self.fadeOutView.hidden = YES;
        }
        
        [self.view addSubview:self.fadeOutView];
        [self.view bringSubviewToFront:self.drinkGridContainer];
        
        self.fadeOutView.hidden = NO;
        [UIView animateWithDuration:.5
                         animations:^{
                             self.fadeOutView.alpha = 0.65;
                         } completion:^(BOOL finished) {
                             [self.drinkGridView enterSelectionMode];
                             
                             UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelGuessDrink:)];
                             [self.fadeOutView addGestureRecognizer:gr];
                         }];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guessOtherPlayersDrink:)];
    [self.otherCocktailImageView addGestureRecognizer:gr];
    
    self.myCocktailImageView.image = [UIImage imageNamed:self.myDrink.imageName];
    
    self.moveCollection = [KCSCollection collectionFromString:@"move" ofClass:[MoveModel class]];
    self.moveAppdataStore = [KCSAppdataStore storeWithCollection:self.moveCollection options:nil];
    
    self.gameCollection = [KCSCollection collectionFromString:@"game" ofClass:[GameModel class]];
    self.gameAppdataStore = [KCSAppdataStore storeWithCollection:self.gameCollection options:nil];
    
    self.otherPlayerLabel.text = @"";
    if([self.game isPlayer1]) {
        self.gameState = GameStateWaitingForPlayerToJoin;
    } else {
        self.gameState = GameStateWaitingForOpponentMove;
        [self loadOtherPlayerWithId:self.game.player1];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.drinks = [[[DrinkModel allDrinks] allValues] mutableCopy];
    
    self.drinkGridView = [[DrinkGridView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         self.drinkGridContainer.bounds.size.width,
                                                                         self.drinkGridContainer.bounds.size.height)];
    self.drinkGridView.delegate = self;
    [self.drinkGridContainer addSubview:self.drinkGridView];
    self.drinkGridView.drinks = self.drinks;
    [self.drinkGridView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.moves count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GameMoveTableViewCell";
    GameMoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[GameMoveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //TODO: configure cell
    
    return cell;
}

#pragma mark - UITableViewDelegate methods


#pragma mark - DrinkGridViewDelegate methods

- (void)gridView:(DrinkGridView *)gridView didSelectDrink:(DrinkModel *)drink {
    
}
- (void)gridView:(DrinkGridView *)gridView didDeselectDrink:(DrinkModel *)drink {
    
}

#pragma mark - AnswerViewControllerDelegate methods

- (void)saveMove:(MoveModel *)move {
    [self.moveAppdataStore saveObject:move
                  withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                      if(errorOrNil) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to commit move"
                                                                          message:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"Okay"
                                                                otherButtonTitles:nil];
                          [alert show];
                      } else {
                          KCSQuery *query = [KCSQuery queryOnField:@"game" withExactMatchForValue:self.game.kinveyId];
                          
                          
                          [self.moveCollection fetchWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                              if([self.moves count] < [objectsOrNil count]) {
                                  self.moves = [[objectsOrNil sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                      NSComparisonResult result = [[[obj1 metadata] lastModifiedTime] compare:[[obj2 metadata] lastModifiedTime]];
                                      if(result == NSOrderedAscending) result = NSOrderedDescending;
                                      else if(result == NSOrderedDescending) result = NSOrderedAscending;
                                      return result;
                                  }] mutableCopy];
                                  [self setGameState:GameStateWaitingForPlayerResponse];
                                  
                                  [[self movesTableView] reloadData];
                              }
                              
                          } withProgressBlock:nil];
                      }
                  } withProgressBlock:nil];
}

- (void)didSelectYesForViewController: (AnswerViewController *)viewController {
    MoveModel *move = viewController.move;
    move.confirmed = [NSNumber numberWithBool:YES];
    [self saveMove:move];
}
- (void)didSelectNoForViewController: (AnswerViewController *)viewController {
    MoveModel *move = viewController.move;
    move.confirmed = [NSNumber numberWithBool:NO];
    [self saveMove:move];
}

@end
