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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [KCSPing pingKinveyWithBlock:^(KCSPingResult *result) {
        // This block gets executed when the ping completes
        NSString *title;
        
        if (result.pingWasSuccessful){
            title = @"Kinvey Ping Success :)";
        } else {
            title = @"Kinvey Ping Failed :(";
        }
        
        // Log the result
        NSLog(@"%@", result.description);
        
        // Display an alert stating the result
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                        message: [result description]
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playGameButtonClicked:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"DrinkSelectionViewController"]) {
        DrinkSelectionViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

#pragma mark - DrinkSelectionViewControllerDelegate methods

- (void)viewController:(DrinkSelectionViewController *)viewController didSelectDrink:(DrinkModel *)drink {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    GameRootViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameRootViewController"];
    //TODO: setup game
    [self.navigationController pushViewController:vc animated:YES];
}

@end
