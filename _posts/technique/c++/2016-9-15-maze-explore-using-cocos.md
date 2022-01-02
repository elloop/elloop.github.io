---
layout: post
title: "基于Cocos2d-x的迷宫探索演示程序"
category: [c++, algorithm]
tags: [tools]
description: ""
---

#前言

本文展示了使用cocos2d-x来实现的一个迷宫探索演示程序，一种简单粗暴的寻路算法，算法来自经典的严蔚敏c语言数据结构里的迷宫探索算法，使用栈来实现。


# 效果图

![stack-maze-explore.gif](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/stack-maze-explore.gif)


按钮功能：

- Begin : 开始演示

- Reset： 重新生成随机地图, 地图是可以编辑，点击每个掉块翻转状态（墙或者路）

- State: 显示地图的数字状态，调试用。

- Edit: 在进行过探索之后，可以通过Edit对地图进行微调，即可以不需要全部Reset。Edit之后再点Begin，重新进行探索。

下面给出代码实现, 算法和界面是分开的两部分，后面如果要集成新的寻路算法，界面部分是可以公用的，定义新的寻路算法仅需要继承类：，并实现寻路算法接口。

<!--more-->

# 代码

## 算法部分

**1. 算法基类：MazeStrategy.h**

{% highlight c++ %}
#pragma once

#include "cocos2d.h"

class MazeStrategy {
public:
    
    typedef cocos2d::Vec2   MPoint;
    typedef cocos2d::Size   MSize;
    
    struct MazeCell {
        MPoint  pos;
        int     state;
    };

    static const int kStateWall     = 0;
    static const int kStatePass     = 1;
    static const int kStateTryFail  = 2;
    static const int kStateInStack  = 3;
    
    typedef std::vector<MazeCell>       CellArray;
    typedef std::vector<CellArray>      Maze;

    int     _rows;
    int     _columns;
    float   _cellWidth;
    Maze    _maze;
    
    MazeStrategy(int rows = 10, int columns = 10)
        : _rows(rows)
        , _columns(columns)
    {
        srand(time(0));
    }
    
    virtual ~MazeStrategy() {
        
    }
    
    virtual void clearState() {
        for (auto &row : _maze) {
            for (auto &column: row) {
                column.state = (column.state > 0) ? kStatePass : kStateWall;
            }
        }
    }
    
    virtual void resetMaze(MSize winSize, MPoint origin) {
        _cellWidth = std::min(winSize.width / _columns, winSize.height / _rows);
        MPoint offsetForAnchorPoint(_cellWidth/2, _cellWidth/2);
        _maze.resize(_rows);
        int i, j;
        i = j = 0;
        for (auto &row : _maze) {
            row.resize(_columns);
            j = 0;
            for (auto &column: row) {
                column.pos.x = origin.x + j++ * _cellWidth + offsetForAnchorPoint.x;
                column.pos.y = origin.y + i * _cellWidth + offsetForAnchorPoint.y;
                column.state = (rand()*1.0 > RAND_MAX / 7.0 * 5) ? kStateWall : kStatePass;
            }
            ++i;
        }
        _maze[0][0].state = kStatePass;
        _maze[_rows-1][_columns-1].state = kStatePass;
    }
    
    void updateMazeCell(int i, int j, int val) {
        _maze[i][j].state = val;
    }
    
    Maze& getMaze() {
        return _maze;
    }
    
    struct TickResult {
        MPoint  pos;
        int     result;
    };
    virtual TickResult tickStep() {
        return {MPoint(0, 0), 0};
    }
    
};
{% endhighlight %}

**2. 基于栈的解法：StackMazeStrategy.h**

{% highlight c++ %}
#pragma once

#include "MazeStrategy.h"
#include <stack>
#include <array>

class StackMazeStrategy: public MazeStrategy {
public:
    StackMazeStrategy(int row = 10, int col = 10) : MazeStrategy(row, col) {
    }
    
    
    struct Pos {
        int _row;
        int _col;
        Pos(int row = -1, int col = -1) : _row(row), _col(col) { }
        bool operator == (const Pos& rhs) const {
            return (rhs._row == _row && rhs._col == _col);
        }
        bool operator != (const Pos& rhs) const {
            return !(*this == rhs);
        }
        void makeValid(int size) {
            _row = std::max(0, _row);
            _col = std::max(0, _col);
            _row = std::min(_row, size);
            _col = std::min(_col, size);
        }
    };
    
    std::stack<Pos>         _stack;
    Pos                     _currentPos;
    
    Pos getNextPos(const Pos& pos) {
        std::array<Pos, 4> neigboors = {
            Pos(pos._row + 1, pos._col),
            Pos(pos._row, pos._col + 1),
            Pos(pos._row - 1, pos._col),
            Pos(pos._row, pos._col - 1),
        };
        Pos noWay = {-1, -1};
        for (auto& posi : neigboors) {
            posi.makeValid(_rows-1);
            if ( (posi != pos) &&
                (posi != noWay) &&
                (_maze[posi._row][posi._col].state == MazeStrategy::kStatePass) ) {
                return posi;
            }
        }
        return noWay;
    }
    
    void markMaze(const Pos& pos, int t) {
        _maze[pos._row][pos._col].state = t;
    }
    
    void clearState() override {
        MazeStrategy::clearState();
        std::stack<Pos> stemp;
        stemp.swap(_stack);
        _stack.push({0, 0});
        _currentPos = _stack.top();
        markMaze(_currentPos, MazeStrategy::kStateInStack);
    }
    
    void resetMaze(MSize visibleSize, MPoint origin) override {
        MazeStrategy::resetMaze(visibleSize, origin);
        std::stack<Pos> stemp;
        stemp.swap(_stack);
        _stack.push({0, 0});
        _currentPos = _stack.top();
        markMaze(_currentPos, MazeStrategy::kStateInStack);
    }
    
    TickResult tickStep() override {
        int result(0);
        if (_stack.empty()) {
            return {_maze[_currentPos._row][_currentPos._col].pos, 0};     //fail
        }
        
        Pos outlet = {_rows - 1, _columns - 1};
        if (_currentPos == outlet) {
//            printSolution(st);
//            break;
            return {_maze[outlet._row][outlet._col].pos, 1};   // ok
        }
        
        Pos nextPos = getNextPos(_currentPos);
        
        Pos noWay = {-1, -1};
        if (nextPos == noWay) {
            _stack.pop();
            markMaze(_currentPos, MazeStrategy::kStateTryFail);
            if (!_stack.empty()) {
                _currentPos = _stack.top();
                result = 2;         // need next step
            }
        }
        else {
            _stack.push(nextPos);
            markMaze(nextPos, MazeStrategy::kStateInStack);
            _currentPos = nextPos;
            result = 2;
        }
        
        return {_maze[_currentPos._row][_currentPos._col].pos, result};
    }
};
{% endhighlight %}

## 界面展示部分： MatrixExplore.h

{% highlight c++ %}
#pragma once

#include "cocos2d.h"
#include <vector>
#include <CCDirector.h>

class MazeStrategy;

class MatrixExplore : public cocos2d::Layer
{
public:
    MatrixExplore() : _mazeStrategy(nullptr), _playing(false), _robot(nullptr), _door(nullptr), _showState(false){}
    ~MatrixExplore() {
        CC_SAFE_DELETE(_mazeStrategy);
    }
    
    void onReset(cocos2d::Ref* target);
    void onBegin(cocos2d::Ref* target);
    void onShowState(cocos2d::Ref* target);
    void onEdit(cocos2d::Ref* target);
    
    void onMazeClicked(cocos2d::Ref* target);
    void tick(float dt);
    
    static cocos2d::Scene* createScene();

    virtual bool init();
    void reloadUI();
    void loadMazeMap();
    void reloadMazeStrategy();
    void refreshState();
    
    CREATE_FUNC(MatrixExplore);

private:

    MazeStrategy*       _mazeStrategy;
    bool                _playing;
    bool                _showState;
    cocos2d::Sprite*    _robot;
    cocos2d::Sprite*    _door;
};
{% endhighlight %}

**MatrixExplore.cpp**

{% highlight c++ %}
#include "MatrixExplore.h"
#include "StackMazeStrategy.h"
USING_NS_CC;

Scene* MatrixExplore::createScene()
{
    auto scene = Scene::create();
    auto layer = MatrixExplore::create();
    scene->addChild(layer);
    return scene;
}

void MatrixExplore::loadMazeMap() {
    auto& maze = _mazeStrategy->getMaze();
    int rows = _mazeStrategy->_rows;
    int columns = _mazeStrategy->_columns;
    
    Vector<MenuItem*> spriteBtns;
    for (size_t i=0; i<rows; ++i) {
        for (size_t j=0; j<columns; ++j) {
            std::string imgName = (maze[i][j].state == MazeStrategy::kStateWall) ? "stone.jpg" : "grass.jpg";
            auto btnSprite = MenuItemImage::create(imgName, imgName, CC_CALLBACK_1(MatrixExplore::onMazeClicked, this));
            btnSprite->setTag(i*100 + j);
            CCAssert(btnSprite, "fail to create bnt sprite");
            
            Size cts = btnSprite->getContentSize();
            btnSprite->setScaleX(_mazeStrategy->_cellWidth / cts.width);
            btnSprite->setScaleY(_mazeStrategy->_cellWidth / cts.height);
            btnSprite->setPosition(maze[i][j].pos);
            spriteBtns.pushBack(btnSprite);
            
            if (_showState) {
                std::string state = std::to_string(maze[i][j].state);
                auto label = Label::createWithTTF(state, "fonts/arial.ttf", 50);
                label->setColor(Color3B(255, 0, 0));
                label->setPosition(_mazeStrategy->_cellWidth / 2, _mazeStrategy->_cellWidth / 2);
                btnSprite->addChild(label);
            }
        }
    }
    auto mazeMenu = Menu::createWithArray(spriteBtns);
    addChild(mazeMenu);
    mazeMenu->setPosition(Vec2::ZERO);
    
    if (!_robot) {
        _robot = Sprite::create("HelloWorld.png");
        Size cts = _robot->getContentSize();
        _robot->setScaleX(_mazeStrategy->_cellWidth / cts.width);
        _robot->setScaleY(_mazeStrategy->_cellWidth / cts.height);
        _robot->setPosition(maze[0][0].pos);
        addChild(_robot);
        _robot->setLocalZOrder(100);
    }
    
    if (!_door) {
        _door = Sprite::create("door.jpg");
        Size cts = _door->getContentSize();
        _door->setScaleX(_mazeStrategy->_cellWidth / cts.width);
        _door->setScaleY(_mazeStrategy->_cellWidth / cts.height);
        _door->setPosition(maze[_mazeStrategy->_rows - 1][_mazeStrategy->_columns - 1].pos);
        addChild(_door);
        _door->setLocalZOrder(100);
    }
}

void MatrixExplore::refreshState() {

}

void MatrixExplore::reloadUI() {
    removeAllChildrenWithCleanup(true);
    _robot = nullptr;
    _door = nullptr;
    auto resetBtn = MenuItemLabel::create(Label::createWithTTF("Reset", "fonts/arial.ttf", 24),
                                          CC_CALLBACK_1(MatrixExplore::onReset, this));
    auto beginBtn = MenuItemLabel::create(Label::createWithTTF("Begin", "fonts/arial.ttf", 24),
                                          CC_CALLBACK_1(MatrixExplore::onBegin, this));
    auto showStateBtn = MenuItemLabel::create(Label::createWithTTF("State", "fonts/arial.ttf", 24),
                                          CC_CALLBACK_1(MatrixExplore::onShowState, this));
    auto editBtn = MenuItemLabel::create(Label::createWithTTF("Edit", "fonts/arial.ttf", 24),
                                              CC_CALLBACK_1(MatrixExplore::onEdit, this));

    beginBtn->setPositionY(resetBtn->getContentSize().height + 20);
    editBtn->setPositionY(beginBtn->getPositionY() + beginBtn->getContentSize().height + 20);
    showStateBtn->setPositionY(editBtn->getPositionY() + editBtn->getContentSize().height + 20);
    auto menu = Menu::create(resetBtn, beginBtn, editBtn, showStateBtn, NULL);
    menu->setPositionX(Director::getInstance()->getVisibleSize().width - resetBtn->getContentSize().width);
    menu->setPositionY(resetBtn->getContentSize().height + 20);
    addChild(menu);
    loadMazeMap();
}

void MatrixExplore::reloadMazeStrategy() {
    if (!_mazeStrategy) {
        _mazeStrategy = new StackMazeStrategy(10, 10);
    }
    _mazeStrategy->resetMaze(Director::getInstance()->getVisibleSize(),
                             Director::getInstance()->getVisibleOrigin());
}

bool MatrixExplore::init()
{
    if ( !Layer::init() ) {
        return false;
    }
    
    reloadMazeStrategy();
    reloadUI();
    
    return true;
}

void MatrixExplore::tick(float dt) {
    auto tickResult = _mazeStrategy->tickStep();
    switch (tickResult.result) {
        case 0:
            // fail
            MessageBox("no way anymore", "Maze Explore");
            unschedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick));
            break;
        case 1:
            // ok
            MessageBox("i'm out", "Maze Explore");
            unschedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick));
            break;
        case 2:
            // keep on.
            CCLOG("i'm going on...\n");
            break;
        default:
            break;
    }
    _robot->setPosition(tickResult.pos);
}

void MatrixExplore::onReset(Ref* target) {
    unschedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick));
    reloadMazeStrategy();
    reloadUI();
    _playing = false;
}

void MatrixExplore::onBegin(Ref* target) {
    _playing = true;
    schedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick), 0.3);
}

void MatrixExplore::onShowState(Ref* target) {
    if (_playing) {
//        unschedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick));
    }
    _showState = !_showState;
    reloadUI();
    if (_playing) {
//        schedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick), 0.3);
    }
}

void MatrixExplore::onEdit(Ref* target) {
    unschedule(CC_SCHEDULE_SELECTOR(MatrixExplore::tick));
    _mazeStrategy->clearState();
    _playing = false;
    reloadUI();
}

void MatrixExplore::onMazeClicked(Ref* target) {
    if (_playing) {
        MessageBox("use Eidt or Reset menu", "Maze Explore");
        return;
    }
    
    auto menuItemImage = dynamic_cast<MenuItemImage*>(target);
    CCAssert(menuItemImage, "clicked on nil");
    int tag = menuItemImage->getTag();
    int i = tag / 100;
    int j = tag % 100;
    CCLOG("edit (%d, %d)\n", i, j);
    auto& maze = _mazeStrategy->getMaze();
    if (maze[i][j].state == _mazeStrategy->kStateWall) {
        _mazeStrategy->updateMazeCell(i, j, MazeStrategy::kStatePass);
        menuItemImage->setNormalImage(Sprite::create("grass.jpg"));
    }
    else {
        _mazeStrategy->updateMazeCell(i, j, MazeStrategy::kStateWall);
        menuItemImage->setNormalImage(Sprite::create("stone.jpg"));
    }
    Size cts = menuItemImage->getContentSize();
    menuItemImage->setScaleX(_mazeStrategy->_cellWidth / cts.width);
    menuItemImage->setScaleY(_mazeStrategy->_cellWidth / cts.height);
}
{% endhighlight %}



---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



