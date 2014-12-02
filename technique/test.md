#海贼王论坛问题
##1.相关控件 (MainFrame.ccb) (MainFrame.cpp -> Enter)
显示层级：mPrivateForum > mForum

- mPrivateForum == MenuItemImage == on1818bug == "论坛" == openURL(Variable.txt["PrivateBBSURL"])           ===== 自由论坛 http://mxhzw.com/forum.php == "Bug 反馈"
- mForum        == MenuItemImage == on18183   == "论坛" == libPlatformManager::getPlatform()->openBBS()     ===== 18183 http://bbs.18183.com/forum-mxhzw-1.html == 攻略 or 广告

显示开关：
- mForm
>
- android: bbsconfig.txt status(0/1)
- win32: true
- ios: platformroleconfig.txt bbsOpenStatus

- mPrivateForum:
> "PrivateBBSURLOpenStatus" in Variable.txt


## 常用组合的配置
1. 开放自由论坛，关闭18183论坛
> 
1. PrivateBBSURLOpenStatus = 1 (in Variable.txt)
2. [可选步骤，因为mForum层级在下面] PlatformRoleConfig.txt bbs开启状态 = 0

2. 开放18183, 关闭自由论坛
>
1. PlatformRoleConfig.txt bbs开启状态 = 1
2. PrivateBBSURLOpenStatus = 0 (in Variable.txt)

## 总结
- PlatformRoleConfig 控制下面的论坛，会调用libPlatformManager的openBBS(), 打开论坛(攻略) 或者 广告。
> 论坛或者广告的控制开关配置在dynamic.ini, 默认是弹广告，要不弹出广告加上: [Advertise]  showAdvertise=NO

- Variable.txt 控制上面的论坛(bug反馈)，是打开配置在Variable.txt["PrivateBBSURL"]的地址 
- 正常情况下，两者是互斥的。

- 总结表
|*功能*|*开关*|*备注*|
|------|------|------|
|攻略or广告|PlatformRoleConfig -> bbs开启状态|默认显示广告，关闭广告的开关在dynamic.ini -> [Advertise] showAdvertise=NO|
|bug反馈（官方论坛）| Variable.txt -> PrivateBBSURLOpenStatus | 这个按钮在攻略的上面，所以如果两者同时打开，显示的会是bug反馈|
