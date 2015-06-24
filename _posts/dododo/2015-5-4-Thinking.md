---
layout: post
title: Thinking-2015-5-4
---
{{ page.title }}

##questions
1. is retain() needed or not ? in following two situations: pNode and sender.

```c++
bool TestCcbContainer::onAssignCCBMemberVariable(cocos2d::CCObject* pTarget, const char* pMemberVariableName, cocos2d::CCNode* pNode) {
	if (pTarget != this) {
		return false;
	}
	std::string elementName = pMemberVariableName;
	auto iter = _elementsMap.find(elementName);
	if (iter != _elementsMap.end()) {
		if (iter->second != pNode) {
			iter->second->release();
			iter->second = pNode;
			pNode->retain();
		}
	}
	else {
		_elementsMap.insert(make_pair(elementName, pNode));
        // why i retain this?
		pNode->retain();
	}
	return true;
}
```

```c++
cocos2d::SEL_MenuHandler TestCcbContainer::onResolveCCBCCMenuItemSelectorWithSender(cocos2d::CCObject * pTarget, const char* pSelectorName, cocos2d::CCNode* sender) {
	if (pTarget != this) {
		return nullptr;
	}
	std::string selectorName = pSelectorName;
	auto iter = _actionsMap.find(sender);
	if (iter != _actionsMap.end()) {
		iter->second = selectorName;
	}
	else {
		_actionsMap.insert(make_pair(sender, selectorName));
        // should i retain sender, why ?
	}
	return static_cast<SEL_MenuHandler>(&TestCcbContainer::menuClicked);
}
```

##summary

##todo

