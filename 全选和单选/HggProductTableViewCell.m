//
//  HggProductTableViewCell.m
//  全选和单选
//
//  Created by 胡高广 on 2017/9/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "HggProductTableViewCell.h"
#import "UILabel+MyLable.h"

//RGB的颜色转换
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface HggProductTableViewCell ()

//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;

@end

@implementation HggProductTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.backgroundColor = kUIColorFromRGB(0xffffff);
        [self createView];
        
    }
    return self;
}

- (void)createView {
    self.nameLabel = [UILabel initWithText:@"壹休" withFontSize:14 WithFontColor:kUIColorFromRGB(0x666666) WithMaxSize:CGSizeMake(WIDTH - 50, 14)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.frame = CGRectMake(14, 18, WIDTH - 80, 14);
    [self.contentView addSubview:self.nameLabel];
    
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(WIDTH - 35, 15, 20, 20);
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.selectBtn];
    
    
    
    
    _bigSelectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _bigSelectBtn.frame = CGRectMake(0, 0, WIDTH , 50);
    _bigSelectBtn.backgroundColor = [UIColor clearColor];
    [_bigSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_bigSelectBtn];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, WIDTH, 0.5)];
    _lineLabel.backgroundColor = kUIColorFromRGB(0xf0f0f0);
    [self.contentView addSubview:_lineLabel];
    
}

-(void)reloadDataWith:(HggProduct *)model {
    self.nameLabel.text = model.nameStr;
    
    self.selectBtn.selected = self.isSelected;
    
}

//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.cartBlock) {
        self.cartBlock(self.selectBtn.selected);
    }
    
}
@end
