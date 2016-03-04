---
layout: post
title: Script lua
---
{{page.title}}
---

## create lua engine

{% highlight lua %}
CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
{% endhighlight %}

## clear lua engine
