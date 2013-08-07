//
//  SimpleTableViewCell.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-1.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewCell : UITableViewCell {
    UIView* contentView;
}

- (void)drawContentView:(CGRect)rect;


@end
