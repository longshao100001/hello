//
//  VerifyButton.h
//  platform
//
//  Created by Fleming on 14-5-14.
//  Copyright (c) 2014年 ManYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHButton.h"

@interface IHVerifyButton : IHButton
{
    NSTimer * timer;
    int current ;
}

-(void) onSendClicked:(id)sender;
-(BOOL) isFrozzing;
-(void) stimulateVerifyBtn;

+ (instancetype)sharedInstance;

- (void)setFrame:(CGRect)frame andRadius:(CGFloat)radius;

@property(nonatomic,copy) void(^onUnfrozzen)(IHVerifyButton* );
@end
