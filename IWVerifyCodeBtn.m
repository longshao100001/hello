//
//  IWVerifyCodeBtn.m
//  LandlordTool
//
//  Created by longshao on 2018/7/6.
//  Copyright © 2018年 superjia. All rights reserved.
//

#import "IWVerifyCodeBtn.h"

#define kGetVerifyCode @"获取验证码"
#define kLeftRetryVerifyTime @"剩余 %d S"

#define kEnableColor kYLAutoStyleColor
#define kDisableColor kRGB(190, 190, 190)

static IWVerifyCodeBtn *instance=nil;

@implementation IWVerifyCodeBtn

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
    [self setTitleColor:kEnableColor forState:UIControlStateNormal];
    [self setTitleColor:kDisableColor forState:UIControlStateDisabled];
    [self setTitle:kGetVerifyCode forState:UIControlStateNormal];
    [self setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
    [self setBackgroundColor:kWhiteColor forState:UIControlStateDisabled];
    [self addTarget:self action:@selector(onVerifyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self setEnabled:NO];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = kDisableColor.CGColor;
}

-(void)onVerifyButtonClicked{
    if (self.didselectBtn) {
        self.didselectBtn();
    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        self.layer.borderColor = kEnableColor.CGColor;
    }else{
        self.layer.borderColor = kDisableColor.CGColor;
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

-(void) resetState{
    if (timer) {
        [timer invalidate];timer = nil;
    }
    [timer invalidate];
    current = 60.0f;
    [self setEnabled:NO];
    [self setTitle:kGetVerifyCode forState:UIControlStateNormal];
}


-(BOOL) isFrozzing{
    if (!timer) return NO;
    return  [timer isValid] && current>0;
}


@end
