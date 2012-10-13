//
//  DrinkGridView.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DrinkGridViewModeRegular,
    DrinkGridViewModeSelection,
} DrinkGridViewMode;

@protocol DrinkGridViewDelegate;
@class DrinkModel;

@interface DrinkGridView : UIView

@property (weak, nonatomic) id<DrinkGridViewDelegate> delegate;
@property (assign, nonatomic) DrinkGridViewMode gridMode;
@property (strong, nonatomic) NSMutableArray *drinkNodes;
@property (strong, nonatomic) NSMutableArray *drinks;

- (void)reloadData;
- (void)enterSelectionMode;
- (void)exitSelectionMode;

@end


@protocol DrinkGridViewDelegate <NSObject>

- (void)gridView:(DrinkGridView *)gridView didSelectDrink:(DrinkModel *)drink;

@end