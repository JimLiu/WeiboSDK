//
//  Emoticon.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-18.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "CXMLElementAdditions.h"


@interface Emoticon : NSObject {
	NSString *phrase;
	NSString *gifUrl;
	NSString *type;
	NSMutableArray *delays;
	NSMutableArray *imageUrls;
	int width;
	int height;
	int defaultFrameIndex;
}

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, copy) NSString *phrase;
@property (nonatomic, copy) NSString *gifUrl;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSMutableArray *delays;
@property (nonatomic, retain) NSMutableArray *imageUrls;
@property (nonatomic, assign) int defaultFrameIndex;

- (id)initWithXml:(CXMLElement *)node;

- (id)initWithPhrase:(NSString *)_phrase
			filename:(NSString *)_filename
				type:(NSString *)_type
			   width:(int)_width
			  height:(int)_height
   defaultFrameIndex:(int)_defaultFrameIndex
			  delays:(NSArray*)_delays;

- (UIImage *)defaultFrameImage;

@end
