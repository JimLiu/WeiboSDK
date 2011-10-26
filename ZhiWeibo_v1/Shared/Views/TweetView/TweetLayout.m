//
//  TweetLayout.m
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-13.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "TweetLayout.h"
#import "RegexKitLite.h"
#import "UIFontAdditions.h"

@interface TweetLayout (Private)


- (void)layoutText:(TweetTextNode*)textNode;
- (void)layoutImage:(TweetImageBaseNode*)imageNode;

@end

static UIFont *defaultFont;
static UIFont *defaultLinkFont;
static UIColor *defaultTextColor;
static UIColor *defaultLinkTextColor;
static UIColor *defaultHighlightedTextColor;

@implementation TweetLayout
@synthesize frame, horizontalAlign, verticalAlign;
@synthesize font, linkFont;
@synthesize textColor, linkTextColor, highlightedTextColor;
@synthesize margin		  = _margin;
@synthesize highlighted;

- (id)initWithFrame:(CGRect)frame_ doc:(TweetDocument *)_doc {
	if (self = [super init]) {
		self.frame = frame_;
		doc = _doc;
		_nodes = [[NSMutableArray alloc] init];
		_frames = [[NSMutableArray alloc] init];
		_lineFrames = [[NSMutableArray alloc] init];
		
		if (!defaultFont) {
			defaultFont = [[UIFont systemFontOfSize:15] retain];
		}
		if (!defaultLinkFont) {
			defaultLinkFont = [[UIFont boldSystemFontOfSize:15] retain];
		}
		if (!defaultTextColor) {
			defaultTextColor = [[UIColor blackColor] retain];
		}
		if (!defaultLinkTextColor) {
			defaultLinkTextColor = [[UIColor colorWithRed:0x23/255.0F green:0x6E/255.0F blue:0xD8/255.0F alpha:1] retain];
		}
		if (!defaultHighlightedTextColor) {
			defaultHighlightedTextColor = [[UIColor colorWithWhite:1 alpha:1]retain];
		}
		
		font = [defaultFont retain];
		linkFont = [defaultLinkFont retain];
		textColor = [defaultTextColor retain];
		linkTextColor = [defaultLinkTextColor retain];
		highlightedTextColor = [defaultHighlightedTextColor retain];
	}
	return self;
}

- (NSMutableArray *)nodes {
	return _nodes;
}

- (NSMutableArray *)frames {
	return _frames;
}

- (void)setHighlighted:(BOOL)value {
	if (highlighted != value) {
		highlighted = value;
		for (TweetNode *node in _nodes) {
			node.highlighted = highlighted;
		}
	}
}

- (void)setFrame:(CGRect)frame_ {
	_width = frame_.size.width;
	_currentHeight = 0;
	_height = 0;
	_frame = frame_;
	[self setNeedsLayout];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font_ {
	if (font != font_) {
		
		for (TweetNode *node in _nodes) {
			if ([node isKindOfClass:[TweetTextNode class]]) {
				TweetTextNode *textNode = (TweetTextNode *)node;
				if (textNode.font == font) {
					textNode.font = font_;
				}
			}
		}
		
		[font release];
		font = [font_ retain];
		[self setNeedsLayout];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLinkFont:(UIFont*)font_ {
	if (linkFont != font_) {
		
		for (TweetNode *node in _nodes) {
			if ([node isKindOfClass:[TweetLinkNode class]]) {
				TweetLinkNode *textNode = (TweetLinkNode *)node;
				if (textNode.font != linkFont) {
					textNode.font = font_;
				}
			}
		}
		
		[linkFont release];
		linkFont = [font_ retain];
		[self setNeedsLayout];
	}
}


- (void)setTextColor:(UIColor *)color_ {
	if (textColor != color_) {
		
		for (TweetNode *node in _nodes) {
			if ([node isKindOfClass:[TweetTextNode class]]) {
				TweetTextNode *textNode = (TweetTextNode *)node;
				if (textNode.textColor != textColor) {
					textNode.textColor = color_;
				}
			}
		}		
		
		[textColor release];
		textColor = [color_ retain];
	}
}

- (void)setLinkTextColor:(UIColor *)color_ {
	if (linkTextColor != color_) {
		
		for (TweetNode *node in _nodes) {
			if ([node isKindOfClass:[TweetLinkNode class]]) {
				TweetLinkNode *textNode = (TweetLinkNode *)node;
				if (textNode.textColor != linkTextColor) {
					textNode.textColor = color_;
				}
			}
		}		
		
		[linkTextColor release];
		linkTextColor = [color_ retain];
	}
}


- (void)setHighlightedTextColor:(UIColor *)color_ {
	if (highlightedTextColor != color_) {
		
		for (TweetNode *node in _nodes) {
			if ([node isKindOfClass:[TweetTextNode class]]) {
				TweetTextNode *textNode = (TweetTextNode *)node;
				if (textNode.highlightedTextColor != highlightedTextColor) {
					textNode.highlightedTextColor = color_;
				}
			}
		}		
		
		[highlightedTextColor release];
		highlightedTextColor = [color_ retain];
	}
}


- (void)setNeedsLayout {
	needsLayout = YES;
}

- (void)setNeedsDisplay {
	needsDisplay = YES;
	[doc setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
	needsDisplay = YES;
	[doc setNeedsDisplayInRect:rect];
}

- (void)layoutIfNeeded {
	if (needsLayout) {
		[self layout];
		needsLayout = NO;
	}
}

- (CGRect)frame {
	[self layoutIfNeeded];

	return CGRectMake(_frame.origin.x + _margin.left
					  , _frame.origin.y + _margin.top
					  , _frame.size.width + _margin.left + _margin.right
					  , _height + _margin.top + _margin.bottom);
}

- (CGFloat) actualWidth {
	[self layoutIfNeeded];
	return _actualWidth;
}

- (TweetTextNode *)addNodeForText:(NSString *)text_ {
	TweetTextNode *textNode = [[TweetTextNode alloc]initWithText:text_ layout:self];
	textNode.font = font;
	[self addNode:textNode];
	[textNode release];
	[self setNeedsLayout];
	return textNode;
}

- (TweetLinkNode *)addNodeForLink:(NSString *)text_ url:(NSString *)url_ {
	TweetLinkNode *textNode = [[TweetLinkNode alloc]initWithUrl:url_ text:text_ layout:self];
	[self addNode:textNode];
	textNode.font = linkFont;
	[textNode release];
	[self setNeedsLayout];
	return textNode;
}

- (TweetImageNode *)addNodeForImageUrl:(NSString *)imageUrl 
								 width:(CGFloat)width 
								height:(CGFloat)height {
	TweetImageNode *imageNode = [[TweetImageNode alloc]initWithImageUrl:imageUrl layout:self];
	imageNode.width = width;
	imageNode.height = height;
	imageNode.className = @"";
	[self addNode:imageNode];
	[imageNode release];
	[self setNeedsLayout];
	return imageNode;
}

- (TweetImageLinkNode *)addNodeForImageLink:(NSString *)url
								imageUrl:(NSString *)imageUrl 
								 width:(CGFloat)width 
								height:(CGFloat)height {
	TweetImageLinkNode *imageNode = [[TweetImageLinkNode alloc]initWithUrl:url imageUrl:imageUrl layout:self];
	imageNode.width = width;
	imageNode.height = height;
	imageNode.className = @"";
	[self addNode:imageNode];
	[imageNode release];
	[self setNeedsLayout];
	return imageNode;
}

- (void)reset {
	[_nodes removeAllObjects];
	[_frames removeAllObjects];
	_lastNode = nil;
	_rootNode = nil;
}

- (void)addNode:(TweetNode *)_node {
	if ([_node isKindOfClass:[TweetTextNode class]]) {
		TweetTextNode *textNode = (TweetTextNode *)_node;
		if (!textNode.font) {
			textNode.font = self.font;
		}
		if (!textNode.textColor) {
			textNode.textColor = [_node isKindOfClass:[TweetLinkNode class]] ? self.linkTextColor : self.textColor;
		}
		if (!textNode.highlightedTextColor) {
			textNode.highlightedTextColor = self.highlightedTextColor;
		}
	}
	[_nodes addObject:_node];
	if (!_rootNode) {
		_rootNode = _node;
	}
	if (!_lastNode) {
		_lastNode.nextSibling = _node;
	}
	else {
		_rootNode.nextSibling = _node;
	}
	
	_lastNode = nil;
	_lastNode = _node;
	[self setNeedsLayout];
}

- (void)performStep:(int)step {
	for (TweetFrame* tf in _frames) {
		if ([tf isKindOfClass:[TweetAnimationImageFrame class]]) {
			TweetAnimationImageFrame *imgFrame = (TweetAnimationImageFrame *)tf;
			[imgFrame performStep:step];
		}
	}
}

- (void)draw {
	[self layoutIfNeeded];
	needsDisplay = NO;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	//CGContextTranslateCTM(ctx, frame.origin.x, frame.origin.y);
	
	for (TweetFrame* tf in _frames) {
		if (tf.node.highlighted && tf.node.hideOnHighlighted) {
			continue;
		}
		[tf draw];
	}
	
	CGContextRestoreGState(ctx);
}

- (TweetFrame*)hitTest:(CGPoint)point {
	for (TweetFrame *tf in _frames) {
		if ([tf.node isKindOfClass:[TweetLinkNode class]] || [tf.node isKindOfClass:[TweetImageLinkNode class]]) {
			if (CGRectContainsPoint(tf.frame, point)) {
				return tf;		
			}
		}
	}
	return nil;
}


- (void)layout {
	[_frames removeAllObjects];
	[_lineFrames removeAllObjects];
	if (_width == 0) {
		return;
	}
	_x = 0;
	_currentHeight = 0;
	_height = 0;
	_lineWidth = 0;
	_lineHeight = 0;
	
	for (TweetNode *node in _nodes) {
		if ([node isKindOfClass:[TweetImageBaseNode class]]) {
			TweetImageBaseNode* imageNode = (TweetImageBaseNode*)node;
			[self layoutImage:imageNode];
		} 
		else if ([node isKindOfClass:[TweetTextNode class]]) {
			TweetTextNode* textNode = (TweetTextNode*)node;
			[self layoutText:textNode];
		}
	}
	needsLayout = NO;
}

- (void)addFrame:(TweetFrame *)tf width:(CGFloat)w {
	[_frames addObject:tf];
	
	if (horizontalAlign == LayoutHorizontalAlignRight)
	{
		for (TweetFrame *_tf in _lineFrames) {
			CGRect rect = _tf.frame;
			rect.origin.x -= w;
			_tf.frame = rect;
		}
	}
	else if (horizontalAlign == LayoutHorizontalAlignCenter) {
		if (_lineFrames.count == 0) {
			CGRect rect = tf.frame;
			rect.origin.x = (_width - w) / 2 + _frame.origin.x;
			tf.frame = rect;
		}
		else {
			CGRect rect;
			for (TweetFrame *_tf in _lineFrames) {
				rect = _tf.frame;
				rect.origin.x -= w / 2;
				_tf.frame = rect;
			}
			rect.origin.x += rect.size.width;
			tf.frame = rect;
		}
	}	
	[_lineFrames addObject:tf];
	
	if (_lineHeight) { // vertical align
		CGFloat top = _currentHeight + _frame.origin.y;
		for (TweetFrame *_tf in _lineFrames) {
			CGRect rect = _tf.frame;
			if (_tf.node.verticalAlign == LayoutVerticalAlignTop) {
				rect.origin.y = top;
			}
			else if (_tf.node.verticalAlign == LayoutVerticalAlignMiddle) {
				rect.origin.y = top + (_lineHeight - rect.size.height) / 2;
			}
			else {
				rect.origin.y = top + (_lineHeight - rect.size.height);
			}
		}
	}
	
}

- (void)addFrameForText:(NSString*)text
				   node:(TweetTextNode*)node 
				  width:(CGFloat)w 
				 height:(CGFloat)h {
	
	CGRect rect = CGRectMake(_x + _frame.origin.x, _currentHeight + _frame.origin.y, w, h);
	_x += w;
	if (horizontalAlign == LayoutHorizontalAlignRight) {
		rect.origin.x = _width - w + _frame.origin.x;
	}
	
	if (_currentHeight + h > _height) {
		_height = _currentHeight + h;
	}
	
	TweetTextFrame* ttf;
	if ([node isKindOfClass:[TweetLinkNode class]]) {
		ttf = [[[TweetLinkFrame alloc] initWithText:text node:(TweetLinkNode *)node frame:rect] autorelease];
	}
	else {
		ttf = [[[TweetTextFrame alloc] initWithText:text node:node frame:rect] autorelease];
	}	
	[self addFrame:ttf width:w];
}

- (void)addImageFrameForNode:(TweetImageBaseNode*)imageNode 
					   width:(CGFloat)imageWidth 
					  height:(CGFloat)imageHeight {
	CGRect rect = CGRectMake(_x + _frame.origin.x
							 , _currentHeight + _frame.origin.y
							 , imageWidth  + imageNode.margin.left + imageNode.margin.right
							 , imageHeight + imageNode.margin.top  + imageNode.margin.bottom);
	if (horizontalAlign == LayoutHorizontalAlignRight) {
		rect.origin.x = _width - rect.size.width + _frame.origin.x;
	}
	
	if (_currentHeight + rect.size.height > _height) {
		_height = _currentHeight + rect.size.height;
	}
	
	if ([imageNode isKindOfClass:[TweetImageLinkNode class]]) {
		TweetImageLinkFrame *tilf = [[TweetImageLinkFrame alloc] 
									  initWithNode:(TweetImageLinkNode*)imageNode frame:rect];
		[self addFrame:tilf width:rect.size.width];
		[tilf release];
	}
	else if ([imageNode isKindOfClass:[TweetImageNode class]]) {
		TweetImageFrame* tif = [[TweetImageFrame alloc] 
								  initWithNode:(TweetImageNode*)imageNode frame:rect];
		[self addFrame:tif width:rect.size.width];
		[tif release];
	}
	else if ([imageNode isKindOfClass:[TweetAnimationImageNode class]]) {
		TweetAnimationImageFrame* taif = [[TweetAnimationImageFrame alloc] 
										   initWithNode:(TweetAnimationImageNode*)imageNode 
										  frame:rect];
		[self addFrame:taif width:rect.size.width];
		[taif release];
	}
	
	_x += imageNode.margin.right + rect.size.width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)expandLineWidth:(CGFloat)width {
	_lineWidth += width;
	if (_lineWidth > _actualWidth) {
		_actualWidth = _lineWidth;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)inflateLineHeight:(CGFloat)height {
	if (height > _lineHeight) {
		_lineHeight = height;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)breakLine {
	if (_actualWidth < _lineWidth) {
		_actualWidth = _lineWidth;
	}
	_currentHeight += _lineHeight;
	_lineWidth = 0;
	_lineHeight = 0;
	_x = 0;
	[_lineFrames removeAllObjects];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutText:(TweetTextNode*)textNode {
	NSString* text = textNode.text;
	NSUInteger length = text.length;
	UIFont *_font = textNode.font;
	if (!textNode.nextSibling && textNode == _rootNode) {
		// This is the only node, so measure it all at once and move on
		CGSize textSize = [text sizeWithFont:_font
						   constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX)
							   lineBreakMode:UILineBreakModeWordWrap];
		[self addFrameForText:text node:textNode width:textSize.width
					   height:textSize.height];
		_currentHeight += textSize.height;
		_actualWidth = textSize.width;
		return;
	}
	
	NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	NSInteger stringIndex = 0;
	NSInteger lineStartIndex = 0;
	CGFloat frameWidth = 0;
	
	while (stringIndex < length) {
		// Search for the next whitespace character
		NSRange searchRange = NSMakeRange(stringIndex, length - stringIndex);
		
		NSRange spaceRange = [text rangeOfCharacterFromSet:whitespace options:0 range:searchRange];
		
		// Get the word prior to the whitespace
		NSRange wordRange = spaceRange.location != NSNotFound
		? NSMakeRange(searchRange.location, (spaceRange.location+1) - searchRange.location)
		: NSMakeRange(searchRange.location, length - searchRange.location);
		
		NSRange chineseCharRange = [text rangeOfRegex:@"[\\u4e00-\\u9fa5[\\p{Punct}&[^@]&[^#]]]"
											  inRange:wordRange];
		if (chineseCharRange.location != NSNotFound) {
			wordRange = NSMakeRange(searchRange.location, chineseCharRange.location + 1 - searchRange.location);
		}
		
		NSString* word = [text substringWithRange:wordRange];
		
		// If there is no width to constrain to, then just use an infinite width,
		// which will prevent any word wrapping
		CGFloat availWidth = _width ? _width : CGFLOAT_MAX;
		
		// Measure the word and check to see if it fits on the current line
		CGSize wordSize = [word sizeWithFont:_font];
		if (wordSize.width > _width) { // 如果单词宽度大于行宽
			for (NSInteger i = 0; i < word.length; ++i) { // 对单词按字符遍历
				NSString* c = [word substringWithRange:NSMakeRange(i, 1)]; //获取字符
				CGSize letterSize = [c sizeWithFont:_font]; // 字符尺寸
				
				// 如果已经遍历的字符够一行了就添加行和相应字符
				if (_lineWidth + letterSize.width > _width) { //如果 已占用行宽+字符宽度>行宽 
					NSRange lineRange = NSMakeRange(lineStartIndex, stringIndex - lineStartIndex); // 从行开始字符索引 到 当前字符索引
					if (lineRange.length) { // 如果存在字符
						NSString* line = [text substringWithRange:lineRange];  // 获取行字符串
						[self addFrameForText:line node:textNode width:frameWidth
									   height:_lineHeight ? _lineHeight : [_font LineHeight]]; // 把行字符串以及占用的位置记录
					}
					
					if (_lineWidth) { // 如果行宽被其他元素占用
						[self breakLine]; // 换行
					}
					
					lineStartIndex = lineRange.location + lineRange.length;  // 行开始字符索引后移行字符长度
					frameWidth = 0; //行文本占用宽度清零
				}
				
				frameWidth += letterSize.width;  //文本行宽 加上 字符宽度
				[self expandLineWidth:letterSize.width]; //更新行占用宽度
				[self inflateLineHeight:wordSize.height]; //更新行高度
				++stringIndex; // 字符索引加1
			} //单词遍历结束
			
			// 单词遍历结束，如果当前没换行字符不够一行，也添加行和相应字符
			NSRange lineRange = NSMakeRange(lineStartIndex, stringIndex - lineStartIndex);
			if (lineRange.length) {
				NSString* line = [text substringWithRange:lineRange];
				[self addFrameForText:line node:textNode width:frameWidth
							   height:_lineHeight ? _lineHeight : [_font LineHeight]];
				
				lineStartIndex = lineRange.location + lineRange.length;
				frameWidth = 0;
			}
		} 
		else { // 如果单词宽度小于行宽
			// 如果 单词宽度 + 已占用行宽 > 行宽
			if (_lineWidth + wordSize.width > _width) {
				// The word will be placed on the next line, so create a new frame for
				// the current line and mark it with a line break
				// 直接换行  
				NSRange lineRange = NSMakeRange(lineStartIndex, stringIndex - lineStartIndex);
				if (lineRange.length) {
					NSString* line = [text substringWithRange:lineRange];
					[self addFrameForText:line node:textNode width:frameWidth
								   height:_lineHeight ? _lineHeight : [_font LineHeight]];
				}
				
				if (_lineWidth) {
					[self breakLine];
				}
				lineStartIndex = lineRange.location + lineRange.length;
				frameWidth = 0;
			}
			
			// 如果在行首，并且后面已经没有了，那么直接计算出来剩余字符的尺寸，并输出
			if (!_lineWidth && textNode == _lastNode) {
				// We are at the start of a new line, and this is the last node, so we don't need to
				// keep measuring every word.  We can just measure all remaining text and create a new
				// frame for all of it.
				NSString* lines = [text substringWithRange:searchRange];
				CGSize linesSize = [lines sizeWithFont:_font
									 constrainedToSize:CGSizeMake(availWidth, CGFLOAT_MAX)
										 lineBreakMode:UILineBreakModeWordWrap];
				
				[self addFrameForText:lines node:textNode width:linesSize.width
							   height:linesSize.height];
				_currentHeight += linesSize.height;
				break;
			}
			
			// 文本行宽 加上当前单词 单词宽度
			frameWidth += wordSize.width;
			[self expandLineWidth:wordSize.width];
			[self inflateLineHeight:wordSize.height];
			
			// 字符索引位置后移单词长度
			stringIndex = wordRange.location + wordRange.length;
			// 如果已经到了末尾
			if (stringIndex >= length) {
				// The current word was at the very end of the string
				NSRange lineRange = NSMakeRange(lineStartIndex, (wordRange.location + wordRange.length)
												- lineStartIndex);
				NSString* line = !_lineWidth ? word : [text substringWithRange:lineRange];
				CGSize wordSize = [line sizeWithFont:_font];
				if (wordSize.width != frameWidth) {
					_lineWidth -= (frameWidth - wordSize.width);
					frameWidth = wordSize.width;
				}
				[self addFrameForText:line node:textNode width:frameWidth
							   height:[_font LineHeight]];
				frameWidth = 0;
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutImage:(TweetImageBaseNode*)imageNode {
	/*
	UIImage* image = imageNode.image;
	CGFloat imageWidth = imageNode.width ? imageNode.width : image.size.width;
	CGFloat imageHeight = imageNode.height ? imageNode.height : image.size.height;
	if (imageNode.width == 0 
		&& imageNode.height > 0 && image.size.height > 0) {
		imageWidth = imageWidth * imageNode.height / image.size.height;
	}
	if (imageNode.height == 0 
		&& imageNode.width > 0 && image.size.width > 0) {
		imageHeight = imageHeight * imageNode.width / image.size.width;
	}
	*/
	CGFloat imageWidth = imageNode.width;
	CGFloat imageHeight = imageNode.height;
	CGFloat contentWidth = imageWidth;
	CGFloat contentHeight = imageHeight;
	
	//_x += imageNode.margin.left;

	contentWidth += imageNode.margin.left + imageNode.margin.right;
	contentHeight += imageNode.margin.top + imageNode.margin.bottom;
	
	if (_lineWidth + contentWidth > _width) {
		if (_lineWidth) {
			// The image will be placed on the next line, so create a new frame for
			// the current line and mark it with a line break
			[self breakLine];
		} 
		//else {
		//	_width = contentWidth;
		//}
	}

	[self addImageFrameForNode:imageNode width:imageWidth height:imageHeight];
	[self expandLineWidth:contentWidth];
	[self inflateLineHeight:contentHeight];
}


- (NSString *)html {
	NSMutableString *result = [NSMutableString string];
	for (TweetNode *node in _nodes) {
		[result appendString:[node html]];
	}
	return result;
}


-(void)dealloc {
	[_nodes release];
	[_frames release];
	[_lineFrames release];
	[font release];
	[linkFont release];
	[linkTextColor release];
	[textColor release];
	[highlightedTextColor release];
	[super dealloc];
}


@end
