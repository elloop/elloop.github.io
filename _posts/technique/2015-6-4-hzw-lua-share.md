---
layout: post
title: Hzw Share 1
published: false
category: lua
tags: [lua, programming]
description: "technique conference"
---

#《海贼王项目组技术会议-1》-lua讨论

---
|时间|内容|
|:---|-----:|
|2015年6月8日|海贼客户端lua技术讨论|

##lua页面
- 创建
	1. 使用CommonPage.new()，CommonPage预定义了一些页面的基本方法，使用CommonPage可以免去重复定义function的麻烦，尤其是用不到的function。
	2. 使用CommonPage.newSub()，跟CommonPage没太大区别，主要是带来一些语法便利，但是由于其采用了修改metatable来实现，所以在查找变量表方面多了一层，比直接使用CommonPage有一定的性能损失。建议统一使用CommonPage.new()。
	3. 使用module，官方推荐做法，有待实验。
- 网络通信
	- 最简单的收发包方法：(参见`ShipInstructionCfg.lua`) 

	```lua
	local handler = LuaPacketHandler:new_local() 	
	handler:registerPacket(step.waitopcode) 	
	handler:registerFunctionHandler( function(eventName) 	
		if eventName == "luaReceivePacket" then 	
			handler:removePacket(step.waitopcode) 	
			ShipInstructionSys.delayNextStep(step.delay) 	
		end 	
	end) 		
	```	

	LuaPacketHandler的实现在LuaPacketHandler.cpp中，在那里可以找到常用的接口，如getRecPacketOpcode(), getRecPacketBuffer()等。它实现了收发包逻辑和界面的分离，不依赖于container。
	
	- 其它收发包辅助函数：
	    - 发包: Global_OnSendPacket 
	    
	    ```lua
        function Global_OnSendPacket(container, OPFunc, opcode, wait, FillDataFunc)
	        local msg = OPFunc()
	        FillDataFunc(msg)
	        local pb_data = msg:SerializeToString()
	        PacketManager:getInstance():sendPakcet(opcode, pb_data, #pb_data, wait)
        end
        ```
         
        示例：

        ```lua
        Global_OnSendPacket(nil, proto.OPSnatchBasicInfo, Op_pb.XX, true, function(msg) 
            msg.version = dataManager.version
        end)
        
        ```
        
        - 接包：Global_OnReceivePacketRet
         
        ```lua
        -- receive packet
        function Global_OnReceivePacketRet(container, OPRetFunc, ReceiveFunc)
	        local msg = OPRetFunc()
	        if msg ~= nil then
		        local msgBuff = container:getRecPacketBuffer()
	        	msg:ParseFromString(msgBuff)
	        	ReceiveFunc(container, msg)
	        end
        end
        ```
         
        示例：

        ```lua
        Global_OnReceivePacketRet(container, UserRewards_pb.OPUserRewardRet, 
            function(container, msg)
                local x = msg.x
            end
        )
        ```
        
    - 总结
        - 尽量是收发包代码与界面分开，推荐使用LuaPacketHandler的方式
        - Opcodes使用Op.proto定义的即可，不需自己单独定义。用法如下：

        ```lua
        local opcodes = require("OP_pb") -- 使用OP.proto
        opcodes.OPCODE_GET_USER_BASIC_INFO_C
        opcodes.OPCODE_GET_USER_BASIC_INFO_S
        -- ...
        ```
    
- 内存优化
	- 模块内local主动赋值nil：促使其被垃圾回收器回收。
	- 其它 
##代码风格
- 模块内变量分块定义：比如所有local统一放在文件开头

    ```lua
    -- 坏的风格
    local proto = require("NewSnatchWar_pb")
    local data               = {
        basicInfo            = {}, -- proto.OPSnatchBasicInfoRet()
        version              = 1,
        inited               = false,
    }
    for index=1, #... do
        -- ...
    end
    local min   = math.min
    local floor = math.floor
    local ceil  = math.ceil
    -- ...
    -- ...
    -- ...
    -- ...
    -- 好的风格
    local proto = require("NewSnatchWar_pb")
    local min   = math.min
    local floor = math.floor
    local ceil  = math.ceil
    
    local data               = {
        basicInfo            = {}, -- proto.OPSnatchBasicInfoRet()
        version              = 1,
        inited               = false,
    }
    
    for index=1, #... do
        -- ...
    end
    ```

- 属于一个table的变量，以花括号的形式，统一包裹在{}之间。

    ```lua
    -- 坏的风格
    local data               = {
        basicInfo            = {}, -- proto.OPSnatchBasicInfoRet()
        version              = 1,
        inited               = false,
    }
    data.currentResourceIndex = 0, -- 当前正在展示的资源点索引
    data.resourcesPerPage     = 10, -- 每个岛(页)多少个资源点
    data.maxPage              = 0,-- 有几个岛(页)
-- ...
-- ...
-- ...
-- ...
-- 好的风格
    local data               = {
        basicInfo            = {}, -- proto.OPSnatchBasicInfoRet()
        version              = 1,
        inited               = false,
        currentResourceIndex = 0, -- 当前正在展示的资源点索引
        resourcesPerPage     = 10, -- 每个岛(页)多少个资源点
        maxPage              = 0,-- 有几个岛(页)
        
    }
    ```
    
- 使用空行分割逻辑功能代码
- 使用table代替过多的函数参数

    ```lua
    -- 坏的风格
    function ShowSnatchWarBuyPage(hasBuyCount, leftBuyTime, maxNum, leftFightCount, title, notice, callback, minNum, step)
        -- ...
    end
    -- 好的风格
    function ShowSnatchWarBuyPage(buyInfo)
        -- buyInfo.hasBuyCount ...
        -- buyInfo.leftBuyTime ...
        -- buyInfo.maxNum ...
        
    end
    ```
    
- 参考一些成熟、出名项目的代码风格，如protobuf.lua, Cocos2d-lua等等。
##代码重用
- 重复的部分，当做参数，抽象出函数或模块以达到重用。
- 已经抽象出的方法
    - Global_FillScrollViewContent （`UtilFunctions.lua`）： 填充scrollview，用法示例在：`ShipEnhancePageLua.lua`，ShipEnhancepage.refreshDashi()函数
    - 操纵界面控件方法：集中定义在`IncPbCommon.lua`的common类中。
        - setStringForLabel
        - setTextureForSprite
        - setScaleForNodes
        - setButtonsEnabled
        - setButtonsSelected
        - setNormalImageForMenuImage
        - setFrameQuality
        - setNodeVisible
        - 等等。
- IncPbCommon中其他的方法
    - getLanguageString("@KeyWithParam", parm1, parm2, ..., parmn),chinese.lang变量自动替换。
    - setBlackBoardVariable ： 设blackboard变量
    - getBlackBoardVariable(key, doDelete)：取blackboard, doDelete传入true，代表获取后删除之。
    - secondsToHHMMSS(seconds): 秒数转为："00:00:00"格式的倒计时串
    - second2DateString(second): 秒数转为“天时分秒”汉子字符串
    - showResInfo(itemType, itemId): 弹出奖励预览
    - stringAutoReturn(s, width)
    - parseRewardConfig(): 把一个txt奖励字符串"11001:1001:200, 61001:1502001:750"解析为奖励数组。
    - prepareRewardPage(): 给奖励弹窗填充数据
    - round45(n): 四舍五入
    - setPrecision(n, precision)：保留precision位小数
    - getRewardsDesc(rewards): 返回奖励数组的文字描述：如“潜能药剂x10,锤子x100,贝里x10”
- 页面切换： PageManager (`IncPbCommon.lua`)
    - showPage(): change page
    - pushPage()
    - popPage()
    - refreshPage
    - showCover
    - hideCover
    - showFight(): 弹出战斗界面
- lua读表器 ConfigManager (`TableManagerForLua.lua`)
    - ConfigManager.getXXXConfig()
- 通用界面
    - DecisionPage： 确认对话框 (`DecisionPage.lua`)
    - DecisionPageSmall： 小型确认对话框 (`DecisionPageSmall.lua`)
    - AddCountPage： 增减数量页面 (`AddCountPage.lua`)
- 其它


