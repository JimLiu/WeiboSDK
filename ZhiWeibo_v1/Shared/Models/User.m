#import "User.h"
#import "StringUtil.h"
#import "UserCache.h"
#import "MiniUser.h"
#import "FriendCache.h"
#import "Pinyin.h"

@implementation User

@synthesize userId;
@synthesize screenName;
@synthesize username;
@synthesize name;
@synthesize province;
@synthesize city;
@synthesize location;
@synthesize description;
@synthesize url;
@synthesize profileImageUrl;
@synthesize profileLargeImageUrl;
@synthesize domain;
@synthesize gender;
@synthesize followersCount;
@synthesize friendsCount;
@synthesize statusesCount;
@synthesize favoritesCount;
@synthesize createdAt;
@synthesize following;
@synthesize followedBy;
@synthesize verified;
@synthesize allowAllActMsg;
@synthesize geoEnabled;
@synthesize userKey;

- (id)initWithStatement:(Statement *)stmt {
	if (self = [super init]) {
		userId = [stmt getInt64:0];
		userKey = [[NSNumber alloc] initWithInt:userId];
		screenName = [[stmt getString:1] retain];
		name = [[stmt getString:2] retain];
		province = [[stmt getString:3]retain];
		city = [[stmt getString:4]retain];
		location = [[stmt getString:5]retain];
		description = [[stmt getString:6]retain];
		url = [[stmt getString:7] retain];
		profileImageUrl = [[stmt getString:8]retain];
		profileLargeImageUrl = [[profileImageUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"] retain];
		domain = [[stmt getString:9]retain];
		gender = [stmt getInt32:10];
		followersCount = [stmt getInt32:11];
		friendsCount = [stmt getInt32:12];
		statusesCount = [stmt getInt32:13];
		favoritesCount = [stmt getInt32:14];
		createdAt = [stmt getInt32:15];
		following = [stmt getInt32:16];
		verified = [stmt getInt32:17];
		allowAllActMsg = [stmt getInt32:18];
		geoEnabled = [stmt getInt32:19];
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        userId = [decoder decodeInt64ForKey:@"userId"];
		userKey = [[NSNumber alloc] initWithLongLong:userId];
		domain = [[decoder decodeObjectForKey:@"domain"]retain];
		username = [[decoder decodeObjectForKey:@"username"] retain];
		screenName = [[decoder decodeObjectForKey:@"screenName"] retain];
		name = [[decoder decodeObjectForKey:@"name"] retain];
		province = [[decoder decodeObjectForKey:@"province"]retain];
		city = [[decoder decodeObjectForKey:@"city"]retain];
		location = [[decoder decodeObjectForKey:@"location"]retain];
		description = [[decoder decodeObjectForKey:@"description"]retain];
		url = [[decoder decodeObjectForKey:@"url"] retain];
		profileImageUrl = [[decoder decodeObjectForKey:@"profileImageUrl"]retain];
		profileLargeImageUrl = [[profileImageUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"] retain];
		gender = [decoder decodeIntForKey:@"gender"];
		followersCount = [decoder decodeIntForKey:@"followersCount"];
		friendsCount = [decoder decodeIntForKey:@"friendsCount"];
		statusesCount = [decoder decodeIntForKey:@"statusesCount"];
		favoritesCount = [decoder decodeIntForKey:@"favoritesCount"];
		createdAt = [decoder decodeIntForKey:@"createdAt"];
		following = [decoder decodeBoolForKey:@"following"];
		followedBy = [decoder decodeBoolForKey:@"followedBy"];
		verified = [decoder decodeBoolForKey:@"verified"];
		allowAllActMsg = [decoder decodeBoolForKey:@"allowAllActMsg"];
		geoEnabled = [decoder decodeBoolForKey:@"geoEnabled"];
    }
    return self;
}   

- (id)initWithMiniUser:(MiniUser *)mUser {
    self = [super init];
    if (self != nil) {
        userId = mUser.userId;
		userKey = [mUser.userKey retain];
		screenName = [mUser.screenName retain];
		profileImageUrl = [mUser.profileImageUrl retain];
    }
    return self;
}   
 

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt64:userId forKey:@"userId"];
	[encoder encodeObject:username forKey:@"username"];
    [encoder encodeObject:screenName forKey:@"screenName"];
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:province forKey:@"province"];
    [encoder encodeObject:city forKey:@"city"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeObject:description forKey:@"description"];
    [encoder encodeObject:url forKey:@"url"];
    [encoder encodeObject:profileImageUrl forKey:@"profileImageUrl"];
    [encoder encodeObject:domain forKey:@"domain"];
    [encoder encodeInt:gender forKey:@"gender"];
    [encoder encodeInt:followersCount forKey:@"followersCount"];
    [encoder encodeInt:friendsCount forKey:@"friendsCount"];
    [encoder encodeInt:statusesCount forKey:@"statusesCount"];
    [encoder encodeInt:favoritesCount forKey:@"favoritesCount"];
    [encoder encodeInt:createdAt forKey:@"createdAt"];
    [encoder encodeBool:following forKey:@"following"];
	[encoder encodeBool:followedBy forKey:@"followedBy"];
    [encoder encodeBool:verified forKey:@"verified"];
    [encoder encodeBool:allowAllActMsg forKey:@"allowAllActMsg"];
    [encoder encodeBool:geoEnabled forKey:@"geoEnabled"];
}



- (User*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
	[userKey release];
	[username release];
    [screenName release];
    [name release];
	[province release];
	[city release];
    [location release];
    [description release];
    [url release];
    [profileImageUrl release];
	[domain release];
	[profileLargeImageUrl release];
    
    userId          = [[dic objectForKey:@"id"] longLongValue];
    userKey			= [[NSNumber alloc] initWithLongLong:userId];
	screenName      = [dic objectForKey:@"screen_name"];
    name            = [dic objectForKey:@"name"];
	
	int provinceId = [[dic objectForKey:@"province"] intValue];
	int cityId = [[dic objectForKey:@"city"] intValue];
	province		= provinceId > 0 ? [ProvinceDataSource getProvinceName:provinceId] : @"";
	city			= cityId > 0 ? [ProvinceDataSource getCityNameWithProvinceId:provinceId
															 withCityId:cityId] : @"";
	
	location        = [dic objectForKey:@"location"];
	description     = [dic objectForKey:@"description"];
	url             = [dic objectForKey:@"url"];
    profileImageUrl = [dic objectForKey:@"profile_image_url"];
	domain			= [dic objectForKey:@"domain"];
	
	NSString *genderChar = [dic objectForKey:@"gender"];
	if ([genderChar isEqualToString:@"m"]) {
		gender = GenderMale;
	}
	else if ([genderChar isEqualToString:@"f"]) {
		gender = GenderFemale;
	}
	else {
		gender = GenderUnknow;
	}

	
    followersCount  = ([dic objectForKey:@"followers_count"] == [NSNull null]) ? 0 : [[dic objectForKey:@"followers_count"] longValue];
    friendsCount    = ([dic objectForKey:@"friends_count"]   == [NSNull null]) ? 0 : [[dic objectForKey:@"friends_count"] longValue];
    statusesCount   = ([dic objectForKey:@"statuses_count"]  == [NSNull null]) ? 0 : [[dic objectForKey:@"statuses_count"] longValue];
    favoritesCount  = ([dic objectForKey:@"favourites_count"]  == [NSNull null]) ? 0 : [[dic objectForKey:@"favourites_count"] longValue];

    following       = ([dic objectForKey:@"following"]       == [NSNull null]) ? 0 : [[dic objectForKey:@"following"] boolValue];
    verified		= ([dic objectForKey:@"verified"]       == [NSNull null]) ? 0 : [[dic objectForKey:@"verified"] boolValue];
    allowAllActMsg	= ([dic objectForKey:@"allow_all_act_msg"]       == [NSNull null]) ? 0 : [[dic objectForKey:@"allow_all_act_msg"] boolValue];  
    geoEnabled		= ([dic objectForKey:@"geo_enabled"]   == [NSNull null]) ? 0 : [[dic objectForKey:@"geo_enabled"] boolValue];
    
	NSString *stringOfCreatedAt   = [dic objectForKey:@"created_at"];
    if ((id)stringOfCreatedAt == [NSNull null]) {
        stringOfCreatedAt = @"";
    }
	createdAt = convertTimeStamp(stringOfCreatedAt);
	
    if ((id)screenName == [NSNull null]) screenName = @"";
    if ((id)name == [NSNull null]) name = @"";
    if ((id)province == [NSNull null]) province = @"";
    if ((id)city == [NSNull null]) city = @"";
    if ((id)location == [NSNull null]) location = @"";
    if ((id)description == [NSNull null]) description = @"";
    if ((id)url == [NSNull null]) url = @"";
    if ((id)profileImageUrl == [NSNull null]) profileImageUrl = @"";
    if ((id)domain == [NSNull null]) domain = @"";
    
	username = [screenName copy];
    [screenName retain];
    [name retain];
	[province retain];
	[city retain];
    location = [[location unescapeHTML] retain];
    description = [[description unescapeHTML] retain];
    [url retain];
    [profileImageUrl retain];
	[domain retain];
	profileLargeImageUrl = [[profileImageUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"] copy];
}

+ (User*)userWithScreenName:(NSString *)_screenName {
	User *_user = [UserCache getUserByScreenName:_screenName];
	return _user;
}

+ (User*)userWithId:(long long)id
{
    User *user = [UserCache get:[NSNumber numberWithLongLong:id]];
    
    if (user) 
		return user;
    
	
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"SELECT * FROM users WHERE userId = ?"];
        [stmt retain];
    }
    
    [stmt bindInt64:id forIndex:1];
    int ret = [stmt step];
    if (ret != SQLITE_ROW) {
        [stmt reset];
        return nil;
    }
    
    user = [[[User alloc] initWithStatement:stmt] autorelease];
	
    [stmt reset];
    [UserCache cache:user];
	
	return user;
}

+ (User*)userWithJsonDictionary:(NSDictionary*)dic
{
	long long userId = [[dic objectForKey:@"id"] longLongValue];
    User *u = [UserCache get:[NSNumber numberWithLongLong:userId]];
    if (u) {
        [u updateWithJSonDictionary:dic];
        return u;
    }
    
    u = [[User alloc] initWithJsonDictionary:dic];
    [UserCache cache:u];
    return [u autorelease];
}

+ (User*)userWithMiniUser:(MiniUser *)mUser
{
	User *u = [[User alloc] initWithMiniUser:mUser];
	return [u autorelease];
}

- (void)dealloc
{
	[userKey release];
	[username release];
    [screenName release];
    [name release];
	[province release];
	[city release];
    [location release];
    [description release];
    [url release];
    [profileImageUrl release];
	[profileLargeImageUrl release];
	[domain release];
   	[super dealloc];
}



- (void)updateDB
{
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"REPLACE INTO users VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
        [stmt retain];
    }
    [stmt bindInt64:userId              forIndex:1];
    [stmt bindString:screenName               forIndex:2];
    [stmt bindString:name         forIndex:3];
    [stmt bindString:province         forIndex:4];
    [stmt bindString:city         forIndex:5];
    [stmt bindString:location           forIndex:6];
    [stmt bindString:description        forIndex:7];
    [stmt bindString:url                forIndex:8];
    [stmt bindString:profileImageUrl    forIndex:9];
	[stmt bindString:domain forIndex:10];
	[stmt bindInt32:gender forIndex:11];
    [stmt bindInt32:followersCount      forIndex:12];
	[stmt bindInt32:friendsCount forIndex:13];
	[stmt bindInt32:statusesCount forIndex:14];
	[stmt bindInt32:favoritesCount forIndex:15];
	[stmt bindInt32:createdAt forIndex:16];
	[stmt bindInt32:following forIndex:17];
	[stmt bindInt32:verified forIndex:18];
	[stmt bindInt32:allowAllActMsg forIndex:19];
    [stmt bindInt32:geoEnabled           forIndex:20];
	
	int step = [stmt step];
    if (step != SQLITE_DONE) {
		NSLog(@"update error username: %d.%@,%@,%@", userId, screenName, province, city);
        [DBConnection alert];
    }
    [stmt reset];
}

- (NSString*)pinyinOfScreenName {
	NSMutableString *pinyin = [NSMutableString string];;
	for (int i = 0; i < screenName.length; i++) {
		char t = pinyinFirstLetter([screenName characterAtIndex:i]);
		[pinyin appendFormat:@"%c",t];						 
	}
	return [NSString stringWithString:pinyin];
}

@end
