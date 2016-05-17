//
//  ViewController.m
//  AYRoundedProgress
//
//  Created by Andrey Yashnev on 17/05/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

#import "ViewController.h"
#import "AYRoundedProgressView.h"

@interface ViewController ()<AYRoundedProgressViewDelegate>

@property (nonatomic, weak) IBOutlet AYRoundedProgressView *firstProgress;
@property (nonatomic, weak) IBOutlet AYRoundedProgressView *secondProgress;

@property (nonatomic, weak) IBOutlet UIView *firstProgressContainer;
@property (nonatomic, weak) IBOutlet UILabel *firstProgressLabel;
@property (nonatomic, weak) IBOutlet UIView *secondProgressContainer;
@property (nonatomic, weak) IBOutlet UILabel *secondProgressLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstProgress.leftSided = YES;
    self.firstProgress.stepsCount = 10;
    self.secondProgress.stepsCount = 5;
    self.firstProgress.delegate = self;
    self.secondProgress.delegate = self;
    
    self.firstProgressContainer.layer.cornerRadius =
    self.secondProgressContainer.layer.cornerRadius = 30;
    
    self.firstProgressContainer.layer.borderWidth =
    self.secondProgressContainer.layer.borderWidth = 1;
    
    self.firstProgressContainer.layer.borderColor =
    self.secondProgressContainer.layer.borderColor = self.firstProgressLabel.textColor.CGColor;
}

#pragma marl - AYRoundedProgressViewDelegate

- (void)roundedProgressView:(AYRoundedProgressView *)progressView willSwitchToStep:(NSInteger)stepIndex {
    if (progressView == self.firstProgress) {
        self.firstProgressLabel.text = [NSString stringWithFormat:@"%@", @(stepIndex)];
    } else {
        self.secondProgressLabel.text = [NSString stringWithFormat:@"%@", @(stepIndex)];
    }
}

#pragma mark - Actions

- (IBAction)increase:(id)sender {
    [self.firstProgress switchToStep:self.firstProgress.currentStep + 1 animated:YES];
    [self.secondProgress switchToStep:self.secondProgress.currentStep + 1 animated:YES];
}

- (IBAction)decrease:(id)sender {
    [self.firstProgress switchToStep:self.firstProgress.currentStep - 1 animated:YES];
    [self.secondProgress switchToStep:self.secondProgress.currentStep - 1 animated:YES];
}

@end
