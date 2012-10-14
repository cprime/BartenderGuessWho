//
//  AnswerViewController.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "AnswerViewController.h"
#import "MoveModel.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

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
    
    if(self.opponent) {
        self.userLabel.text = [NSString stringWithFormat:
                               @"%@ %@",
                               [self.opponent getValueForAttribute:@"first_name"],
                               [self.opponent getValueForAttribute:@"last_name"]];
    } else {
        self.userLabel.text = @"";
    }
    
    if(self.move.question && ![self.move.question isEqual:@""]) {
        self.questionLabel.text = self.move.question;
    } else {
        self.questionLabel.text = [NSString stringWithFormat:@"Is your drink a %@", self.move.quessedCocktail];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action methods

- (IBAction)noButtonClicked:(id)sender {
    [self.delegate didSelectNoForViewController:self];
}
- (IBAction)yesButtonClicked:(id)sender {
    [self.delegate didSelectYesForViewController:self];
}

@end
