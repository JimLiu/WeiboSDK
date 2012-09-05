#import <Foundation/Foundation.h>
#import "OAuthEngine.h"
#import "OAToken.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"

#define API_FORMAT @"json"
#define API_DOMAIN	@"api.t.sina.com.cn"

extern NSString *TWITTERFON_FORM_BOUNDARY;

@interface URLConnection : NSObject
{
	id                  delegate;
    NSString*           requestURL;
	NSURLConnection*    connection;
	NSMutableData*      buf;
    int                 statusCode;
    BOOL                needAuth;
	OAuthEngine*		_engine;
}

@property (nonatomic, readonly) NSMutableData* buf;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, copy) NSString* requestURL;

- (id)initWithDelegate:(id)delegate engine:(OAuthEngine *)__engine;
- (void)get:(NSString*)URL;
- (void)post:(NSString*)aURL body:(NSString*)body;
- (void)post:(NSString*)aURL data:(NSData*)data;
- (void)cancel;

- (void)URLConnectionDidFailWithError:(NSError*)error;
- (void)URLConnectionDidFinishLoading:(NSString*)content;

@end
