//
//  IWPlatformReleaseView.m
//  LandlordTool
//
//  Created by longshao on 2017/11/29.
//  Copyright © 2017年 superjia. All rights reserved.
//

#import "IWPlatformReleaseView.h"
#import "UIImage+Tint.h"

#define kViewHeight  156.0f
#define kPadding     16.0f
#define kRatioW    (kDeviceWidth/375)
#define kRatioH    (kDeviceHeight/667)


@interface IWPlatformReleaseView () <UITextFieldDelegate>{
    UIControl *_dismmissView;
    UIWindow *_window;
    NSString *_titleText;
}

@end

@implementation IWPlatformReleaseView

-(id)initWithString:(NSString *)str{
    self = [super initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kViewHeight + 40.0f)];
    if (self) {
        _titleText = str;
        self.backgroundColor = [UIColor clearColor];
        [self initSubview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)initSubview{
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 50.0f, 0.0f, 50.0f, 40.0f)];
    _cancelButton.backgroundColor = [UIColor clearColor];
    [_cancelButton setTitle:@"跳过" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _cancelButton.hidden = YES;
    [_cancelButton addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 40.0f, kDeviceWidth, 216*kRatioH + 156.5f)];
    contentView.backgroundColor = kWhiteColor;
    contentView.userInteractionEnabled = YES;
    [self addSubview:contentView];
    
    _titleLaber = [[UILabel alloc]initWithFrame:CGRectMake(kPadding, kPadding, kDeviceWidth - 130.0f - kPadding*2, 20.0f)];
    _titleLaber.backgroundColor = kWhiteColor;
    _titleLaber.font = kAppFont(16.0f);
    _titleLaber.textColor = kRGB(97, 97, 97);
    _titleLaber.text = _titleText;
    _titleLaber.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:_titleLaber];
    
    _verifyButton =[IWVerifyButton sharedInstance];
    [_verifyButton setFrame:CGRectMake(_titleLaber.right, _titleLaber.top, 130, 20.0f) andRadius:4.0f];
    [_verifyButton addTarget:self action:@selector(onVerifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_verifyButton setEnabled:NO];
    _verifyButton.clipsToBounds = YES;
    __weak IWPlatformReleaseView* weakSelf = self;
    _verifyButton.onUnfrozzen = ^(IWVerifyButton * button){
        weakSelf.cancelButton.hidden = NO;
        [weakSelf.verifyButton setEnabled:YES];
    };
    [_verifyButton resetNormal];
    [contentView addSubview:_verifyButton];
    
    _subTitleLaber = [[UILabel alloc]initWithFrame:CGRectMake(kPadding, _titleLaber.bottom+8.0f, kDeviceWidth - kPadding*2, 48.0f)];
    _subTitleLaber.backgroundColor = kWhiteColor;
    _subTitleLaber.textAlignment = NSTextAlignmentLeft;
    _subTitleLaber.font = kAppFont(14.0f);
    _subTitleLaber.textColor = kRGB(117, 117, 117);
    _subTitleLaber.numberOfLines = 0;
    _subTitleLaber.lineBreakMode = NSLineBreakByWordWrapping;
    _subTitleLaber.text = @"首次发布需输入短信验证码，如没有收到，验证码可能以语音电话形式拨出，请注意接听。";
    [contentView addSubview:_subTitleLaber];
    
    UIImageView *lineTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, _subTitleLaber.bottom + 15.5f, kDeviceWidth, 0.5f)];
    lineTop.backgroundColor = kRGB(194, 198, 204);
    [contentView addSubview:lineTop];
    
    _numTextField = [[IHTextField alloc]initWithFrame:CGRectMake(0.0f, _subTitleLaber.bottom + 16.0f, kDeviceWidth - 73.0f - 12.0f - 40.0f, 48.0f)];
    _numTextField.placeholder = @"输入短信验证码";
    _numTextField.paddding = 16.0f;
    _numTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _numTextField.textAlignment = NSTextAlignmentLeft;
    _numTextField.delegate = self;
//    _numTextField.inputAccessoryView = self;
    _numTextField.clearButtonMode = UITextFieldViewModeAlways;
    [_numTextField addTarget:self action:@selector(NumValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:_numTextField];
    
    UIImageView *lineBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, _numTextField.bottom, kDeviceWidth, 0.5f)];
    lineBottom.backgroundColor = kRGB(194, 198, 204);
    [contentView addSubview:lineBottom];
    
    _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(_numTextField.right + 40.0f, _numTextField.top + 8.0f, 73.0f, 32.0f)];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _confirmButton.layer.cornerRadius = 2.0f;
    _confirmButton.clipsToBounds = YES;
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:kFDBStyleColorPress size:_confirmButton.size] forState:UIControlStateHighlighted];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:kFDBStyleColor size:_confirmButton.size] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:kFDBStyleColorDisable size:_confirmButton.size] forState:UIControlStateDisabled];
    _confirmButton.enabled = NO;
    [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_confirmButton];
}

-(void)onVerifyButtonClicked:(id)sender{
    if (self.verifyGetCodeBlock) {
        self.verifyGetCodeBlock();
    }
    [_verifyButton onSendClicked:sender];
}

-(void)confirmAction{
    if (self.confirmBlock) {
        self.confirmBlock(_numTextField.text);
    }
}

-(void)jumpAction{
    if (self.jumpBlock) {
        self.jumpBlock();
    }
    [self cancel];
}

-(void)startCount{
    [_verifyButton onSendClicked:nil];
}

- (void)showDismmissView {
    if (!_window){
        _window = [UIApplication sharedApplication].keyWindow;
    }
    [_window addSubview:[self getDissmissView]];
    [[self getDissmissView] addSubview:self];
    [_numTextField becomeFirstResponder];
}

- (UIControl *)getDissmissView {
    if (!_dismmissView) {
        _dismmissView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dismmissView.backgroundColor = kRGBA(0, 0, 0, 0.4);
    }
    return _dismmissView;
}

-(void)cancel
{
    [_numTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.frame = CGRectZero;
    self.layer.opacity = 0;

    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        if (_dismmissView) {
            [_dismmissView removeFromSuperview];
            _dismmissView = nil;
        }
    }];
}

-(void)setLoadState:(BOOL)isEnable{
    _confirmButton.enabled = isEnable;
}

#pragma -mark ****** delegate ************

-(void)NumValueDidChanged:(IHTextField *)textfield{
    if (textfield.text.length > 6) {
        textfield.text = [textfield.text substringToIndex:6];
    }
    _confirmButton.enabled = textfield.text.length >= 4 ? YES : NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    else if (textField.text.length >= 6) {
        return NO;
    }
    else if ([string containsOnlyNumbers]) {
        return YES;
    }
    return NO;
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
        UIView *responderView = [self findFirstResponder];
        if (responderView) {
            self.bottom = keyboardRect.origin.y;
        }
    } completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
