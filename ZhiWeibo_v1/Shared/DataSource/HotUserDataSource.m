//
//  HotUserDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotUserDataSource.h"


@implementation HotUserDataSource

- (void)loadUsersByCategory:(NSString *)_categroy {
	if (weiboClient) { 
		weiboClient.delegate = nil;
		[weiboClient release];
		weiboClient = nil;
	}
	[users removeAllObjects];
	isRestored = NO;
	[loadCell.spinner startAnimating];
	[tableView reloadData];
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(usersDidReceive:obj:)];
	[weiboClient getHotUserByCategory:_categroy];
}

- (void)usersDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		weiboClient.delegate = nil;
		[weiboClient release];
		weiboClient = nil;
        return;
    }

	NSArray *ary = (NSArray*)obj;
  
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		User* user = [User userWithJsonDictionary:[ary objectAtIndex:i]];
		[users addObject:user];
	}
	
	
	isRestored = YES;
	
	[tableView reloadData];
	weiboClient.delegate = nil;
	[weiboClient release];
	weiboClient = nil;
}

@end
