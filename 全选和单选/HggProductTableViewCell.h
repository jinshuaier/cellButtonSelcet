//
//  HggProductTableViewCell.h
//  全选和单选
//
//  Created by 胡高广 on 2017/9/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HggProduct.h"

//声明Block
typedef void(^HggCartBlock)(BOOL select);

@interface HggProductTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel; //名字

@property (nonatomic, strong) UIButton *bigSelectBtn; //全选

@property (nonatomic, strong) UILabel *lineLabel; //线

@property (nonatomic,assign)  BOOL isSelected; //是否被选中

//声明block
@property (nonatomic, copy) HggCartBlock cartBlock;

//方法 //需要传的值
- (void)reloadDataWith:(HggProduct *)model;


@end
