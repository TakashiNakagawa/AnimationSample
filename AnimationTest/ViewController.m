//
//  ViewController.m
//  AnimationTest
//
//  Created by 中川 高志 on 2013/03/04.
//  Copyright (c) 2013年 CFlat. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

static const CGPoint kStartPosition = {160, 230};
static const CGPoint kEndPosition = {0, 460};

@interface ViewController ()

@property CGMutablePathRef path;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.path = CGPathCreateMutable();
    CGPathMoveToPoint(self.path, NULL, kStartPosition.x, kStartPosition.y);

    // カーブを作りたい場合
//    float height = 0;
//    CGPathAddCurveToPoint(self.path, NULL,
//                          kStartPosition.x - height, kStartPosition.y,
//                          kEndPosition.x - height, kStartPosition.y,
//                          kEndPosition.x, kEndPosition.y);
    
//    CGPathAddLineToPoint(self.path, NULL, kStartPosition.x - 10, kStartPosition.y + 30);
    
    CGPathAddLineToPoint(self.path, NULL, kEndPosition.x, kEndPosition.y);
    
    CALayer *layer = [CALayer layer];
    [layer setContents:(__bridge id)[UIImage imageNamed:@"american-flag"].CGImage];
    [layer setBounds:CGRectMake(0, 0, 75, 75)];
    [layer setPosition:CGPointMake(15, 15)];
    
    [self addPathanimationToLayer:layer];
    
    [self.view.layer addSublayer:layer];
    self.view.layer.delegate = self;
    [self.view.layer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    if (self.path) {
        CFRelease(self.path);
    }
    [[self.view.layer sublayers][0] setDelegate:nil];
}


#pragma mark - Path Drawing
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
//    // 後で消す
//    CGContextAddPath(ctx, _path);
//    CGContextSetShadow(ctx, CGSizeMake(2.5, 2.5), 2.0);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
//    CGContextStrokePath(ctx);
}

- (void) addPathanimationToLayer:(CALayer *)layer
{
    [layer removeAllAnimations];
    
    layer.position = kEndPosition;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:self.path];
    [animation setCalculationMode:kCAAnimationCubic];
    [animation setAutoreverses:NO];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.delegate = self;

    CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flash.fromValue = [NSNumber numberWithFloat:0.0];
    flash.toValue = [NSNumber numberWithFloat:1.0];
    
    flash.delegate = self;
    
    // 拡大縮小の設定
    CABasicAnimation *scaoleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.fromValue = [NSNumber numberWithFloat:6];
    scaoleAnimation.toValue = [NSNumber numberWithFloat:0.3];
    
    scaoleAnimation.delegate = self;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = NO;
    group.duration = 0.7;
    group.animations = @[animation, flash, scaoleAnimation];
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.delegate = self;
    [group setValue:@"groupAnimation" forKey:@"animationName"];
    [layer addAnimation:group forKey:@"groupAnimation"];


}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished)
    {
        NSString *animationName = [anim valueForKey:@"animationName"];
        NSLog(@"%@", animationName);
    }
    
}



@end
