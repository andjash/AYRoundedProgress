//
//  RoundedProgressView.h
//  RoundedProgressView
//
//  Created by Andrey Yashnev on 16/05/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AYRoundedProgressView;

@protocol AYRoundedProgressViewDelegate <NSObject>

@optional
- (void)roundedProgressView:(AYRoundedProgressView *)progressView willSwitchToStep:(NSInteger)stepIndex;
- (void)roundedProgressView:(AYRoundedProgressView *)progressView didSwitchToStep:(NSInteger)stepIndex;

@end


@interface AYRoundedProgressView : UIView

@property (nonatomic, strong) IBOutlet UIView *anchorView;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger stepsCount;
@property (nonatomic, assign) IBInspectable BOOL leftSided;
@property (nonatomic, strong) IBInspectable UIColor *trackColor;
@property (nonatomic, weak) id<AYRoundedProgressViewDelegate> delegate;

- (void)switchToStep:(NSInteger)stepIndex animated:(BOOL)animated;

@end
