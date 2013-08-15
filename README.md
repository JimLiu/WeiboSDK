WeiboSDK
=========
新浪微博SDK，基于[v2版API接口](http://open.weibo.com/ "新浪微博开放平台")，对认证和请求进行了简要封装，

备注: 需要 iOS 6.0＋，需要使用ARC

安装
------------

### 方法一：静态库引用

#### 添加依赖项

- 在你项目App的target设置, 找到 "Build Phases" 选项并打开 "Link Binary With Libraries":
- 点击 "+" 按钮，然后点击 "Add Other...", 浏览到WeiboSDK根目录的"build"目录，选择 "WeiboSDK.framework" 并添加到项目中
- 在你项目设置, 找到 "Build Settings" 选项，找到 "Other Linker Flags" 项，添加值 `-ObjC` 

#### 引用头文件

在需要使用WeiboSDK的代码中引用头文件。

```objective-c
#import <WeiboSDK/WeiboSDK.h>
```

### 方法二：代码引用

#### 添加项目文件

到将项目根目录下的"src"目录，将下面的 "WeiboSDK" 目录拷贝到项目中即可。

#### 引用头文件

在需要使用WeiboSDK的代码中引用头文件。

```objective-c
#import "WeiboSDK.h"
```

使用说明
----------
## 初始化Weibo对象实例

在使用前，要先初始化Weibo对象实例，设置您自己申请的AppKey和AppSecret

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// ...
    Weibo *weibo = [[Weibo alloc] initWithAppKey:@"您的AppKey" withAppSecret:@"您的AppSecret"];
    [Weibo setWeibo:weibo];
    // ...
    return YES;
}
```
## 通过微博SDK访问微博服务

### 登录认证相关

#### 判断是否登录

```objective-c
if (![Weibo.weibo isAuthenticated]) {
    // 没有登录
}
else {
    // 已经登录成功
}
```

#### 获取当前登录用户

```objective-c
WeiboAccount *account = [Weibo.weibo currentAccount];
User *user = account.user; // current user

```

#### 注销登录

```objective-c
[Weibo.weibo signout];
```


#### 登录

弹出登录界面登录，并对登录结果进行处理。

```objective-c
[Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
    if (!error) {
        NSLog(@"成功登录，登录名: %@", account.user.screenName);
    }
    else {
        NSLog(@"登录失败: %@", error);
    }
}];
```

### 微博相关

#### 查询关注用户的微博

通过queryTimeline系列方法可以去查询微博列表，根据参数可以返回不同结果，使用Block对返回结果进行处理

```objective-c
[Weibo.weibo queryTimeline:StatusTimelineFriends count:50 completed:^(NSMutableArray *statuses, NSError *error) {
    if (error) {
        NSLog(@"获取失败，error:%@", error);
    }
    else {
        NSLog(@"获取成功，微博条数:%d", self.statuses.count);
    }
}];
```


#### 发新微博
通过Weibo实例中的newStatus方法可以发表微博

不带附件发微博
```objective-c
[weibo newStatus:@"test weibo" pic:nil completed:^(Status *status, NSError *error) {
    if (error) {
        NSLog(@"failed to post:%@", error);
    }
    else {
        NSLog(@"success: %lld.%@", status.statusId, status.text);
    }
}];
```

带附件发微博
```objective-c
NSData *img = UIImagePNGRepresentation([UIImage imageNamed:@"Icon"]);
[weibo newStatus:@"test weibo with image" pic:img completed:^(Status *status, NSError *error) {
    if (error) {
        NSLog(@"failed to upload:%@", error);
    }
    else {
        StatusImage *statusImage = [status.images objectAtIndex:0];
        NSLog(@"success: %lld.%@.%@", status.statusId, status.text, statusImage.originalImageUrl);
    }
}];
```

项目参考代码
----------
- [Facebook Ios SDK](https://github.com/facebook/facebook-ios-sdk).
- [SDWebImage](https://github.com/rs/sdwebimage).

## Licenses

All source code is licensed under the [MIT License](https://github.com/JimLiu/WeiboSDK/blob/master/LICENSE).