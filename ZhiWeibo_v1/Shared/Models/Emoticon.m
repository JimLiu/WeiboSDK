//
//  Emoticon.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "Emoticon.h"


@implementation Emoticon
@synthesize phrase, delays, imageUrls;
@synthesize type;
@synthesize width, height;
@synthesize gifUrl;
@synthesize defaultFrameIndex;

/*@property (nonatomic, assign) int width;
 @property (nonatomic, assign) int height;
 @property (nonatomic, copy) NSString *phrase;
 @property (nonatomic, copy) NSString *gifUrl;
 @property (nonatomic, copy) NSString *type;
 @property (nonatomic, retain) NSMutableArray *delays;
 @property (nonatomic, retain) NSMutableArray *imageUrls;
 @property (nonatomic, assign) int defaultFrameIndex;*/

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		width = [decoder decodeIntForKey:@"width"];
		height = [decoder decodeIntForKey:@"height"];
		defaultFrameIndex = [decoder decodeIntForKey:@"defaultFrameIndex"];
		phrase = [[decoder decodeObjectForKey:@"phrase"] retain];
		gifUrl = [[decoder decodeObjectForKey:@"gifUrl"] retain];
		type = [[decoder decodeObjectForKey:@"type"] retain];
		delays = [[decoder decodeObjectForKey:@"delays"] retain];
		imageUrls = [[decoder decodeObjectForKey:@"imageUrls"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:width forKey:@"width"];
	[encoder encodeInt:height forKey:@"height"];
	[encoder encodeInt:defaultFrameIndex forKey:@"defaultFrameIndex"];
	[encoder encodeObject:phrase forKey:@"phrase"];
	[encoder encodeObject:gifUrl forKey:@"gifUrl"];
	[encoder encodeObject:type forKey:@"type"];
	[encoder encodeObject:delays forKey:@"delays"];
	[encoder encodeObject:imageUrls forKey:@"imageUrls"];
}

- (id)initWithXml:(CXMLElement *)node {
	if (self = [super init]) {
		delays = [[NSMutableArray alloc]init];
		imageUrls = [[NSMutableArray alloc]init];
		phrase = [[node getStringValueForAttributeName:@"key" defaultValue:@""] copy];
		width = [node getIntValueForAttributeName:@"width" defaultValue:22];
		height = [node getIntValueForAttributeName:@"height" defaultValue:22];
		NSString *filename = [node getStringValueForAttributeName:@"filename" defaultValue:@""];
		gifUrl = [[NSString stringWithFormat:@"emoticons/%@", filename] copy];
		if ([node elementsForName:@"frames"].count == 1) {
			CXMLElement *framesNode = [[node elementsForName:@"frames"]objectAtIndex:0];
			int i = 0;
			for (CXMLElement *frameNode in [framesNode elementsForName:@"frame"]) {
				int delay = [frameNode getIntValueForAttributeName:@"delay" defaultValue:0];
				if (delay == 0) {
					delay = 10;
				}
				NSString* pngFilename = [filename stringByReplacingOccurrencesOfString:@".gif" 
																			withString:[NSString stringWithFormat:@"%d.png", i]];
				[delays addObject:[NSNumber numberWithInt:delay]];
				[imageUrls addObject:[NSString stringWithFormat:@"bundle://emoticons/%@", pngFilename]];
				i++;
			}
		}
		
	}
	return self;
}

- (id)initWithPhrase:(NSString *)_phrase
			filename:(NSString *)_filename
				type:(NSString *)_type
			   width:(int)_width
			  height:(int)_height
   defaultFrameIndex:(int)_defaultFrameIndex
			  delays:(NSArray*)_delays {
	if (self = [super init]) {
		delays = [[NSMutableArray alloc]init];
		imageUrls = [[NSMutableArray alloc]init];
		phrase = [_phrase copy];
		type = [_type copy];
		width = _width;
		height = _height;
		defaultFrameIndex = _defaultFrameIndex;
		gifUrl = [[NSString stringWithFormat:@"emoticons/%@", _filename] copy];	
		int i = 0;
		for (NSNumber *delayNumber in _delays) {
			int delay = [delayNumber intValue];
			if (delay == 0) {
				delay = 10;
			}
			NSString* pngFilename = [_filename stringByReplacingOccurrencesOfString:@".gif" 
																		 withString:[NSString stringWithFormat:@"%d.png", i]];
			[delays addObject:[NSNumber numberWithInt:delay]];
			[imageUrls addObject:[NSString stringWithFormat:@"bundle://emoticons/%@", pngFilename]];
			i++;
		}
	}
	return self;
}

- (UIImage *)defaultFrameImage {
	NSString* pngFilename = [gifUrl stringByReplacingOccurrencesOfString:@".gif" 
																 withString:[NSString stringWithFormat:@"%d.png", defaultFrameIndex]];
	return [UIImage imageNamed:pngFilename];
}

- (void)dealloc {
	[phrase release];
	[gifUrl release];
	[type release];
	[delays release];
	[imageUrls release];
	[super dealloc];
}


@end
