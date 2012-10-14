//
//  DrinkGridView.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "DrinkGridView.h"
#import "DrinkGridNodeView.h"
#import "DrinkModel.h"

#define kDrinkGridViewNodePerRow 6

#define kDrinkGridViewNodeXOffset 30
#define kDrinkGridViewNodeYOffset 18
#define kDrinkGridViewNodeXBuffer 20
#define kDrinkGridViewNodeYBuffer 15

#define kDrinkGridViewNodeWidth 90
#define kDrinkGridViewNodeHeight 90

#define kDrinkGridViewNodeSelectedAlpha 1.0
#define kDrinkGridViewNodeDeselectedAlpha 0.5

@implementation DrinkGridView

- (void)didDetectTap:(UITapGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)  {
        CGPoint point = [gestureRecognizer locationInView:self];
        for(DrinkGridNodeView *node in self.drinkNodes) {
            if(CGRectContainsPoint(node.frame, point)) {
                
                if(node.selected) {
                    if(self.gridMode == DrinkGridViewModeRegular) {
                        node.selected = NO;
                        node.alpha = kDrinkGridViewNodeDeselectedAlpha;
                        [self.delegate gridView:self didDeselectDrink:node.drink];
                    } else if(self.gridMode == DrinkGridViewModeSelection) {
                        for(DrinkGridNodeView *nodeB in self.drinkNodes) {
                            if(node != nodeB) {
                                nodeB.alpha = kDrinkGridViewNodeDeselectedAlpha;
                            }
                        }
                        [self.delegate gridView:self didSelectDrink:node.drink];
                    }
                } else {
                    if(self.gridMode == DrinkGridViewModeRegular) {
                        node.selected = YES;
                        node.alpha = kDrinkGridViewNodeSelectedAlpha;
                        [self.delegate gridView:self didSelectDrink:node.drink];
                    }
                }
            
                break;
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.gridMode = DrinkGridViewModeRegular;
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDetectTap:)];
        [self addGestureRecognizer:tapGr];
    }
    return self;
}

- (void)reloadData {
    //TODO: load and place nodes
    for(DrinkGridNodeView *node in self.drinkNodes) {
        [node removeFromSuperview];
    }
    
    NSInteger col = 0;
    NSInteger row = 0;
    self.drinkNodes = [[NSMutableArray alloc] initWithCapacity:30];
    for(DrinkModel *drink in self.drinks) {
        DrinkGridNodeView *node = [[DrinkGridNodeView alloc] initWithFrame:CGRectMake(kDrinkGridViewNodeXOffset + (col * (kDrinkGridViewNodeWidth + kDrinkGridViewNodeXBuffer)),
                                                                                      kDrinkGridViewNodeYOffset + (row * (kDrinkGridViewNodeWidth + kDrinkGridViewNodeYBuffer)),
                                                                                      kDrinkGridViewNodeWidth,
                                                                                      kDrinkGridViewNodeHeight)];
        node.drink = drink;
        node.selected = YES;
        node.imageView.image = [UIImage imageNamed:drink.imageName];
        
        [self addSubview:node];
        [self.drinkNodes addObject:node];
        
        col++;
        if(col >= kDrinkGridViewNodePerRow) {
            col = 0;
            row++;
        }
    }
}

- (void)enterSelectionMode {
    self.gridMode = DrinkGridViewModeSelection;
}
- (void)exitSelectionMode {
    self.gridMode = DrinkGridViewModeRegular;
    for(DrinkGridNodeView *node in self.drinkNodes) {
        if(node.selected) {
            node.alpha = kDrinkGridViewNodeSelectedAlpha;
        } else {
            node.alpha = kDrinkGridViewNodeDeselectedAlpha;
        }
    }
}

@end