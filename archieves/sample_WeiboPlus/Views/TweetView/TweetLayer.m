//
//  TweetLayer.m
//  TweetLayerDemo
//
//  Created by junmin liu on 12-10-17.
//  Copyright (c) 2012年 openlab Inc. All rights reserved.
//

#import "TweetLayer.h"

@implementation TweetLayer
@synthesize document = _document;
@synthesize delegate = _delegate;
@synthesize activeLink = _activeLink;

- (id)init {
    self = [super init];
    if (self) {
        self.shouldRasterize = YES;
        self.wrapped = YES;
        self.rasterizationScale = [[UIScreen mainScreen] scale];
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.drawsAsynchronously = YES;
        
        _activeLinkBackgroundLayers = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc {
    [_document release];
    [_activeLink release];
    [_activeLinkBackgroundLayers release];
    
    [super dealloc];
}

- (void)setDocument:(TweetDocument *)document {
    if (document != _document) {
        [_document release];
        _document = [document retain];
        [self.document setNeedsFramesetter];
        self.string = self.document.attributedText;
    }
}


#pragma mark -

- (TweetLink *)linkAtCharacterIndex:(CFIndex)idx {
    for (TweetLink *link in self.document.links) {
        NSRange range = link.range;
        if ((CFIndex)range.location <= idx && idx <= (CFIndex)(range.location + range.length - 1)) {
            return link;
        }
    }
    
    return nil;
}

- (TweetLink *)linkAtPoint:(CGPoint)p {
    CFIndex idx = [self characterIndexAtPoint:p];
    return [self linkAtCharacterIndex:idx];
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    if (!self.document.attributedText) {
        return NSNotFound;
    }
    
    if (!CGRectContainsPoint(self.frame, point)) {
        return NSNotFound;
    }
    
    CGPoint p = point;
    CGRect textRect = [self.document textRectForBounds:self.frame];
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    p = CGPointMake(p.x, textRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame(self.document.framesetter, CFRangeMake(0, [self.document.attributedText length]), path, NULL);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        if (p.y > yMax) {
            break;
        }
        
        if (p.y >= yMin) {
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x - descent, p.y); // I am not sure whether we need to minus "descent", Jim
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                //NSLog(@"index: %d", idx);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

- (void)displayActiveLinkBackground {
    NSMutableArray *rects = [self.document getLinkRects:self.activeLink bounds:self.frame];
    for (NSValue *rectValue in rects) {
        CGRect rect = [rectValue CGRectValue];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.document.activeLinkBackgroundColor.CGColor;
        layer.frame = rect;
        layer.cornerRadius = self.document.activeLinkBackgroundCornerRadius;
        //[self addSublayer:layer];
        [self.superlayer insertSublayer:layer below:self];
        [_activeLinkBackgroundLayers addObject:layer];
    }
}

- (void)clearActiveLinkBackground {
    for (CALayer *layer in _activeLinkBackgroundLayers) {
        [layer removeFromSuperlayer];
    }
    [_activeLinkBackgroundLayers removeAllObjects];
}

- (void)setActiveLink:(TweetLink *)activeLink {
    if (_activeLink != activeLink) {
        [_activeLink release];
        _activeLink = [activeLink retain];
        if (self.activeLink) {
            [self displayActiveLinkBackground];
        }
        else {
            [self clearActiveLinkBackground];
        }
    }
}


#pragma mark - Touch Events

- (BOOL)touchesBeganWithLocation:(CGPoint)point {
    
    TweetLink *link = [self linkAtPoint:point];
    
    if (link) {
        self.activeLink = link;
        return YES;
    }
    return NO;
}

- (BOOL)touchesMovedWithLocation:(CGPoint)point {
    BOOL changed = NO;
    TweetLink *link = [self linkAtPoint:point];
    if (self.activeLink && self.activeLink != link) {
        self.activeLink = nil;
        changed =  YES;
    }
    if (link && self.activeLink != link) {
        self.activeLink = link;
        changed =  YES;
    }
    
    return changed;
}

- (BOOL)touchesEndedWithLocation:(CGPoint)point {
    TweetLink *link = [self linkAtPoint:point];
    if (self.activeLink && self.activeLink == link) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tweetLayer:didSelectLinkWithTweetLink:)]) {
            TweetLink *link = self.activeLink;
            [self.delegate tweetLayer:self didSelectLinkWithTweetLink:link];
        }
        self.activeLink = nil;
        return YES;
    }
    return NO;
}

- (BOOL)touchesCancelled {
    if (self.activeLink) {
        self.activeLink = nil;
        return YES;
    }
    return NO;
}


@end
