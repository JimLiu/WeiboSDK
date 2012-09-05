//
//  HotUserDataSource.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsFollowersDataSource.h"

@interface HotUserDataSource : FriendsFollowersDataSource {

}

- (void)loadUsersByCategory:(NSString *)_categroy;

@end
