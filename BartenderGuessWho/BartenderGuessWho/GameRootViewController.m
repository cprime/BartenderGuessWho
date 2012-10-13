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

@interface GameRootViewController ()

@end

@implementation GameRootViewController

- (IBAction)askQuestionButtonClicked:(id)sender {
    //TODO: ask question
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
    
    //TODO: add tap recognizer to otherCocktailImageView
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

@end
