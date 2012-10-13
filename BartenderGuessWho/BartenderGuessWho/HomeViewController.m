//
//  HomeViewController.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "HomeViewController.h"

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

@end
