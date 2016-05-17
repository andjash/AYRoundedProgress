//
//  RoundedProgressView.h
//  RoundedProgressView
//
//  Created by Andrey Yashnev on 16/05/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoundedProgressView;

@protocol RoundedProgressViewDelegate <NSObject>

@optional
- (void)roundedProgressView:(RoundedProgressView *)progressView willSwitchToStep:(NSInteger)stepIndex;
- (void)roundedProgressView:(RoundedProgressView *)progressView didSwitchToStep:(NSInteger)stepIndex;

@end


@interface RoundedProgressView : UIView

@property (nonatomic, strong) IBOutlet UIView *anchorView;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger stepsCount;
@property (nonatomic, assign) IBInspectable BOOL leftSided;
@property (nonatomic, strong) IBInspectable UIColor *trackColor;
@property (nonatomic, weak) id<RoundedProgressViewDelegate> delegate;

- (void)switchToStep:(NSInteger)stepIndex animated:(BOOL)animated;

@end
