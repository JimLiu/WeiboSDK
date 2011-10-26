//
//  UserProfileHeaderView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "UserProfileHeaderView.h"

static UIImage *imgMale = nil;
static UIImage *imgFemale = nil;

@implementation UserProfileHeaderView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		//self.backgroundColor = [UIColor colorWithWhite:0xE6/255.0F alpha:1];
		self.backgroundColor = [UIColor clearColor];
		if (!imgMale) {
			imgMale = [[UIImage imageNamed:@"profile_genderM.png"]retain];
		}
		if (!imgFemale) {
			imgFemale = [[UIImage imageNamed:@"profile_genderW.png"]retain];
		}
		
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	//CGContextRef context = UIGraphicsGetCurrentContext();
	[user.screenName drawInRect:CGRectMake(72, 10, 205, 17) 
					   withFont:[UIFont boldSystemFontOfSize:15] 
				  lineBreakMode:UILineBreakModeTailTruncation];
	
	if (user.gender == GenderMale) {
		[imgMale drawInRect:CGRectMake(72, 31, 14, 14)];
	}
	else if	(user.gender == GenderFemale){
		[imgFemale drawInRect:CGRectMake(72, 31, 14, 14)];
	}
	
	NSString *username = [NSString stringWithFormat:@"#%d", user.userId];
	[username drawInRect:CGRectMake(72, 48, 205, 11) withFont:[UIFont systemFontOfSize:11]];
	
}

@end
