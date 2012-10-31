//
//  TweetDocument.m
//  TweetLayerDemo
//
//  Created by junmin liu on 12-10-17.
//  Copyright (c) 2012年 openlab Inc. All rights reserved.
//

#import "TweetDocument.h"


static inline CTTextAlignment CTTextAlignmentFromNSTextAlignment(UITextAlignment alignment) {
	switch (alignment) {
		case NSTextAlignmentLeft:
            return kCTLeftTextAlignment;
		case NSTextAlignmentCenter:
            return kCTCenterTextAlignment;
		case NSTextAlignmentRight:
            return kCTRightTextAlignment;
		default: return kCTNaturalTextAlignment;
	}
}

static inline CTLineBreakMode CTLineBreakModeFromNSLineBreakMode(NSLineBreakMode lineBreakMode) {
	switch (lineBreakMode) {
		case NSLineBreakByWordWrapping:
            return kCTLineBreakByWordWrapping;
		case NSLineBreakByCharWrapping:
            return kCTLineBreakByCharWrapping;
        case NSLineBreakByClipping:
            return kCTLineBreakByClipping;
        case NSLineBreakByTruncatingHead:
            return kCTLineBreakByTruncatingHead;
        case NSLineBreakByTruncatingTail:
            return kCTLineBreakByTruncatingTail;
        case NSLineBreakByTruncatingMiddle:
            return kCTLineBreakByTruncatingMiddle;
		default: return 0;
	}
}


@implementation TweetDocument
@synthesize tweet = _tweet;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize linkColor = _linkColor;
@synthesize linkPrefixColor = _linkPrefixColor;
@synthesize activeLinkColor = _activeLinkColor;
@synthesize activeLinkBackgroundColor = _activeLinkBackgroundColor;
@synthesize activeLinkBackgroundCornerRadius = _activeLinkBackgroundCornerRadius;


- (id)initWithTweet:(NSString *)tweet {
    self = [super init];
    if (self) {
        _links = [[NSMutableArray array] retain];
        self.font = [UIFont fontWithName:@"Georgia" size:18];
        self.textColor = [UIColor colorWithRed:55/255.f green:55/255.f blue:55/255.f alpha:1.0f];
        self.linkColor = [UIColor colorWithRed:36/255.f green:119/255.f blue:179/255.f alpha:1.0f];
        self.linkPrefixColor = [UIColor colorWithRed:138/255.f green:191/255.f blue:229/255.f alpha:1.0f];
        self.activeLinkColor = nil;
        self.activeLinkBackgroundColor = [UIColor colorWithRed:222/255.f green:235/255.f blue:244/255.f alpha:1.0f];
        self.activeLinkBackgroundCornerRadius = 2.0f;
        
        self.tweet = tweet;
    }
    return self;
}

+ (TweetDocument *)documentWithTweet:(NSString *)tweet {
    return [[[TweetDocument alloc]initWithTweet:tweet] autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (void)dealloc {
    [_attributedText release];
    [_links release];
    
    [_textColor release];
    [_linkColor release];
    [_linkPrefixColor release];
    [_activeLinkColor release];
    [_activeLinkBackgroundColor release];
    
    [_font release];
    
    if (_framesetter)
        CFRelease(_framesetter);
    
    [super dealloc];
}

- (void)resetAttributedText {
    [_attributedText release];
    _attributedText = nil;
}

- (void)setTweet:(NSString *)tweet {
    if (![_tweet isEqualToString:tweet]) {
        [_tweet release];
        _tweet = [tweet copy];
        [self detectLinks];
        [self resetAttributedText];
    }
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        [_font release];
        _font = [font retain];
        [self resetAttributedText];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        [_textColor release];
        _textColor = [textColor retain];
        [self resetAttributedText];
    }
}

- (void)setLinkColor:(UIColor *)linkColor {
    if (_linkColor != linkColor) {
        [_linkColor release];
        _linkColor = [linkColor retain];
        [self resetAttributedText];
    }
}

- (NSMutableArray *)links {
    return _links;
}

- (void)addTweetLink:(TweetLink *)link {
    if (link.range.location >= self.tweet.length ||
        link.range.location + link.range.length > self.tweet.length) {
        return;
    }
    [self.links addObject:link];
    [_attributedText release];
    _attributedText = nil;
    [self setNeedsFramesetter];
}

- (void)addParagraphToAttributedText:(NSMutableAttributedString *)mutableAttributedString {
    CTTextAlignment textAlignment = CTTextAlignmentFromNSTextAlignment(NSTextAlignmentNatural);
    CTLineBreakMode lineBreakMode = CTLineBreakModeFromNSLineBreakMode(NSLineBreakByWordWrapping);
    
    CGFloat leading = self.font.lineHeight - self.font.ascender + self.font.descender;
    leading = 2.3;//13:2.3;16:2.8;18:2.1;24:3;
    CTParagraphStyleSetting settings[] =
	{
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &leading},
		{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment },
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode  }
	};
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));
    [mutableAttributedString addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:NSMakeRange(0, mutableAttributedString.length)];
	CFRelease(paragraphStyle);
}

- (NSAttributedString *)attributedText {
    if (!_attributedText && self.tweet) {
        NSMutableAttributedString *mutableAttributedString = [[[NSMutableAttributedString alloc] initWithString:self.tweet] autorelease];
        
        CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)font range:NSMakeRange(0, mutableAttributedString.length)];
        CFRelease(font);
        
        if (self.textColor) {
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[self.textColor CGColor] range:NSMakeRange(0, mutableAttributedString.length)];
        }
        
        [self addParagraphToAttributedText:mutableAttributedString];
        
        for (TweetLink *link in _links) {
            [self addTweetLink:link toAttributedText:mutableAttributedString];
        }
        
        _attributedText = [mutableAttributedString copy];
    }
    return _attributedText;
}

- (void)addTweetLink:(TweetLink *)link toAttributedText:(NSMutableAttributedString *)attributedString {
    
    NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary:link.linkAttributes];
    if (self.linkColor) {
        [allAttributes setValue:(id)[self.linkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
    }
    [attributedString addAttributes:allAttributes range:link.range];
    
    if (self.linkPrefixColor) {
        if (link.linkType == TweetLinkTypeUser) {
            if ([link.text hasPrefix:@"@"]) {
                [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[self.linkPrefixColor CGColor] range:NSMakeRange(link.range.location, 1)];
            }
        }
        else if (link.linkType == TweetLinkTypeHash) {
            if ([link.text hasPrefix:@"#"]) {
                [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[self.linkPrefixColor CGColor] range:NSMakeRange(link.range.location, 1)];
            }
            if ([link.text hasSuffix:@"#"]) { // Twitter and Weibo are different.
                [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[self.linkPrefixColor CGColor] range:NSMakeRange(link.range.location + link.range.length - 1, 1)];
            }
        }
    }
}

- (void)detectLinks
{
	[_links removeAllObjects];
	if (![[self tweet] length])
	{
		return;
	}
	
    //[a-zA-Z0-9%_.+\\-]+@[a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6}|@[a-zA-Z0-9_\\u4e00-\\u9fa5]+|#[^#]+#|https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?
    
    NSString *emailReg = @"([a-zA-Z0-9%_.+\\-]+@[a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})";
    NSString *usernameReg = @"(@[a-zA-Z0-9_\\-\\u4e00-\\u9fa5]+)";
    NSString *hashtagReg = @"(#[^#]+#)";
    //@"(#[a-zA-Z0-9_-]+)", // hash tags for twitter
    NSString *urlReg = @"(https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)";
    
    
    NSString *expression = [NSString stringWithFormat:@"%@|%@|%@|%@", emailReg, usernameReg, hashtagReg, urlReg];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:[self tweet]
                                      options:0
                                        range:NSMakeRange(0, [[self tweet] length])];
    
    NSRegularExpression *mailRegex = [NSRegularExpression regularExpressionWithPattern:emailReg
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
    
    NSString *matchedString = nil;
    for (NSTextCheckingResult *match in matches)
    {
        matchedString = [[[self tweet] substringWithRange:[match range]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        TweetLink *link = nil;
        if ([matchedString hasPrefix:@"@"]) // usernames
        {
            NSString *username = [matchedString	substringFromIndex:1];
            link = [TweetLink tweetLinkWithUrl:username withText:matchedString withLinkType:TweetLinkTypeUser withRange:[match range]];
        }
        else if ([mailRegex numberOfMatchesInString:matchedString options:0 range:NSMakeRange(0, [matchedString length])] > 0) { //email
            link = [TweetLink tweetLinkWithUrl:matchedString withText:matchedString withLinkType:TweetLinkTypeEmail withRange:[match range]];
        }
        else if ([matchedString hasPrefix:@"#"]) // hash tag
        {
            NSString *searchTerm;
            if ([matchedString hasSuffix:@"#"]) {
                searchTerm = [matchedString substringWithRange:NSMakeRange(1, matchedString.length - 2)];
            }
            else {
                searchTerm = [matchedString substringFromIndex:1];
            }
            
            link = [TweetLink tweetLinkWithUrl:searchTerm withText:matchedString withLinkType:TweetLinkTypeHash withRange:[match range]];
        }
        else {
            link = [TweetLink tweetLinkWithUrl:matchedString withText:matchedString withLinkType:TweetLinkTypeURL withRange:[match range]];
        }
        
        if (link) {
            [_links addObject:link];
        }
    }
}




- (void)setNeedsFramesetter {
    _needsFramesetter = YES;
}

- (CTFramesetterRef)framesetter {
    if (_needsFramesetter) {
        if (_framesetter)
            CFRelease(_framesetter);
        
        self.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
        _needsFramesetter = NO;
    }
    
    return _framesetter;
}

- (CGSize)textSizeForWidth:(CGFloat)width {
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(self.framesetter, CFRangeMake(0, [self.attributedText length]), NULL, CGSizeMake(width, 99999), NULL);
    return CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect textRect = bounds;
    
    CGSize textSize = [self textSizeForWidth:bounds.size.width];
    
    if (textSize.height < textRect.size.height) {
        textRect.size.height = textSize.height;
    }
    
    return textRect;
}


- (NSMutableArray *)getLinkRects:(TweetLink *)link bounds:(CGRect)bounds {
    NSMutableArray *rects = [NSMutableArray array];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bounds);
    CFRange textRange = CFRangeMake(0, [self.attributedText length]);
    CTFrameRef frame = CTFramesetterCreateFrame(self.framesetter, textRange, path, NULL);
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    NSInteger numberOfLines = lines.count;
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return rects;
    }
    
    
    CGPoint origins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CFIndex lineIndex = 0;
    for (id lineObj in lines) {
        CTLineRef line = (CTLineRef)lineObj;
        CGPoint origin = origins[lineIndex];
        CGRect lineBounds = CGRectZero;
        CGFloat ascent, descent, leading;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        lineBounds.size.width = width;
        lineBounds.size.height = ascent + fabsf(descent) + leading;
        lineBounds.origin.x = origin.x;
        lineBounds.origin.y = bounds.origin.y + bounds.size.height - origin.y;
        
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        
        for (id glyphRun in runs) {
            CTRunRef run = (CTRunRef) glyphRun;
            CFRange runRange = CTRunGetStringRange(run);
            if ((((runRange.location >= [link range].location) && (runRange.location < [link range].location + [link range].length)) &&
                 ((runRange.location + runRange.length) <= ([link range].location + [link range].length)))) {
                CGRect runBounds = CGRectZero;
                CGFloat runAscent, runDescent, runLeading;
                runBounds.size.width = CTRunGetTypographicBounds((CTRunRef)glyphRun, CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading);
                runBounds.size.height = lineBounds.size.height;
                CGFloat xOffset = CTLineGetOffsetForStringIndex((CTLineRef)line, CTRunGetStringRange((CTRunRef)glyphRun).location, NULL);
                runBounds.origin.x = lineBounds.origin.x + bounds.origin.x + xOffset;
                runBounds.origin.y = lineBounds.origin.y - lineBounds.size.height;
                runBounds.origin.y += descent;
                if (CGRectGetWidth(runBounds) > CGRectGetWidth(lineBounds)) {
                    runBounds.size.width = CGRectGetWidth(lineBounds);
                }
                
                CGRect rect = CGRectInset(runBounds, -2.0f, -3.0f);
                [rects addObject:[NSValue valueWithCGRect:rect]];
            }
        }
        lineIndex++;
    }
    
    
    CFRelease(frame);
    CFRelease(path);
    
    return rects;
}

- (void)drawFramesetter:(CTFramesetterRef)framesetter textRange:(CFRange)textRange inRect:(CGRect)rect context:(CGContextRef)c {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, path, NULL);
    
    //[self drawBackground:frame inRect:rect context:c];
    
    CTFrameDraw(frame, c);
    
    CFRelease(frame);
    CFRelease(path);
}

- (void)drawTextInRect:(CGRect)rect textRect:(CGRect)textRect context:(CGContextRef)c {
    if (!self.attributedText) {
        return;
    }
    
    
    CFRange textRange = CFRangeMake(0, [self.attributedText length]);
    
    //CGContextTranslateCTM(c, 0.0f, rect.size.height - textRect.origin.y - textRect.size.height);
    //CGContextTranslateCTM(c, 0.0f, - textRect.origin.y);
    textRect.origin.y = rect.size.height - textRect.origin.y - textRect.size.height;
    
    [self drawFramesetter:self.framesetter textRange:textRange inRect:textRect context:c];
}

@end
