//
//  DrinkSelectionViewController.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrinkModel;
@protocol DrinkSelectionViewControllerDelegate;

@interface DrinkSelectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<DrinkSelectionViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *drinks;
@property (strong, nonatomic) IBOutlet UITableView *drinksTableView;

@end

@protocol DrinkSelectionViewControllerDelegate <NSObject>

- (void)viewController:(DrinkSelectionViewController *)viewController didSelectDrink:(DrinkModel *)drink;

@end
