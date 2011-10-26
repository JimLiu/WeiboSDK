//
//  TweetCell.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-16.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetCell.h"
#import "TweetCellView.h"
#import "TweetSelectedCellBackgroundView.h"
#import "TweetCellBackgroundView.h"


@implementation TweetCell
@synthesize doc;
@synthesize enableSelected;
@synthesize tweetCellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		//UIColor	*bgColor = [UIColor colorWithRed:0xF5/255.0f green:0xF5/255.0f blue:0xF5/255.0f alpha:1];
		enableSelected = YES;
		TweetCellBackgroundView *bgView = [[TweetCellBackgroundView alloc] initWithFrame:CGRectZero];
		bgView.opaque = YES;
		bgView.backgroundColor = [UIColor whiteColor];
		self.backgroundView = bgView;
		[bgView release];
		
		if (enableSelected) {
			TweetSelectedCellBackgroundView *sView = [[TweetSelectedCellBackgroundView alloc]initWithFrame:CGRectZero];
			sView.opaque = YES;
			//sView.backgroundColor = bgColor;
			self.selectedBackgroundView = sView;
			[sView release];			
		}
		else {
			TweetCellBackgroundView *sView = [[TweetCellBackgroundView alloc]initWithFrame:CGRectZero];
			sView.opaque = YES;
			//sView.backgroundColor = bgColor;
			self.selectedBackgroundView = sView;
			[sView release];						
		}

		
		cellView = [[TweetCellView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:cellView];
    }
    return self;
}

- (void)dealloc
{
	doc.view = nil;
	[doc release];
	[cellView release];
	[highlightNode release];
    [super dealloc];
}    

- (void)update {
	CGRect frame = CGRectMake(0, 0, doc.width, doc.height);
    cellView.frame = frame;
	cellView.doc = doc;
	doc.view = cellView;
	[cellView setNeedsLayout];
	[cellView setNeedsDisplay];
	//[self setNeedsLayout];
	[self setNeedsDisplay];
}


- (void)setDoc:(TweetDocument *)_doc {
	if (doc != _doc) {
		[doc release];
		doc = [_doc retain];
		[self update];
	}
}

- (void)setSelected:(BOOL)selected {
	[self.backgroundView setNeedsDisplay];
	[super setSelected:selected];
	if (enableSelected) {
		doc.highlighted = selected;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	//NSLog(@"setSelected");
	[self.backgroundView setNeedsDisplay];
    [super setSelected:selected animated:animated];
	if (enableSelected) {
		doc.highlighted = selected;
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	//NSLog(@"setHighlighted");
	[self.backgroundView setNeedsDisplay];
	[super setHighlighted:highlighted];
	if (enableSelected) {
		doc.highlighted = highlighted;
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[self.backgroundView setNeedsDisplay];
    [super setHighlighted:highlighted animated:animated];
	if (enableSelected) {
		doc.highlighted = highlighted;
	}
}

- (void)setHighlightNode:(TweetNode*)node {
	if (node) {
		highlightNode.state = TweetNodeStateNormal;
		[highlightNode release];
		highlightNode = [node retain];
		highlightNode.state = TweetNodeStateHighlighted;
	}
	else {
		highlightNode.state = TweetNodeStateNormal;
		[highlightNode release];
		highlightNode = nil;
	}
	[doc setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	TweetFrame *_frame = [doc hitTest:point];
	//NSLog(@"%@",_frame);
	if ([_frame.node isKindOfClass:[TweetLinkNode class]] || [_frame.node isKindOfClass:[TweetImageLinkNode class]]) {
		[self setHighlightNode:_frame.node];
	}
	else {
		[super touchesBegan:touches withEvent:event];
	}

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	TweetFrame *_frame = [doc hitTest:point];
	if ([_frame.node isKindOfClass:[TweetLinkNode class]] || [_frame.node isKindOfClass:[TweetImageLinkNode class]]) {
		[self setHighlightNode:_frame.node];
		[super touchesCancelled:touches withEvent:event];
	}
	else {
		[self setHighlightNode:nil];
		[super touchesBegan:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (highlightNode) {
		[tweetCellDelegate processTweetNode:highlightNode];
		[self setHighlightNode:nil];
	}
	[super touchesEnded:touches withEvent:event];
	//_frame.node.state = TweetNodeStateNormal;
	//[tweetCellDelegate reloadData];
	//NSLog(@"%@ %@",_frame,touch);
	//NSLog(@"%@",_frame);
	//NSLog(@"%@",NSStringFromCGPoint(point));
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (highlightNode) {
		[self setHighlightNode:nil];
	}
	[super touchesCancelled:touches withEvent:event];
}

@end
