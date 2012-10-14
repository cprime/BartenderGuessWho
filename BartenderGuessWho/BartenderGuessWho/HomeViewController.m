//
//  HomeViewController.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "HomeViewController.h"
#import "DrinkSelectionViewController.h"
#import "GameRootViewController.h"

#import "GameModel.h"
#import "DrinkModel.h"

#define kHomeViewControllerCheckForGameTime 10

#define kHomeViewControllerFoundGameAlert 1

@interface HomeViewController ()
@property (strong, nonatomic) KCSCollection *gameCollection;
@property (strong, nonatomic) KCSAppdataStore *appDataStore;
@property (strong, nonatomic) GameModel *gameModel;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HomeViewController

- (void)startTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kHomeViewControllerCheckForGameTime
                                         target:self
                                       selector:@selector(checkForAvailibleGame)
                                       userInfo:nil
                                        repeats:YES];
}

- (void)checkForAvailibleGame {
    [self.timer invalidate];
    self.timer = nil;
    
    KCSQuery *query = [KCSQuery queryOnField:@"player2" withExactMatchForValue:@""];
    
    [self.gameCollection fetchWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to find games"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self startTimer];
        } else {
            if(objectsOrNil && [objectsOrNil count] > 0) {
                self.gameModel = [objectsOrNil lastObject];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Found!"
                                                                message:@"Would you like to play a game?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
                alert.tag = kHomeViewControllerFoundGameAlert;
                [alert show];
            }
        }
    } withProgressBlock:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [KCSPing pingKinveyWithBlock:^(KCSPingResult *result) {
//        // This block gets executed when the ping completes
//        NSString *title;
//        
//        if (result.pingWasSuccessful){
//            title = @"Kinvey Ping Success :)";
//        } else {
//            title = @"Kinvey Ping Failed :(";
//        }
//        
//        // Log the result
//        NSLog(@"%@", result.description);
//        
//        // Display an alert stating the result
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
//                                                        message: [result description]
//                                                       delegate: nil
//                                              cancelButtonTitle: @"OK"
//                                              otherButtonTitles: nil];
//        [alert show];
//    }];
    
    self.gameCollection = [KCSCollection collectionFromString:@"game" ofClass:[GameModel class]];
    self.appDataStore = [KCSAppdataStore storeWithCollection:self.gameCollection options:nil];
    
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    
    if([segue.identifier isEqual:@"DrinkSelectionViewController"]) {
        DrinkSelectionViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

#pragma mark - DrinkSelectionViewControllerDelegate methods

- (void)viewController:(DrinkSelectionViewController *)viewController didSelectDrink:(DrinkModel *)drink {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(self.gameModel) {
        self.gameModel.player2 = [[[KCSClient sharedClient] currentUser] kinveyObjectId];
        self.gameModel.cocktail2 = drink.name;
    } else {
        GameModel *game = [[GameModel alloc] init];
        game.player1 = [[[KCSClient sharedClient] currentUser] kinveyObjectId];
        game.cocktail1 = drink.name;
        game.player2 = @"";
        
        self.gameModel = game;
    }
    
#if ENABLE_KINVEY
    [self.appDataStore saveObject:self.gameModel
              withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to create game"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self startTimer];
        } else {
            GameRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameRootViewController"];
            vc.myDrink = drink;
            vc.game = [objectsOrNil lastObject];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } withProgressBlock:nil];
#else
    GameRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameRootViewController"];
    vc.myDrink = drink;
    vc.game = self.gameModel;
    
    self.gameModel.player1 = @"507994e82146606f4f000846";
    self.gameModel.cocktail1 = drink.name;
    self.gameModel.player2 = @"5079d5872146606f4f00091e";
    self.gameModel.cocktail2 = drink.name;
    
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == kHomeViewControllerFoundGameAlert) {
        if(buttonIndex == 1) {
            DrinkSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DrinkSelectionViewController"];
            vc.modalPresentationStyle = UIModalPresentationPageSheet;
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            self.gameModel = nil;
            [self startTimer];
        }
    } 
}

@end
