//
//  BaseInfoCell.m
//  ZHLoanClient
//
//  Created by 正和 on 2017/10/24.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "BaseInfoCell.h"

@implementation BaseInfoCell

#pragma mark - 初始化
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"%ld,%ld",(long)[indexPath section],(long)[indexPath row]];
    BaseInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[BaseInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell 默认控件的属性设置
        self.textLabel.font = ZHFont_Title;
        self.textLabel.textColor = UIColorWithRGB(0x323232,1.0);
        
        self.detailTextLabel.font = ZHFont_Title;
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [leftBtn setTitle:@"有" forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorWithRGB(0x676767, 1.0) forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        //button标题的偏移量，这个偏移量是相对于图片的
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
        leftBtn.titleLabel.font = ZHFontSize(15);
        leftBtn.selected = YES;
        leftBtn.tag = 1;
        self.leftBtn = leftBtn;
         self.currentBtn=self.leftBtn;
        
        UIButton *rightBtn = [[UIButton alloc] init];
        self.rightBtn = rightBtn;
        rightBtn.titleLabel.font = ZHFontSize(15);
        [rightBtn setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [rightBtn setTitleColor:UIColorWithRGB(0x676767, 1.0) forState:UIControlStateNormal];
        [rightBtn setTitle:@"无" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
         //button标题的偏移量，这个偏移量是相对于图片的
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
        rightBtn.tag = 0;
    }
    return self;
}

- (void)clickBtn:(UIButton *)btn {
    //如果是选中的话，再次点击就还是选中
    //点击左边按钮
    if (btn.tag == 1) {
        if (self.leftBtn.selected) {
            return;
        } else {
           self.leftBtn.selected = YES;
           self.rightBtn.selected = NO;
        }
    }
    
    if (btn.tag == 0) {
        if (self.rightBtn.selected) {
            return;
        } else {
            self.leftBtn.selected = NO;
            self.rightBtn.selected = YES;
        }
    }

    if (self.btnBlock) {
        NSLog(@"点击了第%ld个按钮",(long)btn.tag);
        self.btnBlock(btn.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.x = ZHFit(15);
    //定位修改位置
    if ([self.textLabel.text isEqualToString:@"所在城市"]) {
        self.detailTextLabel.x = ZHFit(122);
    }else{
        
        self.detailTextLabel.x = ZHFit(103);
    }
     self.detailTextLabel.width=ZHScreenW-self.detailTextLabel.x-ZHFit(40);
    self.detailTextLabel.textAlignment=NSTextAlignmentRight;
    //调整子标题的颜色
    self.detailTextLabel.textColor = [self.detailTextLabel.text isEqualToString:@"请选择"]? UIColorWithRGB(0xc3c3c3, 1.0): UIColorWithRGB(0x676767, 1.0);
    self.leftBtn.x = self.textLabel.right + ZHFit(20);
    self.leftBtn.width = ZHFit(52);
    self.leftBtn.height = ZHFit(25);
    self.leftBtn.centerY = ZHFit(45 / 2);
    
    self.rightBtn.x = self.leftBtn.right + ZHFit(40);
    self.rightBtn.width = ZHFit(54);
    self.rightBtn.height = ZHFit(25);
    self.rightBtn.centerY = ZHFit(45 / 2);
}

@end
