//
//  ConversationController.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
#import "DirectMessage.h"
#import "ConversationDataSource.h"
#import "HPGrowingTextView.h"
#import "DirectMessageDraft.h"
#import "EmoticonsPopupView.h"
#import "EmoticonPreviewView.h"

@protocol ConversationControllerDelegate

-(void)sendDirectMessage:(DirectMessageDraft*)_draft;

@end

@class WebViewController;
@interface ConversationController : UIViewController<HPGrowingTextViewDelegate,ConversationDataSourceDelegate> {
	UITableView *tableView;
	ConversationDataSource *dataSource;
	Conversation *conversation;
	
	WebViewController *webViewController;
	
	UIImageView *txtBackgrounView;
	HPGrowingTextView *txtView;
	EmoticonsPopupView *emoticonsPopupView;
	EmoticonPreviewView *emoticonPreviewView;
	
	NSRange textRange;
	
	BOOL keyboardShown;
	BOOL emotionViewShown;
	BOOL canResponseEmotion;
	
	id<ConversationControllerDelegate> conversationControllerDelegate;
	
	UIButton *btnEmotion;
	UIButton *btnKeyboard;
}

@property (nonatomic, retain) IBOutlet WebViewController *webViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) IBOutlet UIImageView *txtBackgrounView;
@property (nonatomic, assign) id<ConversationControllerDelegate> conversationControllerDelegate;
@property (nonatomic, assign) IBOutlet UIButton *btnEmotion;
@property (nonatomic, assign) IBOutlet UIButton *btnKeyboard;

- (IBAction)btnSendTouched:(id)sender;

- (IBAction)btnEmotionTouched:(id)sender;

- (IBAction)btnKeyboardTouched:(id)sender;

- (void)reloadDataSource;

- (void)initFrame;

@end
