#include "stdafx.h"
#include "BasePage.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CCBManager.h"
#include "StringConverter.h"
#include "BlackBoard.h"

USING_NS_CC;
USING_NS_CC_EXT;

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
static const int k_logic_w = 640;
static const int k_logic_h = 960;
int BasePage::calcAdjustResolutionOffY()
{
	// calc
	CCSize size_lgoic, size_real;
	size_lgoic.setSize(k_logic_w, k_logic_h);
	//modified by zhenhui 2014/5/30
	size_real = CCEGLView::sharedOpenGLView()->getDesignResolutionSize();
	int off_y = (size_real.height - size_lgoic.height) * .5f * 1.f;

	//
	return off_y;
}

void BasePage::autoAdjustResolution()
{
	int off_y = BasePage::calcAdjustResolutionOffY();

	//   ”¶∆¡ƒª
	int old_y = 0;
	CCNode *pNodeTop = dynamic_cast<CCNode*>(getVariable("mTopNode"));
	CCNode *pNodeBottom = dynamic_cast<CCNode*>(getVariable("mBottomNode"));
	CCNode *pNodeMid = dynamic_cast<CCNode*>(getVariable("mMidNode"));
	if (pNodeTop)
	{
		old_y = pNodeTop->getPositionY();
		pNodeTop->setPositionY(old_y + off_y);
	}
	if (pNodeBottom)
	{
		old_y = pNodeBottom->getPositionY();
		pNodeBottom->setPositionY(old_y - off_y);
	}
	if (pNodeMid)
	{
		old_y = pNodeMid->getPositionY();
		pNodeMid->setPositionY(old_y - off_y);
	}
}

void BasePage::autoAdjustResizeScrollview(cocos2d::extension::CCScrollView *pScrollView)
{
	if (!pScrollView)
		return;

	//
	int off_y = BasePage::calcAdjustResolutionOffY();	
	CCSize old_size = pScrollView->getViewSize();
	old_size.height += 2*off_y;
	pScrollView->setViewSize(old_size);
}

void BasePage::autoAdjustResizeScale9Sprite(cocos2d::extension::CCScale9Sprite * pscale9Sprite){
	if (!pscale9Sprite)
	{
		return;
	}
	int off_y = BasePage::calcAdjustResolutionOffY();	
	CCSize old_size = pscale9Sprite->getContentSize();
	old_size.height += 2*off_y;
	pscale9Sprite->setContentSize(old_size);


}
