//
//  DrinkGridNodeView.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrinkModel;

@interface DrinkGridNodeView : UIView

@property (strong, nonatomic) DrinkModel *drink;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) UIImageView *imageView;

@end
