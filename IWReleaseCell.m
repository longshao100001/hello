//
//  IWReleaseCell.m
//  LandlordTool
//
//  Created by longshao on 2018/10/24.
//  Copyright © 2018年 superjia. All rights reserved.
//

#import "IWReleaseCell.h"
#import "IWViewFactory.h"

#define kUnableColor kRGB(255, 46, 65)
#define kEnableColor kRGB(60, 211, 31)
#define kCellHeight 68.0f

@implementation IWReleaseCell{
    UILabel *_iconLabel,*_statuesLabel,*_titleLabel,*_subLabel;
    UIButton *_setButton;
    IWInfoType _houseType;
    IWReleaseCommonModel *_commonModel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(21.0f, 12.0f, 32.0f, 36.0f)];
    _iconLabel.textColor = kRGB(0, 0, 0);
    _iconLabel.font = kIconFont(32.0f);
    [self.contentView addSubview:_iconLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconLabel.right + 12.0f, 12.0f, kDeviceWidth - 140.0f, 16.0f)];
    _titleLabel.textColor = kRGB(51, 51, 51);
    _titleLabel.font = kAppFont(16.0f);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 8.0f, _titleLabel.width, 12.0f)];
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.numberOfLines = 0;
    _subLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subLabel.font = kAppFont(12.0f);
    _subLabel.textColor = kRGB(117, 117, 117);
    [self.contentView addSubview:_subLabel];
    
    _statuesLabel = [[UILabel alloc]init];
    _statuesLabel.font = kIconFont(8.0f);
    _statuesLabel.backgroundColor = kWhiteColor;
    _statuesLabel.size = CGSizeMake(16, 16);
    _statuesLabel.textAlignment = NSTextAlignmentCenter;
    _statuesLabel.right = _iconLabel.width;
    _statuesLabel.bottom = _iconLabel.height;
    [_iconLabel addSubview:_statuesLabel];
    
    _setButton = [IWViewFactory FDBBorderButton:@"去设置"];
    _setButton.size = CGSizeMake(74.0f, 28.0f);
    _setButton.right = kDeviceWidth - 20.0f;
    _setButton.centerY = 34.0f;
    [_setButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_setButton];
    
    UIImageView *seperateLine = [[UIImageView alloc]initWithFrame:CGRectMake(16.0f, 67.5f, kDeviceWidth - 16.0f, 0.5f)];
    seperateLine.backgroundColor = kRGB(231, 231, 231);
    [self.contentView addSubview:seperateLine];
}

- (void)updateWithData:(IWReleaseCommonModel *)model withType:(IWInfoType)type {
    _houseType = type;
    _commonModel = model;
    [self setBaseInfo];
}

- (void)setBaseInfo{
    _setButton.hidden = YES;
    _statuesLabel.textColor = kEnableColor;
    _statuesLabel.text = kIcon_duihao;
    _subLabel.top = _titleLabel.bottom + 8.0f;
    _subLabel.height = 12.0f;
    if (_houseType == IWHouseBaseInfo) {
        _iconLabel.text = kIcon_fangwuxinxi;
        _titleLabel.text = @"房屋信息完整";
        _subLabel.text = @"配置，描述";
        [_setButton setTitle:@"" forState:UIControlStateNormal];
        if ([_commonModel.upRuleList containsObject:[NSNumber numberWithLong:5]] || [_commonModel.upRuleList containsObject:[NSNumber numberWithLong:6]]) {
            _statuesLabel.text = kIcon_chahao;
            _statuesLabel.textColor = kUnableColor;
            [_setButton setTitle:@"去设置" forState:UIControlStateNormal];
            _setButton.hidden = NO;
        }
    }else if(_houseType == IWHouseImageInfo) {
        _iconLabel.text = kIcon_wanshantupian;
        _titleLabel.text = @"完善图片";
        _subLabel.top = _titleLabel.bottom + 4.0f;
        _subLabel.height = 30.0f;
        _subLabel.text = @"至少有3张审核成功的图片\n其中必须有房间图片";
        if ([_commonModel.upRuleList containsObject:[NSNumber numberWithLong:4]]) {
            _statuesLabel.text = kIcon_chahao;
            _statuesLabel.textColor = kUnableColor;
            [_setButton setTitle:@"去上传" forState:UIControlStateNormal];
            _setButton.hidden = NO;
        }
    }else if(_houseType == IWHouseReleaseFailedNet) {
        _iconLabel.text = kIcon_wangluoduankai;
        _titleLabel.text = @"断网";
        _subLabel.text = @"门锁长期断网";
        if ([_commonModel.upRuleList containsObject:[NSNumber numberWithLong:7]]) {
            _statuesLabel.text = kIcon_chahao;
            _statuesLabel.textColor = kUnableColor;
            _setButton.hidden = NO;
            [_setButton setTitle:@"去查看" forState:UIControlStateNormal];
        }
    }else if(_houseType == IWHouseReleaseFailedAgent) {
        _iconLabel.text = kIcon_wangluoduankai;
        _titleLabel.text = @"顾问下架";
        _subLabel.text = @"您的房屋已被下架";
        if ([_commonModel.upRuleList containsObject:[NSNumber numberWithLong:8]]) {
            _statuesLabel.text = kIcon_chahao;
            _statuesLabel.textColor = kUnableColor;
            _setButton.hidden = NO;
            [_setButton setTitle:@"联系顾问" forState:UIControlStateNormal];
        }
    }
}

- (void)setAction {
    if(_houseType == IWHouseReleaseFailedAgent) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_commonModel.bdMobile]];
        return;
    }
    if (self.clickAction) {
        self.clickAction();
    }
}



@end
