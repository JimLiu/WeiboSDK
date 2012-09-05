//
//  ConversationTableViewCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ConversationTableViewCell.h"


@implementation ConversationTableViewCell
@synthesize conversation;

- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle 
					 reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		profileImageRect = CGRectMake(31, 4, 52, 52);
	}
	return self;
}

- (void)dealloc {
	[conversation release];
	[super dealloc];
}


- (void)setConversation:(Conversation*)_conversation {
	if (conversation != _conversation) {
		[conversation release];
		conversation = [_conversation retain];
		self.user = conversation.user;
		[self setNeedsDisplay];
	}
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	
	static UIImage *cellBackgroundImage;
	static UIImage *cellSelectedBackgroundImage;
	
	if (!cellBackgroundImage) {
		cellBackgroundImage = [[UIImage imageNamed:@"cell-shadow.png"] retain];
	}
	if (!cellSelectedBackgroundImage) {
		cellSelectedBackgroundImage = [[UIImage imageNamed:@"TableBlueSelectionGradient.png"] retain];
	}
	
	if (highlighted) {
		[cellSelectedBackgroundImage drawInRect:rect];
	}
	[super drawContentView:rect highlighted:highlighted];

	UIColor* textColor;
	UIColor* timestampColor;
	UIColor* screenNameColor;
	
	if (highlighted) {
		textColor       = [UIColor whiteColor];
		timestampColor  = [UIColor whiteColor];
		screenNameColor = [UIColor whiteColor];
	}
	else {
		textColor       = [UIColor grayColor];
		timestampColor  = [UIColor colorWithRed:0x24/255.0F green:0x70/255.0F blue:0xd8/255.0F alpha:1];
		screenNameColor = [UIColor blackColor];
	}
	
	static UIFont *textFont;
	static UIFont *screenNameFont;
	static UIFont *timestampFont;
	if (!textFont) {
		textFont = [[UIFont systemFontOfSize:14] retain];
	}
	if (!screenNameFont) {
		screenNameFont = [[UIFont boldSystemFontOfSize:15] retain];
	}
	if (!timestampFont) {
		timestampFont = [[UIFont boldSystemFontOfSize:12] retain];
	}
	
	CGRect textRect = CGRectMake(90, 22, self.frame.size.width - 90 - 24, 36);
	[textColor set];
	[conversation.mostRecentMessage drawInRect:textRect  
									  withFont:textFont 
								 lineBreakMode:UILineBreakModeCharacterWrap];
	CGRect screenNameRect = CGRectMake(90, 4, 200, 20);
	[screenNameColor set];
	[conversation.user.screenName drawInRect:screenNameRect
									withFont:screenNameFont];
	
	CGRect timestampRect = CGRectMake(self.frame.size.width - 100 - 28, 7, 100, 20);
	[timestampColor set];
	[[conversation mostRecentDateString] drawInRect:timestampRect
											   withFont:timestampFont
										  lineBreakMode:UILineBreakModeWordWrap 
											  alignment:UITextAlignmentRight];
	
	CGRect unreadIndicatorRect = CGRectMake(9, 24, 13, 13);
	CGRect hasRepliedIndicatorRect = CGRectMake(11, 24, 9, 12);
	
	static UIImage *unreadIndicatorImage;
	static UIImage *hasRepliedIndicatorImage;
	if (!unreadIndicatorImage) {
		unreadIndicatorImage = [[UIImage imageNamed:@"unread-indicator.png"] retain];
	}
	if (!hasRepliedIndicatorImage) {
		hasRepliedIndicatorImage = [[UIImage imageNamed:@"mini-reply.png"] retain];
	}
	
	if (conversation.unread) {
		[unreadIndicatorImage drawInRect:unreadIndicatorRect];
	}
	else if (conversation.hasReplied) {
		[hasRepliedIndicatorImage drawInRect:hasRepliedIndicatorRect];
	}
	
	if (!highlighted) {
		//[cellBackgroundImage drawInRect:CGRectMake(0, rect.size.height - 20, rect.size.width, 20)];
		CGContextRef context = UIGraphicsGetCurrentContext();
		//CGContextClearRect(context, rect);
		CGContextSetLineWidth(context, 1);
		CGContextSetAllowsAntialiasing(context, false);
		CGContextSetRGBStrokeColor(context, 0xE0/255.F, 0xE0/255.F, 0xE0/255.F, 1.0);
		CGPoint points[2] = {
			{0, rect.size.height - 1}, {rect.size.width - 1, rect.size.height - 1}
		};
		CGContextStrokeLineSegments(context, points, 2);
	}
}


@end
