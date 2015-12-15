---
layout: post
title: Script lua
---
{{page.title}}
---

## create lua engine

```lua
CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
```

## clear lua engine
