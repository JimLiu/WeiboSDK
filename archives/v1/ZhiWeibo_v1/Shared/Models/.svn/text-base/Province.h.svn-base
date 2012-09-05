//
//  Province.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-22.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface Province : NSObject {
	int provinceId;
	NSString *name;
	NSNumber *provinceKey;
	NSMutableDictionary *cities;
}

@property (nonatomic, assign) int provinceId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSNumber *provinceKey;
@property (nonatomic, retain) NSMutableDictionary *cities;

- (id)initWithXml:(CXMLElement *)node;

@end
