//
//  RequestFile.h
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestFile : NSObject {
    NSString *filename;
    NSString *contentType;
    NSString *key;
    NSData *data;    
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSData *data;

- (id)initWithJpegData:(NSData *)_data forKey:(NSString *)_key;

@end
