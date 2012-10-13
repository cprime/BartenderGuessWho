//
//  DrinkModel.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrinkModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *glass;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSArray *ingredients;

+ (NSMutableDictionary *)allDrinks;
+ (DrinkModel *)drinkWithName:(NSString *)name;

@end
