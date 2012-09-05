//
//  StatusLayout.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "StatusLayout.h"

#define kMarginLeft 8
#define kMarginRight 12
#define kMarginTop 8
#define kMarginV 6
#define kPhotoWidth 60
#define kPhotoHeight 60
#define kPhotoMargin 4
#define kProfileImageSize 24
#define kRetweetMarginH 8
#define kRetweetMarginTop 16
#define kRetweetMarginBottom 8

static NSMutableDictionary *gStatusLayoutDic = nil;

@implementation StatusLayout
@synthesize profileImageBounds, photoImageBounds, textBounds, screenNameBounds;
@synthesize sourceBounds, timestampBounds, commentsBounds, height;
@synthesize retweetBackgroundBounds, retweetTextBounds, retweetCommentsBounds;

- (void)calculateSize:(Status *)status forWidth:(CGFloat)width {
	CGFloat y = kMarginTop;
	profileImageBounds = CGRectMake(kMarginLeft, y, kProfileImageSize, kProfileImageSize);
	//UIFont *timestampFont = [UIFont systemFontOfSize:12];
	screenNameBounds = CGRectMake(kMarginLeft * 2 + kProfileImageSize, y + 2, width, 15);
	
	CGFloat timestampWidth = 100;//[status.timestamp sizeWithFont:timestampFont].width;
	CGFloat x = width - timestampWidth - kMarginRight;
	timestampBounds = CGRectMake(x, y + 4, timestampWidth, 20);
    
	y += kProfileImageSize + kMarginV;
	
	CGFloat textWidth = width - kMarginLeft - kMarginRight + 4;
	NSString *photoUrl = status.retweetedStatus ? status.retweetedStatus.thumbnailPic : status.thumbnailPic;
	BOOL hasPhoto = photoUrl && photoUrl.length > 0;
	if (hasPhoto && !status.retweetedStatus) { // 非转发，有图
		textWidth = width - kPhotoWidth - kPhotoMargin - kMarginLeft - kMarginRight + 4;
		photoImageBounds = CGRectMake(width - kPhotoWidth - kMarginRight, y, kPhotoWidth, kPhotoWidth);
	}
	CGSize textSize = [status.text sizeWithFont:[UIFont systemFontOfSize:15]  
							  constrainedToSize:CGSizeMake(textWidth, 10000)];
	textBounds = CGRectMake(kMarginLeft, y - 2, textWidth, textSize.height);
	
	CGFloat textHeight = textBounds.size.height;
	y = textBounds.origin.y + textHeight;
	if (status.retweetedStatus) {
		y += 0;
		NSString *text = [NSString stringWithFormat:@"%@: %@", status.retweetedStatus.user.screenName, status.retweetedStatus.text];
		CGFloat marginH = kMarginLeft + kMarginRight + kRetweetMarginH * 2;
		CGFloat marginV = kRetweetMarginTop + kRetweetMarginBottom;
		if (hasPhoto) {
			textWidth = width - kPhotoWidth - kPhotoMargin - marginH + 4;
			photoImageBounds = CGRectMake(width - kPhotoWidth - kMarginRight - kRetweetMarginH, y + kRetweetMarginTop, kPhotoWidth, kPhotoHeight);
		}
		else {
			textWidth = width - marginH + 4;
		}
        
		textSize = [text sizeWithFont:[UIFont systemFontOfSize:15]  
                    constrainedToSize:CGSizeMake(textWidth, 10000)];
		retweetTextBounds = CGRectMake(kMarginLeft + kRetweetMarginH, y + kRetweetMarginTop, textWidth, textSize.height);
		textHeight = retweetTextBounds.size.height + 20;
		if (hasPhoto && textHeight < kPhotoHeight) { 
			textHeight = kPhotoHeight;
		}
		retweetCommentsBounds = CGRectMake(kMarginLeft + kRetweetMarginH, y + kRetweetMarginTop + textHeight - 14, textWidth, 14);
		retweetBackgroundBounds = CGRectMake(kMarginLeft, y, width - kMarginLeft - kMarginRight, textHeight + marginV);
		y += kRetweetMarginTop + textHeight + kRetweetMarginBottom;
	}
	else {
		if (hasPhoto && textHeight < kPhotoHeight) {
			textHeight = kPhotoHeight;
		}
		y = textBounds.origin.y + textHeight;
	}
	sourceBounds = CGRectMake(kMarginLeft, y + kMarginV, width, 20);
	commentsBounds = CGRectMake(width - 200 - kMarginRight, y + kMarginV, 200, 20);
    
	height = y + 30;
}

+ (StatusLayout *) layoutWithStatus:(Status*)status width:(CGFloat)width {
	if (!gStatusLayoutDic) {
		gStatusLayoutDic = [[NSMutableDictionary alloc]init];
	}
	NSString *cacheKey = [NSString stringWithFormat:@"layout-si:%lld-w:%f", status.statusId, width];
	StatusLayout *layout = [gStatusLayoutDic objectForKey:cacheKey];
	if (!layout) {
		layout = [[StatusLayout alloc]init];
		[layout calculateSize:status forWidth:width];
		[gStatusLayoutDic setObject:layout forKey:cacheKey];
		[layout release];
	}
	return layout;
}

@end
