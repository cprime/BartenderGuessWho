//
//  DrinkGridNodeView.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "DrinkGridNodeView.h"

@implementation DrinkGridNodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.selected = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

@end
