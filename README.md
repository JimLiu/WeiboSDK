# WeiboSDK #
新浪微博SDK，基于v2版API接口，对认证和请求进行了封装，

## sample ##
SDK应用示例(静态库引用)，包含最新微博列表、多帐号管理、发布文字微博、发布图片微博等功能示例。
详情请见：[sample](https://github.com/JimLiu/WeiboSDK/tree/master/Sample "新浪微博SDK示例") 。

## sample_nolib ##
SDK应用示例(非静态库引用，代码引用)，包含最新微博列表、多帐号管理、发布文字微博、发布图片微博等功能示例。
详情请见：[sample_nolib](https://github.com/JimLiu/WeiboSDK/tree/master/sample_nolib "新浪微博SDK示例") 。


##API参考文档##
关于API的完整文档请参考：[新浪微博API文档](http://open.weibo.com/wiki/%E9%A6%96%E9%A1%B5 "新浪微博API文档") 。

##第三方类库##
###ASIHttpRequest###
[ASIHttpRequest](http://allseeing-i.com/ASIHTTPRequest/ "ASIHttpRequest官方网站") 是一个对HTTP请求进行封装的类库，WeiboSDK的所有HTTP请求都使用ASIHttpRequest。
###JsonKit###
[JsonKit](https://github.com/johnezang/JSONKit "JsonKit 官方网站") 是一个Json解析的开源类库，新浪微博返回的Json数据都是基于它来解析。
###MBProgressHUD###
[MBProgressHUD](https://github.com/jdg/MBProgressHUD "MBProgressHUD 官方网站") 是一个漂亮的Loading对话框类库，在一些需要提示Loading的消息框使用它来显示。


##截图##
####首页####
![首页](https://github.com/JimLiu/WeiboSDK/blob/master/screenshots/Home.png?raw=true)

####帐号管理####
![帐号管理](https://github.com/JimLiu/WeiboSDK/blob/master/screenshots/Accounts.png?raw=true)

####撰写微博####
![撰写微博](https://github.com/JimLiu/WeiboSDK/blob/master/screenshots/Compose.png?raw=true)