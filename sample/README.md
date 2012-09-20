# 静态库引用SDK实例 #
SDK应用示例(静态库引用)，包含最新微博列表、多帐号管理、发布文字微博、发布图片微博等功能示例。

##安装说明##
1. 在目标项目中添加WeiboSDK项目
2. Target Dependencies里面添加WeiboSDK静态库
3. Link Binary With Libraries中添加以下框架或静态库：
	* CFNetwork.framework
	* SystemConfiguration.framework
	* MobileCoreServices.framework
	* CoreGraphics.framework
	* libz.dylib
	* libWeiboSDK.a
4. 在Build Settings的Other Linker Flags中添加：-all_load 

##使用说明##
请参考示例