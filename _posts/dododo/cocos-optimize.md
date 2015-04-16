---
layout: post
title: Cocos Optimize
---
{{ page.title }}

## questions.
*baopeng*
- scrollview facade.
- autorelease pool.
- shader gray.

*cocos*
- dragon bone and spine

## Performance.
1. ccscrollview
    - 修改CCScrollView的visit方法，使其不在显示区的子item不再visit,从而降低draw次数
    - scrollview facade.
2. memory leak and texture release.
3. old codes are in hurry, fix lots of problems. 
    - table reader,
    - listener removed in destructor
    - fnt file reload.
    - bugs
    - code refactor, lua common, cpp template.
4. removeunusedtexture and spriteframe.
    - CCSpriteFrameCache.cpp 's update() every frame, check elems to remove.
    - CCTextureCache.cpp's update every frame, ...


## Experience.
1. net work.
2. operation notification.


##shader
*CCShaderCache.cpp*

##problems
- 同步fix: CCLOG传入参数大小超过上限崩溃（貌似cocos升级后win32无此问题） add: GameMaths::dumpString 安全输出string


## 优化方向
- 一、引擎底层优化：cocos2dx版本选择

- 二、纹理优化:png格式，一个像素4字节
1.二的幂次方拼图：由于底层的opengl是按二的幂次方申请内存的，然后再吧这个图片存在内存中，如果
一个480*480*4的图片要存入内存，那么它的实际占用内存是512*512*4。所以为节约内存，我们的图片大小
最好按二的幂次方制作（拼图法）。
2.色深优化：颜色模式的转换等
每个像素的深度由：A8R8G8B8转换为A1R5G5B5或者ARGB4444等，这样一个像素占的大小就由32位变成了16位
3.图片压缩格式：在IOS上的PowerVR显示芯片可以直接读取PVR格式的图片，效率更高！PVR格式其实就是A1R5G5B5模式
4.骨骼动画：cocos2dx2.03已经开始支持骨骼动画，cososbuilder2.1及之后的版本都可支持骨骼动画编辑。
RGB565图片常用于背景图和用户控件图。

- 三、渲染优化
1.精灵表方式：CCSpriteBatchNode

- 四、资源缓存
1.精灵帧缓存：CCSpriteFrameCache
2.纹理缓存：CCTextureCache
将不用的资源移出缓存，减少手机负荷

- 五、内存池：在游戏启动时申请一块大的内存，以后所有的资源占用空间都从该内存池中分配。避免了频繁申请和释放资源引起的
内存碎片化。内存池中的资源释放时只需要做个标记，后来加载的资源直接覆盖这片内存即可。

## 优化2
- 关于图片占用的材质内存，我觉得还有好几种优化手段：
1、对于背景图，因为不需要考虑透明问题。载入材质时可以使用 RGB565 格式（5位红色，6位绿色，5位蓝色），每一个像素消耗的内存是16bit = 2byte。比默认的 RGBA8888 消耗的内存少一半。
2、大尺寸的图可以适当缩小，显示时拉伸放大。比如960x640的图可以缩小为768x512，消耗的内存减少一半。
3、有些sprite不需要那么多的色彩，可以用 RGBA4444 格式载入，一个像素也只消耗2byte，减少一半。可以用 TexturePacker 这样的工具处理原始 32bitpng 图片，生成 RGBA4444 格式的材质文件。
4、多个小图合并到一起，做成 sprite sheet，可以显著降低内存使用，性能也会好一点。
5、超大背景图裁剪成多个小块，需要显示哪个区域才载入对应的块。程序上复杂不少，但总比内存不足崩溃掉好。
以上优化方法，我个人实践下来效果还是很明显的。
 

- 1。OpenGL一般都用2的N次方贴图尺寸，所以制作贴图时使它尽量接近2的N次方值，比如128＊128。如果有个切片组成的贴图尺寸是130＊100，那就尝试重新排布切片，使它控制在128＊128以内，这样能减少一半内存。
2。可以使用小图放大来贴，但我建议是对于背景图这样，对清晰度要求不高时，将尺寸按整数倍缩小贴图，然后贴图时采用Nearest临近差值算法，这样效果可以接受，效率又高。
3。将切片合成贴图时，要注意将使用时机和频率相当的切片放在一起，这样可以做到当前加载进内存的贴图，都是使用频率最高的。而当前不用的贴图要及时释放掉。游戏玩家一般都可以接受等待进度条加载一些东西。
4。游戏前期可以用模拟器测试，后期一定要真机＋Instruments测试，Xcode的Instruments功能很强，可以检测Leak，OpenGL优化建议，Allocation等。
5。游戏注意避免在logic循环或者render循环中反复分配内存，造成恶性增长。
6。PNG要用PS针对Web压缩一下，可以缩小文件尺寸，虽然不会减少运行时内存分配，但可以减少贴图加载的IO时间

##walzer optimize
- hotspots.
