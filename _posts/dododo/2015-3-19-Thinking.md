---
layout: post
title: Date-03-19
category: life
tags: [diary]
published: false
---

#Todo

- [ ] reading codes about version update. 

#Summary

##other
- think half about what's my advantages comparing to other developers. that maybe "programming skill(language level), knowledges in computer theory and algorithms."


##version update
- 第一步，确定要不要更新，状态变量：ServerConst::mCheckState
|    *value*   |  *meanning*          | 
-----------------------------------
|CS_NOT_STARTED [default] | 初始状态: 未进行更新检查|
|CS_OK| 不需要更新或更新完成|
|CS_CHECKING|检查中|
|CS_NEED_UPDATE|需要内更新|
|CS_NEED_STORE_UPDATE|需大版本更新|
|CS_FAILED| 检查失败|
|CS_SEVERFAILED|下载或解析server.php失败|
|CS_REPLACE|需要替换？好像没用|
*表1.ServerConst::mCheckState的取值及含义*

优先级：大版本 > 替换版本 > 内更新

过程：
- In ServerConst::Init() : parse config file, determine values of mServerFile, mLocalVersion ... : `CS_NOT_STARTED`
- In ServerConst::Start(): download server file(saveas `_tempSeverFile.cfg`) and parse server file, determine `mUpdateFile` ... and what to do: hotupdate, big version update or nothing. : `CS_CHECKING` -> `CS_NEED_STORE_UPDATE` or `CS_REPLACE` or `CS_NEED_UPDATE` (in normal situation.)
- In LoadingFrame::Execute(): show a messagebox with only an ok button, click ok to start big version udpate according to platform(when `CS_NEED_STORE_UPDATE`), or do replace(when `CS_REPLACE`) or start  ServerConst::updateResources() (when `CS_NEED_UPDATE`). 
- (PS: slient update: when fsizem \< 700u \* 1024u, config it in `updateByteSize` in server.php;; 获取服务器列表失败的错误码及原因 1. 下载成功，打开失败，code=202 ; 2. 打开成功，json解析失败，code=203)

- 第二步，大版本和替换通常是通过打开外部url来进行下载更新；这里着重描述一下内更新的过程，状态变量：ServerConst::mUpdateState

|    *value*   |  *meanning*          | 
-----------------------------------
|US_NOT_STARTED|  初始状态: 更新未开始|
|US_CHECKING| 检查更新文件列表|
|US_DOWNLOADING|下载|
|US_OK|不需要更新或者更新完成|
|US_FAILED|更新失败|
|CS_UPDATEFAILED|更新失败:下载或解析`_tempUpdateFile.cfg`失败|
*表2.ServerConst::mUpdateState的取值及含义*

过程：
- SeverConsts::updateResources() : 下载`mUpdateFile`("updateAddress" in server.php)保存为`_tempUpdateFile.cfg`, 解析`_tempUpdateFile.cfg`, 同时，进行update.php的`FCS_CHECING`.
- 解析完`_tempUpdateFile.cfg`,`mUpdateState`变为`US_CHECKING`, FCS检查完，`_waitThreadFileCheck` 变为 `FCS_DONE`, 此时触发ServerConst::Update()的while.启动`_downloadFiles()`, 下载过程中，`mUpdateState` 的值为 `US_DOWNLOADING`, 所有文件下载完毕的时候，调用`SeverConsts::_finishUpdate()`,其间会保存`_tempConfigFile.cfg`, 两份，1份叫`_tempConfigFile.cfg`(非android平台); 第2份放在`mAdditionalSearchPath`下，叫`version_xx.cfg`(android的`mAdditionalSearchPath`就是解压目录.), 在`_finishUpdate()`中还会设置`mCheckState`和`mUpdateState`的值分别为`CS_OK`和`US_OK`, 以此通知`LoadingFrame::Execute()`更新完成，显示登陆界面。(在`_finishUpdate()`的最后会重新加载字体文件，修复以前.fnt不生效的bug)

- (PS: 1. update failed code: )
| *code* | *meaning* |
----------------------
|CODE_UPDATE_FAILD_A(206)| 打开`_tempUpdateFile.cfg`失败|
|CODE_UPDATE_FAILD_B(207)| 解析`_tempUpdateFile.cfg`失败|
|CODE_SU_DIFF(209)|server version > update的version 或者 (大版本或次版本不相等(server version和update version)), 检查server.php, 是三个版本号的地方不一致造成的|
|CODE_NO_SPACE(210)| 存储空间不足|
|||
|||
|||
|||
|||

#Qeustions.
- why CurlDownload::Get()->downloadFile(mSeverFile+_getTimeStamp(mSeverFile),desFile); need a time stamp?


