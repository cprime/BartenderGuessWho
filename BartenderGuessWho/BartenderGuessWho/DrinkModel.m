//
//  DrinkModel.m
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import "DrinkModel.h"

@implementation DrinkModel

+ (NSMutableDictionary *)allDrinks {
    static NSMutableDictionary *_allDrinks = nil;
    if(!_allDrinks) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"drinks" ofType:@"plist"];
        NSDictionary *fileDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSLog(@"%@", fileDictionary);
        
    }
    return _allDrinks;
}
+ (DrinkModel *)drinkWithName:(NSString *)name {
    return [[self allDrinks] objectForKey:name];
}

@end
