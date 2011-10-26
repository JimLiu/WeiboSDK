//
//  EmoticonPreviewView.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmoticonNode.h"

@interface EmoticonPreviewView : UIView {
	UIImage *backgroundImage;
	EmoticonNode *emoticonNode;
	UIImageView *previewImageView;
	UILabel *previewPhraseLabel;
}

@property (nonatomic, retain) EmoticonNode *emoticonNode;
@property (nonatomic, retain) UIImageView *previewImageView;
@property (nonatomic, retain) UILabel *previewPhraseLabel;

@end
