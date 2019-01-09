//
//  IWCancellationView.h
//  LandlordTool
//
//  Created by longshao on 2018/10/29.
//  Copyright © 2018年 superjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didselectAction)();

@interface IWCancellationView : UIView

@property(nonatomic,copy)didselectAction selectBlock;

- (instancetype)initWithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withMore:(NSString *)message;

@end
