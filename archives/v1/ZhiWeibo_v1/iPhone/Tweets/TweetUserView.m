//
//  TweetUserView.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetUserView.h"


@implementation TweetUserView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {	
		imgMale = [[UIImage imageNamed:@"profile_genderM.png"]retain];
		imgFemale = [[UIImage imageNamed:@"profile_genderW.png"]retain];
		
		detailsArrowimageView = [[UIImageView alloc]initWithImage:
								  [[UIImage imageNamed:@"tweet-details-arrow.png"] stretchableImageWithLeftCapWidth:48 topCapHeight:0]];
		detailsArrowimageView.frame = CGRectMake(0, 60, self.frame.size.width, 20);
		[self addSubview:detailsArrowimageView];
		[detailsArrowimageView release];
		
		chevronImageView = [[UIImageView alloc]initWithImage:
							[UIImage imageNamed:@"TweetDetailsChevron.png"]];
		chevronImageView.frame = CGRectMake(self.frame.size.width - 11 - 8, (80 - 15) / 2, 11, 15);
		[self addSubview:chevronImageView];
		[chevronImageView release];
		
		screenNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 16, 200, 20)];
		screenNameLabel.textColor = [UIColor colorWithRed:0x1f/255.0F green:0x28/255.0F blue:0x39/255.0F alpha:1];
		screenNameLabel.backgroundColor = [UIColor clearColor];
		screenNameLabel.font = [UIFont boldSystemFontOfSize:17];
		
		locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 38, 200, 20)];
		locationLabel.textColor = [UIColor colorWithRed:0x1f/255.0F green:0x28/255.0F blue:0x39/255.0F alpha:1];
		locationLabel.backgroundColor = [UIColor clearColor];
		locationLabel.font = [UIFont systemFontOfSize:14];
		
		genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 40, 14, 14)];
		
		[self addSubview:screenNameLabel];
		[self addSubview:locationLabel];
		[self addSubview:genderImageView];
		[screenNameLabel release];
		[locationLabel release];
		[genderImageView release];
		
	}
	return self;
}

- (void)layoutSubviews {
	detailsArrowimageView.frame = CGRectMake(0, 60, self.frame.size.width, 20);
	chevronImageView.frame = CGRectMake(self.frame.size.width - 11 - 8, (80 - 15) / 2, 11, 15);
}

- (void)setUser:(User *)_user {
	[super setUser:_user];
	screenNameLabel.text = _user.screenName;
	locationLabel.text = _user.location;
	CGRect frame = locationLabel.frame;
	if (_user.gender == GenderUnknow) {
		frame.origin.x = 70;
		genderImageView.hidden = YES;
	}
	else {
		frame.origin.x = 88;
		genderImageView.hidden = NO;
		if (_user.gender == GenderMale) {
			genderImageView.image = imgMale;
		}
		else {
			genderImageView.image = imgFemale;
		}

	}
	locationLabel.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
 */


- (void)dealloc {
	[imgMale release];
	[imgFemale release];
    [super dealloc];
}


@end
