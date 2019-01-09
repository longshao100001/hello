//
//  VerifyButton.m
//  platform
//
//  Created by Fleming on 14-5-14.
//  Copyright (c) 2014年 ManYi. All rights reserved.
//

#import "IHVerifyButton.h"

#define kGetVerifyCode @"获取验证码"
#define kLeftRetryVerifyTime @"剩余 %d S"


static IHVerifyButton *instance=nil;

@implementation IHVerifyButton

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self=[super init];
    if (self) {
        [self setAppearance];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAppearance];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius
{
    self = [super initWithFrame:frame andRadius:radius];
    if (self) {
        [self setAppearance];
    }
    return self;
}


- (void)setAppearance{
    [self setTitleColor:kFDBStyleColor forState:UIControlStateNormal];
    [self setTitleColor:kFDBStyleColorDisable forState:UIControlStateDisabled];
    [self setTitleColor:kFDBStyleColorPress forState:UIControlStateHighlighted];
    [self setTitle:kGetVerifyCode forState:UIControlStateNormal];
    [self setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
    [self setBackgroundColor:kWhiteColor forState:UIControlStateDisabled];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = kFDBStyleColor.CGColor;
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        self.layer.borderColor = kFDBStyleColor.CGColor;
    }else{
        self.layer.borderColor = kFDBStyleColorDisable.CGColor;
    }
}


- (void)setFrame:(CGRect)frame andRadius:(CGFloat)radius{
    self.frame=frame;
    self.radius=radius;
    self.layer.cornerRadius = radius;
}


-(void) onSendClicked:(id)sender{
    current = 60;
    [self setEnabled:NO];
    [self setTitle:[NSString stringWithFormat:kLeftRetryVerifyTime,current--,nil] forState:UIControlStateDisabled];
    timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onCountTime) userInfo:nil repeats:YES];
}

-(void) onCountTime{
    if (current>0) {
        [self setTitle:[NSString stringWithFormat:kLeftRetryVerifyTime,current--,nil] forState:UIControlStateDisabled];
    }else{
        [self stimulateVerifyBtn];
    }
}

-(void) stimulateVerifyBtn{
    [timer invalidate];
    [self setEnabled:YES];
    [self setTitle:kGetVerifyCode forState:UIControlStateNormal];
    [self setTitle:kGetVerifyCode forState:UIControlStateDisabled];
    if (self.onUnfrozzen) {
        self.onUnfrozzen(self);
    }
}


-(BOOL) isFrozzing{
    if (!timer) return NO;
    return  [timer isValid] && current>0;
}

@end
