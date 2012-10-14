//
//  AnswerViewController.h
//  BartenderGuessWho
//
//  Created by Colden Prime on 10/13/12.
//  Copyright (c) 2012 IntrepidPursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnswerViewControllerDelegate;
@class MoveModel;
@class GameModel;

@interface AnswerViewController : UIViewController

@property (assign, nonatomic) id<AnswerViewControllerDelegate> delegate;
@property (strong, nonatomic) KCSUser *opponent;
@property (strong, nonatomic) GameModel *game;
@property (strong, nonatomic) MoveModel *move;

@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

- (IBAction)noButtonClicked:(id)sender;
- (IBAction)yesButtonClicked:(id)sender;

@end


@protocol AnswerViewControllerDelegate <NSObject>

- (void)didSelectYesForViewController: (AnswerViewController *)viewController;
- (void)didSelectNoForViewController: (AnswerViewController *)viewController;

@end