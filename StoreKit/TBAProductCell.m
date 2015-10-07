//
//  TBAProductCell.m
//  Mussels
//
//  Copyright (C) 2015 Xiao Yao. All Rights Reserved.
//  See LICENSE.txt for more information.
//

#import "TBAProductCell.h"

#pragma mark - TBAProductCell

@interface TBAProductCell()
@property (nonatomic, strong, readwrite) UIButton *purchaseButton;
@end

@implementation TBAProductCell

#pragma mark Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 30.0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.5*(self.frame.size.height-height), 60.0, height)];
        [button setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        self.purchaseButton = button;
        self.accessoryView = button;
        
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.numberOfLines = 0;
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

@end
