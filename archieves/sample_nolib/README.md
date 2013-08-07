# 非静态库引用SDK实例 #
SDK应用示例，SDK功能直接引用代码，避免静态库引用导致的重复引用等问题，该演示包含最新微博列表、多帐号管理、发布文字微博、发布图片微博等功能示例。

##安装说明##
一、在项目中添加WeiboSDK相关代码，清单如下：

	src
		Additions
			NSDictionaryAdditions.h
			NSDictionaryAdditions.m
		Models
			GeoInfo.h
			GeoInfo.m
			Province.h
			Province.m
			Resources.h
			Resources.m
			Status.h
			Status.m
			User.h
			User.m
		Utilities
			PathHelper.h
			PathHelper.h
		WeiboEngine
			WeiboQuery
				StatusQuery.h
				StatusQuery.m
				TimelineQuery.h
				TimelineQuery.m
				UserQuery.h
				UserQuery.m
				WeiboQuery.h
				WeiboQuery.m
			WeiboAccount.h
			WeiboAccount.m
			WeiboAccounts.h
			WeiboAccounts.m
			WeiboAuthentication.h
			WeiboAuthentication.m
			WeiboConfig.h
			WeiboEngine.h
			WeiboRequest.h
			WeiboRequest.m
			WeiboSignIn.h
			WeiboSignIn.m
			WeiboSignInViewController.h
			WeiboSignInViewController.m
			WeiboSignInViewController.xib


二、安装第三方类库ASIHTTPRequest、JsonKit和MBProgressHUD，具体请参考其官方说明。
[首页](https://github.com/JimLiu/WeiboSDK/ "首页")有它们的链接地址。


##使用说明##
请参考示例