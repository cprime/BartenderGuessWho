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
        NSArray *fileArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        _allDrinks = [[NSMutableDictionary alloc] initWithCapacity:30];
        for(NSDictionary *dictionary in fileArray) {
            DrinkModel *drinkModel = [[DrinkModel alloc] init];
            
            drinkModel.name = [dictionary objectForKey:@"name"];
            drinkModel.glass = [dictionary objectForKey:@"glass"];
            drinkModel.imageName = [dictionary objectForKey:@"image"];
            drinkModel.ingredients = [dictionary objectForKey:@"ingredients"];
            
            [_allDrinks setObject:drinkModel forKey:drinkModel.name];
        }
    }
    return _allDrinks;
}
+ (DrinkModel *)drinkWithName:(NSString *)name {
    return [[self allDrinks] objectForKey:name];
}

@end
