//
//  IWVerifyCodeBtn.h
//  LandlordTool
//
//  Created by longshao on 2018/7/6.
//  Copyright © 2018年 superjia. All rights reserved.
//

#import "IHButton.h"

typedef void(^clickBtn) ();

@interface IWVerifyCodeBtn : IHButton
{
    NSTimer * timer;
    int current ;
}

-(void) onSendClicked:(id)sender;
-(BOOL) isFrozzing;
-(void) stimulateVerifyBtn;
-(void) resetState;

+ (instancetype)sharedInstance;

- (void)setFrame:(CGRect)frame andRadius:(CGFloat)radius;

@property(nonatomic,copy) void(^onUnfrozzen)(IWVerifyCodeBtn* );
@property(nonatomic,copy) clickBtn didselectBtn;



@end
