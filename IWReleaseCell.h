//
//  IWReleaseCell.h
//  LandlordTool
//
//  Created by longshao on 2018/10/24.
//  Copyright © 2018年 superjia. All rights reserved.
//

#import "IHTableViewCell.h"
#import "IWReleaseCommonModel.h"

typedef NS_ENUM(NSUInteger,IWInfoType) {
    IWHouseBaseInfo,
    IWHouseImageInfo,
    IWHouseReleaseFailedNet,
    IWHouseReleaseFailedAgent,
};

typedef void(^clickButton)();

@interface IWReleaseCell : IHTableViewCell

@property(nonatomic, copy)clickButton clickAction;

- (void)updateWithData:(IWReleaseCommonModel *)model withType:(IWInfoType)type;


@end
