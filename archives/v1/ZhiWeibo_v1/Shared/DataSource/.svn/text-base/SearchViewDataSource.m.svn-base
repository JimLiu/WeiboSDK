//
//  SearchViewDataSource.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewDataSource.h"
#import "SearchCellView.h"
#import "TrendNowCellView.h"


@implementation SearchViewDataSource
@synthesize searchViewDelegate;
@synthesize tableView;

- (id)initWithTableView:(UITableView *)_tableView {
	if (self = [super init]) {
		tableView = [_tableView retain];
		tableView.delegate = self;
		tableView.dataSource = self;
		weiboClient = nil;
		trends = [[NSMutableArray alloc]init];
		trendNowCell = [[TrendNowCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	}
	return self;
}

- (void)setTableView:(UITableView *)_tableView {
	if (tableView != _tableView) {
		[tableView release];
		tableView = [_tableView retain];
		tableView.dataSource = self;
		tableView.delegate = self;
		[tableView reloadData];
	}
}

- (void)stopLoading {
	weiboClient.delegate = nil;
	[weiboClient release];
	weiboClient = nil;
}

- (void)dealloc {
	[self stopLoading];
	[trendNowCell release];
	[tableView release];
	[trends release];
	[super dealloc];
}


- (void)loadRecent {
	[trendNowCell loadHotStatues];
	if (weiboClient) {
		[self stopLoading];
	}
	if ([date isKindOfClass:[NSDate class]]) {
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateFormat:@"YYYY-MM-DD"];
		NSString *nowDate = [formatter stringFromDate:[NSDate date]];
		NSString *usedDate = [formatter stringFromDate:date];
		if ([nowDate isEqualToString:usedDate]) {
			return;
		}
	}
	[trends removeAllObjects];
	[tableView reloadData];
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   action:@selector(trendsDidReceive:obj:)];
	[weiboClient getPublicTrendsDaily];
}

- (void)trendsDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	if (sender.hasError) {
		NSLog(@"usersDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        if (sender.statusCode == 401) {
            ZhiWeiboAppDelegate *appDelegate = [ZhiWeiboAppDelegate getAppDelegate];
            [appDelegate openAuthenticateView];
        }
        [sender alert];
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
		[self stopLoading];
        return;
    }
	
	NSDictionary *dic = (NSDictionary*)obj;
	NSDictionary *dicT = [dic objectForKey:@"trends"];
	NSArray *ary1 = [dicT allKeys];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-DD"];
	NSDate *dateFromString = dateFromString = [dateFormatter dateFromString:[ary1 objectAtIndex:0]];
	[dateFormatter release];
	if ([dateFromString isKindOfClass:[NSDate class]]) {
		[date release];
		date = [dateFromString retain];
	}
	//NSLog(@"%@",date);
	
	NSArray *ary = [dicT objectForKey:[ary1 objectAtIndex:0]];
	if (!ary || ![ary isKindOfClass:[NSArray class]]) {
		[self stopLoading];
		return;
	}
	
	for (int i = 0; i < [ary count]; i++) {
		NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic1 isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		NSString *trend = [dic1 objectForKey:@"query"];
		[trends addObject:trend];
	}
	[tableView reloadData];
	[self stopLoading];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 2) {
		return trends.count>0?trends.count + 1 : 2;
	}
	else {
		return 1;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 2 && indexPath.row == 0) {
		return 118;
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		static NSString *cellName = @"SearchCellView";
		SearchCellView *c = (SearchCellView*)[_tableView dequeueReusableCellWithIdentifier:cellName];
		if (!c) {
			c = [[[SearchCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
		}
		return c;
	}
	else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			if (!trendNowCell) {
				trendNowCell = [[TrendNowCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
			}
			return trendNowCell;
		}
		else {
			if (trends.count > 0 && indexPath.row != 0) {
				static NSString *cellName = @"TrendCell";
				UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellName];
				if (!cell) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
				}
				cell.textLabel.text = [NSString stringWithFormat:@"%@",[trends objectAtIndex:indexPath.row - 1]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				return cell;
			}
			else {
				static NSString *cellName = @"LoadCell";
				UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellName];
				if (!cell) {
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
					UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
					[loading startAnimating];
					loading.center = cell.center;
					[cell.contentView addSubview:loading];
					[loading release];
				}
				return cell;
			}
		}
	}
	static NSString *cellName = @"SearchCell";
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellName];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
	}
	if (indexPath.section == 1) {
		cell.textLabel.text = @"推荐用户";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}		
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		[searchViewDelegate searchBarSelected];
	}
	else if (indexPath.section == 1) {
		[searchViewDelegate suggestionsSelected];
		[_tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			
		}
		else if(indexPath.row < trends.count){
			[searchViewDelegate trendSelected:[trends objectAtIndex:indexPath.row - 1]];
			[_tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}
}

@end
