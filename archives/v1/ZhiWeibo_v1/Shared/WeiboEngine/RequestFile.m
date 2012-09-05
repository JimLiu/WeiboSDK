//
//  RequestFile.m
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "RequestFile.h"


@implementation RequestFile
@synthesize filename, data, contentType, key;

- (id)initWithJpegData:(NSData *)_data forKey:(NSString *)_key {
    self = [super init];
    if (self) {
        self.data = _data;
        self.filename = @"myphoto.jpg";
        self.contentType = @"image/jpeg";
        self.key = _key;
    }
    return self;
}

- (void)dealloc {
    [filename release];
    [data release];
    [contentType release];
    [key release];
    [super dealloc];
}
@end
