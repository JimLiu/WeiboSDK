//
//  GlobalCore.h
//  Weibo
//
//  Created by junmin liu on 10-9-29.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
///////////////////////////////////////////////////////////////////////////////////////////////////
// Safe releases

#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define IS_MASK_SET(value, flag)  (((value) & (flag)) == (flag))

/**
 * Borrowed from Apple's AvailabiltyInternal.h header. There's no reason why we shouldn't be
 * able to use this macro, as it's a gcc-supported flag.
 * Here's what we based it off of.
 * __AVAILABILITY_INTERNAL_DEPRECATED         __attribute__((deprecated))
 */
#define __DEPRECATED_METHOD __attribute__((deprecated))

///////////////////////////////////////////////////////////////////////////////////////////////////
// Errors

#define ERROR_DOMAIN @"weibo.net"

#define EC_INVALID_IMAGE 101


/**
 * Creates a mutable array which does not retain references to the objects it contains.
 *
 * Typically used with arrays of delegates.
 */
NSMutableArray* CreateNonRetainingArray();

/**
 * Creates a mutable dictionary which does not retain references to the values it contains.
 *
 * Typically used with dictionaries of delegates.
 */
NSMutableDictionary* CreateNonRetainingDictionary();


/**
 * Tests if an object is a string which is not empty.
 */
BOOL IsStringWithAnyText(id object);

CGRect ApplicationFrame(UIInterfaceOrientation interfaceOrientation);

time_t convertTimeStamp(NSString *stringTime);

#pragma mark -
#pragma mark Path


/**
 * @return YES if the URL begins with "bundle://"
 */
BOOL IsBundleURL(NSString* URL);

/**
 * @return YES if the URL begins with "documents://"
 */
BOOL IsDocumentsURL(NSString* URL);

/**
 * @return The main bundle path concatenated with the given relative path.
 */
NSString* PathForBundleResource(NSString* relativePath);

/**
 * @return The documents path concatenated with the given relative path.
 */
NSString* PathForDocumentsResource(NSString* relativePath);


#pragma mark -
#pragma mark Rects

/**
 * @return a rectangle with dx and dy subtracted from the width and height, respectively.
 *
 * Example result: CGRectMake(x, y, w - dx, h - dy)
 */
CGRect RectContract(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return a rectangle whose origin has been offset by dx, dy, and whose size has been
 * contracted by dx, dy.
 *
 * Example result: CGRectMake(x + dx, y + dy, w - dx, h - dy)
 */
CGRect RectShift(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return a rectangle with the given insets.
 *
 * Example result: CGRectMake(x + left, y + top, w - (left + right), h - (top + bottom))
 */
CGRect RectInset(CGRect rect, UIEdgeInsets insets);

