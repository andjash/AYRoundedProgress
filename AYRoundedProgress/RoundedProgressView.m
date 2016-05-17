//
//  RoundedProgressView.m
//  RoundedProgressView
//
//  Created by Andrey Yashnev on 16/05/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

#import "RoundedProgressView.h"

IB_DESIGNABLE
@interface RoundedProgressView ()

@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat stepAngle;

@end

@implementation RoundedProgressView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    if (self.leftSided) {
        [bp addArcWithCenter:CGPointMake(self.frame.size.width * 2.5, self.frame.size.height / 2) radius:self.frame.size.width * 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    } else {
        [bp addArcWithCenter:CGPointMake(- self.frame.size.width * 1.5, self.frame.size.height / 2) radius:self.frame.size.width * 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    }

    bp.lineWidth = 2;
    if (self.trackColor) {
        [self.trackColor setStroke];
    } else {
        [[UIColor blackColor] setStroke];
    }
    [bp stroke];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.startPoint = [self circleIntersectionStartPoint];
    self.endPoint = [self circleIntersectionEndPoint];
    if (self.leftSided) {
        self.startAngle = (M_PI * 2) - [self radiansBy:self.startPoint.x and:self.startPoint.y];
        self.endAngle = [self radiansBy:self.endPoint.x and:self.endPoint.y];
        self.stepAngle = -(self.startAngle - self.endAngle) / (self.stepsCount - 1);
    } else {
        self.startAngle = - [self radiansBy:self.startPoint.x and:self.startPoint.y];
        self.endAngle = [self radiansBy:self.endPoint.x and:self.endPoint.y];
        self.stepAngle = (- self.startAngle + self.endAngle ) / (self.stepsCount - 1);
    }
    self.currentAngle = self.startAngle;
    self.anchorView.center = self.startPoint;
}

#pragma mark - Public

- (void)switchToStep:(NSInteger)stepIndex animated:(BOOL)animated {    
    stepIndex = MAX(0, MIN(stepIndex, self.stepsCount - 1));
    
    if ([self.delegate respondsToSelector:@selector(roundedProgressView:willSwitchToStep:)]) {
        [self.delegate roundedProgressView:self willSwitchToStep:stepIndex];
    }
    
    CGFloat angleChange = self.stepAngle * (labs(self.currentStep - stepIndex));
    
    if (!animated) {
        if (stepIndex > self.currentStep) {
            self.currentAngle += angleChange;
        } else {
            self.currentAngle -= angleChange;
        }
        CGPoint newPositionPoint = [self positionByAngle:self.currentAngle radius:self.frame.size.width * 2];
        [self.anchorView.layer removeAllAnimations];
        self.anchorView.center = newPositionPoint;
        self.currentStep = stepIndex;        
        if ([self.delegate respondsToSelector:@selector(roundedProgressView:didSwitchToStep:)]) {
            [self.delegate roundedProgressView:self didSwitchToStep:stepIndex];
        }
        return;
    }
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeBoth;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPoint currentPositionPoint = [self positionByAngle:self.currentAngle radius:self.frame.size.width * 2];
    
    CGPathMoveToPoint(curvedPath, NULL, currentPositionPoint.x, currentPositionPoint.y);
    if (self.leftSided) {
        if (stepIndex > self.currentStep) {
            CGPathAddArc(curvedPath, NULL, self.frame.size.width * 2.5, self.frame.size.height / 2, self.frame.size.width * 2, -self.currentAngle,  -(self.currentAngle + angleChange), NO);
        } else {
            CGPathAddArc(curvedPath, NULL, self.frame.size.width * 2.5, self.frame.size.height / 2, self.frame.size.width * 2, -self.currentAngle,  -(self.currentAngle - angleChange), YES);
        }
    } else {
        if (stepIndex > self.currentStep) {
            CGPathAddArc(curvedPath, NULL, -self.frame.size.width * 1.5, self.frame.size.height / 2, self.frame.size.width * 2, -self.currentAngle, -(self.currentAngle + angleChange), YES);
        } else {
            CGPathAddArc(curvedPath, NULL, -self.frame.size.width * 1.5, self.frame.size.height / 2, self.frame.size.width * 2, -self.currentAngle, -(self.currentAngle - angleChange), NO);
        }
    }
    if (stepIndex > self.currentStep) {
        self.currentAngle += angleChange;
    } else {
        self.currentAngle -= angleChange;
    }
    self.currentStep = stepIndex;
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.anchorView.layer addAnimation:pathAnimation forKey:@"moveAnimation"];
    if ([self.delegate respondsToSelector:@selector(roundedProgressView:didSwitchToStep:)]) {
        [self.delegate roundedProgressView:self didSwitchToStep:stepIndex];
    }
}

#pragma mark - Private

- (CGFloat)radiansBy:(CGFloat)x and:(CGFloat)y {
    CGFloat x0 = self.frame.size.width * 2;;
    CGFloat y0 = 0;
    if (self.leftSided) {
        x = (x - self.frame.size.width * 2.5);
        y = (self.frame.size.height / 2 - y);
    } else {
        x = (x + self.frame.size.width * 1.5);
        y = (self.frame.size.height / 2 - y);
    }
    CGFloat topSide = (x0 * x + y0 * y);
    CGFloat bottomSide = (sqrtf(x0 * x0 + y0 * y0) * sqrtf(x * x + y * y));
    CGFloat cos = topSide / bottomSide;
    return acosf(cos);
}

- (CGPoint)circleIntersectionStartPoint {
    if (self.leftSided) {
        return [self intersectionPointOfLineWithCircleWithCenter:CGPointMake(self.frame.size.width * 2.5, self.frame.size.height / 2)
                                                          radius:self.frame.size.width * 2
                                                       lineStart:CGPointMake(0, self.frame.size.height)
                                                         lineEnd:CGPointMake(self.frame.size.width, self.frame.size.height)];
    } else {
        return [self intersectionPointOfLineWithCircleWithCenter:CGPointMake(-self.frame.size.width * 1.5, self.frame.size.height / 2)
                                                          radius:self.frame.size.width * 2
                                                       lineStart:CGPointMake(0, self.frame.size.height)
                                                         lineEnd:CGPointMake(self.frame.size.width, self.frame.size.height)];
    }
}

- (CGPoint)circleIntersectionEndPoint {
    if (self.leftSided) {
        return [self intersectionPointOfLineWithCircleWithCenter:CGPointMake(self.frame.size.width * 2.5, self.frame.size.height / 2)
                                                          radius:self.frame.size.width * 2
                                                       lineStart:CGPointMake(0, 0)
                                                         lineEnd:CGPointMake(self.frame.size.width, 0)];
    } else {
        return [self intersectionPointOfLineWithCircleWithCenter:CGPointMake(-self.frame.size.width * 1.5, self.frame.size.height / 2)
                                                          radius:self.frame.size.width * 2
                                                       lineStart:CGPointMake(0, 0)
                                                         lineEnd:CGPointMake(self.frame.size.width, 0)];
    }
}

- (BOOL)isDistance:(CGFloat)testingDistance nearlyDistance:(CGFloat)targetDistance {
    return testingDistance > (targetDistance  - 0.25) && testingDistance < (targetDistance + 0.25);
}

- (CGFloat)distanceBetween:(CGPoint)first and:(CGPoint)second {
    CGFloat firstPart = (second.x - first.x) * (second.x - first.x);
    CGFloat secondPart = (second.y - first.y) * (second.y - first.y);
    return sqrtf(firstPart + secondPart);
}


- (CGPoint)intersectionPointOfLineWithCircleWithCenter:(CGPoint)circleCenter
                                                radius:(CGFloat)radius
                                             lineStart:(CGPoint)lineStart
                                               lineEnd:(CGPoint)lineEnd {
    CGFloat nearestToTargetDistance = CGFLOAT_MAX;
    CGPoint nearestToTargetDistancePoint = CGPointZero;
    
    CGFloat currentXOrigin = lineStart.x;
    for (int i = 0; i < lineEnd.x - lineStart.x; i++) {
        CGPoint testingPoint = CGPointMake(currentXOrigin + i, lineStart.y);
        CGFloat distance = [self distanceBetween:circleCenter and:testingPoint];
        if (fabs(radius - distance) < nearestToTargetDistance) {
            nearestToTargetDistance = fabs(radius - distance);
            nearestToTargetDistancePoint = testingPoint;
        }
    }
    return nearestToTargetDistancePoint;
}



- (CGPoint)positionByAngle:(CGFloat)angle radius:(CGFloat)radius {
    if (self.leftSided) {
        return CGPointMake(self.frame.size.width * 2.5 + (radius * cosf(angle)), self.frame.size.height / 2 - (radius * sinf(angle)));
    } else {
        return CGPointMake(-self.frame.size.width * 1.5 + (radius * cosf(angle)), self.frame.size.height / 2 - (radius * sinf(angle)));
    }
}

@end
