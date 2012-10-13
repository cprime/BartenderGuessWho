//
//  DrinkGridView.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "DrinkGridView.h"

@implementation DrinkGridView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.gridMode = DrinkGridViewModeRegular;
    }
    return self;
}

- (void)reloadData {
    //TODO: load and place nodes
}

- (void)enterSelectionMode {
    
}
- (void)exitSelectionMode {
    
}

@end
