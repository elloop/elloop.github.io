--[[
@desc ItemBagScene 道具背包
@author liu longfei
@date 2014.1.13
]]--

--[[
    self.datas 所有道具数据
    self.datas = {
        all = {},           所有        
        stone = {},         灵魂石
        consume = {},       消耗品
        equip = {},         装备
        scroll = {}         卷轴
    }
    self.loadResStack       资源加载堆栈,ccbi分帧加载，一帧加载一个，优化显示时间
    self.tabType            当前选中的tab类型，参考EnumItemBagTab        
    self.datas              当前选中的tab的道具数据 
    self.bagType            背包类型，来自ItemBagMgr
    self.loadResFlags       资源加载标记，加载过的，不重复加载
    self.selectedIndex      当前选中的道具索引
]]--
local class = {
	mt = {}
}

class.mt.__index = class;
class.name = "ItemBagScene"
TestScene = class;
local ed = ed;
local UIFrame = ed.UIFrame;
UIFrame.registerScene(class);

-----------------------------------------------------------------------------------------------------------------------------------
local ItemContent = {
    mt = {}
};
ItemContent.name = "ItemContent"
ItemContent.mt.__index = ItemContent;

local function onItemRegisterFunction(eventName,container)
    if eventName == "luaRefreshItemView" then
        ItemContent.onRefreshItemView(container);
    elseif eventName == "onBuy" then
       
    end
end
ItemContent.onRegisterFunction = onItemRegisterFunction;

local SingleItemContent = {}
local function onRegisterSingleItemFunction(eventName,container)
    if eventName == "onCheck" then
        --出售
        local index = container.mIndex;
        local data = class.datas[class.tabType][index];
        if data == nil then return end
        class.selectedIndex = index;
        local page = UIFrame.getPageByName("ItemInfoPage");
        local node = class.container:getCCNodeFromCCB("mItemInfoNode");
        if node:getChildrenCount() == 0 then
            if page.onLoad then
                page:onLoad();
            end
            if page.onEnter then
                page:onEnter();
            end

            node:addChild(page.container);
            page.container:runAnimation("Ani2");
            page:initData(data);
        else
            page:initData(data);
        end
    elseif eventName == "onInfo" then
        --详情
        
    end
end
SingleItemContent.onRegisterFunction = onRegisterSingleItemFunction;

local function onRegisterMenuItemFunction(eventName,menuItem)
    if eventName == "selected" then
        local parent = menuItem:getParent():getParent():getParent();
        parent:setScale(ed.ClickToScaleValue);
    elseif eventName == "unselected" then
        local parent = menuItem:getParent():getParent():getParent();
        parent:setScale(1.0);
    end
end
SingleItemContent.onRegisterMenuItemFunction = onRegisterMenuItemFunction;

local function onRefreshItemView(container)
    --local id = container:getItemDate().mID;  
    for i=1,4 do 
        local data = {};
        data.resName = "ccbi/CommonPkgItemNode.ccbi";
        data.tb = SingleItemContent;
        data.tag = 4-i+1;
        data.position = ccp(105*(4-i)+50,0);
        data.container = container;
        table.insert(class.loadResStack[class.tabType],data);
    end
end
ItemContent.onRefreshItemView = onRefreshItemView;
-----------------------------------------------------------------------------------------------------------------------------------
--@desc：注册回调
local function onRegisterFunction(eventName,container)
	if eventName == "onPkgBtn1" then
        class:onClickTab(ed.EnumItemBagTab.Tab_All);
    elseif eventName == "onPkgBtn1TouchDown" then
        class:changeTabState(true,ed.EnumItemBagTab.Tab_All);
    elseif eventName == "onPkgBtn1TouchUpOutside" then
        class:changeTabState(false,ed.EnumItemBagTab.Tab_All);
    elseif eventName == "onPkgBtn2" then
        class:onClickTab(ed.EnumItemBagTab.Tab_Equip);        
    elseif eventName == "onPkgBtn2TouchDown" then
        class:changeTabState(true,ed.EnumItemBagTab.Tab_Equip);
    elseif eventName == "onPkgBtn2TouchUpOutside" then
        class:changeTabState(false,ed.EnumItemBagTab.Tab_Equip);
    elseif eventName == "onPkgBtn3" then
        class:onClickTab(ed.EnumItemBagTab.Tab_Scroll);
    elseif eventName == "onPkgBtn3TouchDown" then
        class:changeTabState(true,ed.EnumItemBagTab.Tab_Scroll);
    elseif eventName == "onPkgBtn3TouchUpOutside" then
        class:changeTabState(false,ed.EnumItemBagTab.Tab_Scroll);
    elseif eventName == "onPkgBtn4" then
        class:onClickTab(ed.EnumItemBagTab.Tab_Stone);
    elseif eventName == "onPkgBtn4TouchDown" then
        class:changeTabState(true,ed.EnumItemBagTab.Tab_Stone);
    elseif eventName == "onPkgBtn4TouchUpOutside" then
        class:changeTabState(false,ed.EnumItemBagTab.Tab_Stone);
    elseif eventName == "onPkgBtn5" then
        class:onClickTab(ed.EnumItemBagTab.Tab_Consume);
    elseif eventName == "onPkgBtn5TouchDown" then
        class:changeTabState(true,ed.EnumItemBagTab.Tab_Consume);
    elseif eventName == "onPkgBtn5TouchUpOutside" then
        class:changeTabState(false,ed.EnumItemBagTab.Tab_Consume);
    elseif eventName == "onPkgBtn6" then
        --图鉴
        local param = {name = "HandbookScene"};
        UIFrame.pushScene(param);
    end
end
class.onRegisterFunction = onRegisterFunction;

--@desc：加载ccbi
local function onLoad(self)
	local scene = CCScene:create();
	local container = ed.loadccbi(self,"ccbi/CommonPackageScene.ccbi");
	self.container = container;
	local commonFrameTable = ed.CommonFrame:create();
	self.commonFrameTable=commonFrameTable
    local cmnFrame = commonFrameTable.container
    local node = cmnFrame:getCCNodeFromCCB("mCommonFrameNode");
    node:addChild(container);
	scene:addChild(cmnFrame);
    self.cmnFrame = cmnFrame;
	self.scene = scene;

    --初始化ScrollView
    self.scrollViews = {};
    self.scrollViewRootNodes = {};
    self.scrollViewFacades = {};
    for i=1,5 do 
        local name = string.format("mContentSV%d",i);
        local scrollView = container:getCCScrollViewFromCCB(name);
        local scrollViewRootNode = scrollView:getContainer();
        local scrollViewFacade = CCReViScrollViewFacade:new(scrollView);
        scrollViewFacade:init(40,40);
        table.insert(self.scrollViews,scrollView);
        table.insert(self.scrollViewRootNodes,scrollViewRootNode);
        table.insert(self.scrollViewFacades,scrollViewFacade);
    end    
	return scene;
end
class.onLoad = onLoad;

--@desc：卸载回调
local function onUnload(self)
	self.container:unload();

    self.commonFrameTable.moneyContainer:unload();
    self.commonFrameTable.buttonsContainer:unload();
    
    for k,v in ipairs(self.scrollViewFacades) do
        v:delete();
    end
    self.scrollViewFacades = nil;
    self.scrollViews = nil;
    self.scrollViewRootNodes = nil;
end
class.onUnload = onUnload;

local function onEnter(self)
    UIFrame.registerUIMsg(ed.EnumUIMsgType.PopPageMsg,self,"ItemSellPage");
    UIFrame.registerUIMsg(ed.EnumUIMsgType.PopPageMsg,self,"FragmentComposePage");
    UIFrame.registerUIMsg(ed.EnumUIMsgType.PopPageMsg,self,"HeroUpgradePage");
    self:initDatas();
    self:initTab();
    self:onClickTab(ed.EnumItemBagTab.Tab_All);
end
class.onEnter = onEnter;

local function onExit(self)
    UIFrame.unRegisterUIMsg(ed.EnumUIMsgType.PopPageMsg,self,"ItemSellPage");
    UIFrame.unRegisterUIMsg(ed.EnumUIMsgType.PopPageMsg,self,"FragmentComposePage");
    UIFrame.unRegisterUIMsg(ed.EnumUIMsgType.PopPageMsg,self,"HeroUpgradePage");
    self.datas = {};       
    self.loadResStack = {};  
    self.ccbTable = {};
    for i=1,5 do
        self.loadResStack[i] = {};
        self.ccbTable[i] = {};
    end
    self.loadResFlags = {};
    self.loadIndexs = {};
end
class.onExit = onExit;

local function onRefresh(self,param)
	
end
class.onRefresh = onRefresh;

local function onReceiveMsg(self,msg)
    
end
class.onReceiveMsg = onReceiveMsg;

local function onReceiveUIMsg(self,msgType,name)
    if msgType == ed.EnumUIMsgType.PopPageMsg and (name == "ItemSellPage" or name == "FragmentComposePage" or name == "HeroUpgradePage") then
        --当前tab页，重建
        local itemData = self.datas[self.tabType][self.selectedIndex];
        if itemData == nil then return end        
        local amount = ed.player.equip_qunty[itemData.id];
        if amount == 0 then
            local node = self.container:getCCNodeFromCCB("mItemInfoNode");
            if node:getChildrenCount() ~= 0 then
                local page = UIFrame.getPageByName("ItemInfoPage");
                if page.container ~= nil then
                    page:onUnload();
                    page:onExit();
                    page.container:removeFromParentAndCleanup(true);
                    page.container = nil;
                end
                node:removeAllChildrenWithCleanup(true);
            end
            
            self.loadResFlags[self.tabType] = nil;
            ed.ItemBagMgr:initData();
            self:resetDatas();
            self:rebuildAllItem();
        else    
            --刷新ItemInfoPage
            local page = UIFrame.getPageByName("ItemInfoPage");
            page:initData(itemData);        
            local ccb = self.ccbTable[self.tabType][self.selectedIndex];
            if ccb == nil then return end
            
            if self.bagType == ed.EnumItemBagType.ItemBagType_Package then
                local icon = ed.createIconWithAmount(itemData.id);
                local iconNode = ccb:getCCNodeFromCCB("mItemNode");
                iconNode:removeAllChildren();
                if icon then
                    local size = iconNode:getContentSize();
                    icon:setPosition(size.width/2,size.height/2);
                    iconNode:addChild(icon);
                end
            elseif self.bagType == ed.EnumItemBagType.ItemBagType_Fragment then
                local icon,fg,al,tag = ed.readequip.createIconWithTag(itemData.makeId);
                local iconNode = ccb:getCCNodeFromCCB("mItemNode");
                iconNode:removeAllChildren();
                if icon then
                    local size = iconNode:getContentSize();
                    icon:setPosition(size.width/2,size.height/2);
                    iconNode:addChild(icon);
                end
                if tag then
                    if ed.readequip.isFragmentEnough(itemData.id) == true then
                        tag:setVisible(true);
                    else
                        tag:setVisible(false);
                    end
                end                
            end
        end            
    end
end
class.onReceiveUIMsg = onReceiveUIMsg;

--@desc:相关数据初始化
local function initDatas(self)
    self.tabType = ed.EnumItemBagTab.Tab_All;        
    self.datas = {};
    self.datas[self.tabType] = ed.ItemBagMgr:getData("all");
    self.bagType = ed.ItemBagMgr:getCurType();
    self.loadResStack = {};  
    self.ccbTable = {};
    for i=1,5 do
        self.loadResStack[i] = {};
        self.ccbTable[i] = {};
    end
    self.loadResFlags = {};
    self.loadIndexs = {};
end
class.initDatas = initDatas;

--@desc:重置道具数据
local function resetDatas(self)
    if self.tabType == ed.EnumItemBagTab.Tab_All then
        self.datas[self.tabType] = ed.ItemBagMgr:getData("all");
    elseif self.tabType == ed.EnumItemBagTab.Tab_Equip then
        self.datas[self.tabType] = ed.ItemBagMgr:getData("equip");
    elseif self.tabType == ed.EnumItemBagTab.Tab_Scroll then
        self.datas[self.tabType] = ed.ItemBagMgr:getData("scroll");
    elseif self.tabType == ed.EnumItemBagTab.Tab_Stone then
        self.datas[self.tabType] = ed.ItemBagMgr:getData("stone");
    elseif self.tabType == ed.EnumItemBagTab.Tab_Consume then
        self.datas[self.tabType] = ed.ItemBagMgr:getData("consume");
    end
end
class.resetDatas = resetDatas;

--@desc:tab标签初始化
local function initTab(self)
    if self.bagType == ed.EnumItemBagType.ItemBagType_Package then
    
    elseif self.bagType == ed.EnumItemBagType.ItemBagType_Fragment then
        for i=4,6 do 
            local name = string.format("mPkgBtn%d",i);
            local btn = self.container:getCCControlButtonFromCCB(name);
            if btn then
                btn:setVisible(false);
            end
        end
    end
end
class.initTab = initTab;

local function changeTabState(self,selected,tabType)
    local name = string.format("mPkgBtn%d",tabType);
    local button = self.container:getCCControlButtonFromCCB(name);
    if selected == true then
        button:setZOrder(10);
        local texture=CCTextureCache:sharedTextureCache():addImage("UI/alpha/HVGA/Button_BG/Btn_Select_A_02.png")
        local rect = CCRect(0, 0, texture:getContentSize().width, texture:getContentSize().height)
        local spriteFrame=CCSpriteFrame:createWithTexture(texture,rect)
        button:setBackgroundSpriteFrameForState(spriteFrame,CCControlStateNormal)
    else
        button:setZOrder(-1);
        local texture=CCTextureCache:sharedTextureCache():addImage("UI/alpha/HVGA/Button_BG/Btn_Select_A_01.png")
	    local rect = CCRect(0, 0, texture:getContentSize().width, texture:getContentSize().height)
	    local spriteFrame=CCSpriteFrame:createWithTexture(texture,rect)
	    button:setBackgroundSpriteFrameForState(spriteFrame,CCControlStateNormal)
    end
end
class.changeTabState = changeTabState;

--@desc:设置tab选中状态
local function setTabSelected(self,tabType)
    for i=1,5 do
        local name = string.format("mPkgBtn%d",i);
        local button = self.container:getCCControlButtonFromCCB(name);
        if i == tabType then
            button:setZOrder(10);
            local texture=CCTextureCache:sharedTextureCache():addImage("UI/alpha/HVGA/Button_BG/Btn_Select_A_02.png")
			local rect = CCRect(0, 0, texture:getContentSize().width, texture:getContentSize().height)
			local spriteFrame=CCSpriteFrame:createWithTexture(texture,rect)
			button:setBackgroundSpriteFrameForState(spriteFrame,CCControlStateNormal)
            button:setFadeImage("UI/alpha/HVGA/FontColor/c_White_Khaki01.png");
            button:setShadowColor(66/255,31/255,3/255,1.0);
        else
            button:setZOrder(-1);
            local texture=CCTextureCache:sharedTextureCache():addImage("UI/alpha/HVGA/Button_BG/Btn_Select_A_01.png")
			local rect = CCRect(0, 0, texture:getContentSize().width, texture:getContentSize().height)
			local spriteFrame=CCSpriteFrame:createWithTexture(texture,rect)
			button:setBackgroundSpriteFrameForState(spriteFrame,CCControlStateNormal)
            button:setFadeImage("UI/alpha/HVGA/FontColor/c_White_Blue01.png");
            button:setShadowColor(0,24/255,58/255,1.0);
        end
    end
end
class.setTabSelected = setTabSelected;

--@desc:点击标签，相关逻辑处理
local function onClickTab(self,tabType)
    self.tabType = tabType;
    self:showScrollViewByTab(class.tabType);
    self:setTabSelected(tabType);
    self:resetDatas();
    self:rebuildAllItem();
end
class.onClickTab = onClickTab;

--@desc:根据tab标签，选择显示ScrollView
local function showScrollViewByTab(self,tabType)
    for i=1,5 do
        local name = string.format("mContentSV%d",i);
        local scrollView = self.container:getCCScrollViewFromCCB(name);
        if tabType == i then
            scrollView:setVisible(true);
        else
            scrollView:setVisible(false);
        end
    end
end
class.showScrollViewByTab = showScrollViewByTab;

local function rebuildAllItem(self)
    if self.loadResFlags[self.tabType] ~= nil then return end
    self:clearAllItem();
    self:buildAllItem();
    self.loadIndexs[self.tabType] = 1;
    self.loadResFlags[self.tabType] = true;
end
class.rebuildAllItem = rebuildAllItem;

local function clearAllItem(self)
    local facade = self.scrollViewFacades[self.tabType];
    if facade then
        facade:clearAllItems();
    end
    self.ccbTable[self.tabType] = {};
end
class.clearAllItem = clearAllItem;

--@desc:加载content
local function buildAllItem(self)
    if self.datas[self.tabType] == nil then return end
    local container = self.container;
    local scrollViewFacade = self.scrollViewFacades[self.tabType];
    local scrollView = self.scrollViews[self.tabType];
    local iMaxNode = scrollViewFacade:getMaxDynamicControledItemViewsNum();
    local fOneItemHeight = 0;
    local fOneItemWidth = 0;
    local pItem = ScriptContentBase:create("ccbi/CommonPkgContent.ccbi");
    if  fOneItemHeight < pItem:getContentSize().height then
	    fOneItemHeight = pItem:getContentSize().height;
    end
    if fOneItemWidth < pItem:getContentSize().width then
	    fOneItemWidth = pItem:getContentSize().width;
    end
    local iMaxCount = math.ceil(#self.datas[self.tabType]/4);
    local iIndex = 0;
    for k = 1,iMaxCount do 
        local pItemData = CCReViSvItemData:new();
        pItemData.mID =  k;
        pItemData.m_iIdx = iIndex;
        pItemData.m_ptPosition = ccp(0, fOneItemHeight*iIndex+55);

        if iIndex < iMaxNode then
            local pItem = ScriptContentBase:create("ccbi/CommonPkgContent.ccbi");
	        pItem.id = iIndex;
	        pItem:registerFunctionHandler(ItemContent.onRegisterFunction);                         
	        scrollViewFacade:addItem(pItemData, pItem.__CCReViSvItemNodeFacade__);
        else
            scrollViewFacade:addItem(pItemData);
        end 
        iIndex = iIndex + 1;
    end

    local size = CCSizeMake(420, fOneItemHeight*iMaxCount);
	scrollView:setContentSize(size);
	local maxOffset = scrollView:getViewSize().height - scrollView:getContentSize().height * scrollView:getScaleY();
    scrollView:setContentOffset(ccp(0,maxOffset));
	scrollViewFacade:setDynamicItemsStartPosition(iIndex-1);
end
class.buildAllItem = buildAllItem;

--@desc:加载content中的四个道具，分批加载
local function buildItem(self)
    if self.loadResStack[self.tabType] == nil then return end
    if self.datas[self.tabType] == nil then return end
    local length = #self.loadResStack[self.tabType];
    if length == 0 then return end
    if self.loadIndexs[self.tabType] > #self.datas[self.tabType] then return end

    local data = self.loadResStack[self.tabType][length];
    local ccb = ed.loadccbi(data.tb,data.resName); 

    local menuItem = ccb:getCCMenuItemImageFromCCB("mCheck");
    if menuItem then
        menuItem:registerScriptTapHandler(SingleItemContent.onRegisterMenuItemFunction);
    end
    ccb:setPosition(data.position);
    ccb:setTag(data.tag);
    data.container:addChild(ccb);
    ccb:setChildMenu();     
    ccb.mIndex = self.loadIndexs[self.tabType];
    table.remove(self.loadResStack[self.tabType],length);
    self.loadIndexs[self.tabType] = self.loadIndexs[self.tabType] + 1;
    table.insert(self.ccbTable[self.tabType],ccb);
    --设置相关值
    local itemData = self.datas[self.tabType][ccb.mIndex];
    if itemData == nil then return end        
    if self.bagType == ed.EnumItemBagType.ItemBagType_Package then
        local icon = ed.createIconWithAmount(itemData.id);
        local iconNode = ccb:getCCNodeFromCCB("mItemNode");
        if icon then
            local size = iconNode:getContentSize();
            icon:setPosition(size.width/2,size.height/2);
            iconNode:addChild(icon);
        end
    elseif self.bagType == ed.EnumItemBagType.ItemBagType_Fragment then
        local icon,fg,al,tag = ed.readequip.createIconWithTag(itemData.makeId);
        local iconNode = ccb:getCCNodeFromCCB("mItemNode");
        if icon then
            local size = iconNode:getContentSize();
            icon:setPosition(size.width/2,size.height/2);
            iconNode:addChild(icon);
        end
        if tag then
            if ed.readequip.isFragmentEnough(itemData.id) == true then
                tag:setVisible(true);
            else
                tag:setVisible(false);
            end
        end        
    end
end
class.buildItem = buildItem;

local function onUpdate(self,dt)
    self:buildItem();
end
class.onUpdate = onUpdate;



