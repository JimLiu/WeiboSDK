//
//  GlobalCore.m
//  Weibo
//
//  Created by junmin liu on 10-9-29.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "GlobalCore.h"


@implementation GlobalCore

// No-ops for non-retaining objects.
static const void* RetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void ReleaseNoOp(CFAllocatorRef allocator, const void *value) { }


///////////////////////////////////////////////////////////////////////////////////////////////////
NSMutableArray* CreateNonRetainingArray() {
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = RetainNoOp;
	callbacks.release = ReleaseNoOp;
	return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSMutableDictionary* CreateNonRetainingDictionary() {
	CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
	CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
	callbacks.retain = RetainNoOp;
	callbacks.release = ReleaseNoOp;
	return (NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

BOOL IsStringWithAnyText(id object) {
	return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}


CGRect ApplicationFrame(UIInterfaceOrientation interfaceOrientation) {
	
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}
	bounds.origin.x = 0;
	return bounds;
}


time_t convertTimeStamp(NSString *stringTime) {
	// Convert timestamp string to UNIX time
    //
	time_t createdAt;
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		createdAt = mktime(&created);
	}
	return createdAt;
}

#pragma mark -
#pragma mark Path




///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL IsBundleURL(NSString* URL) {
	return [URL hasPrefix:@"bundle://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL IsDocumentsURL(NSString* URL) {
	return [URL hasPrefix:@"documents://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* PathForBundleResource(NSString* relativePath) {
	NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
	return [resourcePath stringByAppendingPathComponent:relativePath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* PathForDocumentsResource(NSString* relativePath) {
	static NSString* documentsPath = nil;
	if (!documentsPath) {
		NSArray* dirs = NSSearchPathForDirectoriesInDomains(
															NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [[dirs objectAtIndex:0] retain];
	}
	return [documentsPath stringByAppendingPathComponent:relativePath];
}


#pragma mark -
#pragma mark Rects


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect RectContract(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect RectShift(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectOffset(RectContract(rect, dx, dy), dx, dy);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect RectInset(CGRect rect, UIEdgeInsets insets) {
	return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
					  rect.size.width - (insets.left + insets.right),
					  rect.size.height - (insets.top + insets.bottom));
}


@end
