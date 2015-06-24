---
layout: post
title: AutoReleasePool
---
{{ page.title }}

##concepts
- *PoolManager*
singleton, holds a stack of AutoReleasePool*.
    - push(): push a new AutoReleasePool into top.
    - pop(): pop a AutoReleasePool, clear the pool. (when stack's size > 1), called every frame in CCDisplayLinkDirector::mainLoop().

- *AutoReleasePool*
holds an array of CCObject(Ref)*, clear() will release each obj.

##initialization&finalization
- PoolManager
created by sharedPoolManager(), first called in CCDirector's init()
finalized in CCDirector's destructor, by calling purgePoolManager()

- AutoReleasePool
created by PoolManager::push().
deleted by PoolManager::pop().

##main method
*AutoReleasePool*
    - addObject(): put obj into m_pManagedObjectArray

