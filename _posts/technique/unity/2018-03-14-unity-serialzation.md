---
layout: post
title: "聊聊unity序列化"
highlighter_style: solarizeddark
category: [unity]
tags: [unity]
description: ""
published: true
---

# 前言

序列化/反序列化是unity工作的核心，本文聊聊unity在什么情况下会进行序列化/反序列化操作。

<!--more-->

# unity 编辑器下常见的序列化情形

## 1. 编辑prefab

从编辑一个值，到自动保存prefab，会调用4次反序列化。
调用路径分别是：

(省略了UnityEditor命名空间前缀)

  <!-- at Dog.OnAfterDeserialize () [0x00001] in <9a12e3c18a3143c783def3ed04df2917>:0 
  at UnityEditor.SerializedObject.ApplyModifiedProperties () [0x00000] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.GenericInspector.OnOptimizedInspectorGUI (UnityEngine.Rect contentRect) [0x00147] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.InspectorWindow.DoOnInspectorGUI (System.Boolean rebuildOptimizedGUIBlock, UnityEditor.Editor editor, System.Boolean wasVisible, UnityEngine.Rect& contentRect) [0x00097] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.InspectorWindow.DrawEditor (UnityEditor.Editor[] editors, System.Int32 editorIndex, System.Boolean rebuildOptimizedGUIBlock, System.Boolean& showImportedObjectBarNext, UnityEngine.Rect& importedObjectBarRect) [0x0024a] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.InspectorWindow.DrawEditors (UnityEditor.Editor[] editors) [0x00197] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.InspectorWindow.OnGUI () [0x00063] in <c05656eb351c456098342c96326d36df>:0 
  at System.Reflection.MonoMethod.InternalInvoke (System.Object obj, System.Object[] parameters, System.Exception& exc) [0x00000] in <e1319b7195c343e79b385cd3aa43f5dc>:0 
  at System.Reflection.MonoMethod.Invoke (System.Object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, System.Object[] parameters, System.Globalization.CultureInfo culture) [0x00000] in <e1319b7195c343e79b385cd3aa43f5dc>:0 
  at System.Reflection.MethodBase.Invoke (System.Object obj, System.Object[] parameters) [0x00000] in <e1319b7195c343e79b385cd3aa43f5dc>:0 
  at UnityEditor.HostView.Invoke (System.String methodName, System.Object obj) [0x00015] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.HostView.Invoke (System.String methodName) [0x00009] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.HostView.InvokeOnGUI (UnityEngine.Rect onGUIPosition, UnityEngine.Rect viewRect) [0x000e9] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.DockArea.DrawView (UnityEngine.Rect viewRect, UnityEngine.Rect dockAreaRect, System.Boolean customBorder, System.Boolean floatingWindow, System.Boolean isBottomTab) [0x0008d] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.DockArea.OldOnGUI () [0x001d1] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEngine.Experimental.UIElements.IMGUIContainer.DoOnGUI (UnityEngine.Event evt, UnityEngine.Matrix4x4 worldTransform, UnityEngine.Rect clippingRect, System.Boolean isComputingLayout) [0x001ca] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.IMGUIContainer.HandleIMGUIEvent (UnityEngine.Event e, UnityEngine.Matrix4x4 worldTransform, UnityEngine.Rect clippingRect) [0x00067] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.IMGUIContainer.HandleIMGUIEvent (UnityEngine.Event e) [0x00010] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.EventDispatcher.ProcessEvent (UnityEngine.Experimental.UIElements.EventBase evt, UnityEngine.Experimental.UIElements.IPanel panel) [0x002e0] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.EventDispatcher.Dispatch (UnityEngine.Experimental.UIElements.EventBase evt, UnityEngine.Experimental.UIElements.IPanel panel, UnityEngine.Experimental.UIElements.DispatchMode dispatchMode) [0x00048] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.BaseVisualElementPanel.SendEvent (UnityEngine.Experimental.UIElements.EventBase e, UnityEngine.Experimental.UIElements.DispatchMode dispatchMode) [0x00024] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.UIElementsUtility.DoDispatch (UnityEngine.Experimental.UIElements.BaseVisualElementPanel panel) [0x00093] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.Experimental.UIElements.UIElementsUtility.ProcessEvent (System.Int32 instanceID, System.IntPtr nativeEventPtr) [0x00030] in <cd0ec58563fa4a1587d9adb9058d9e90>:0 
  at UnityEngine.GUIUtility.ProcessEvent (System.Int32 instanceID, System.IntPtr nativeEventPtr) [0x00012] in <242531b3d7d7425286fa13a3e999eea8>:0  @@@12:34:17:144
UnityEngine.Debug:LogError(Object)
Utils.TestUtil:P(Object) (at Assets/Scripts/Utils/TestUtil.cs:15)
Utils.TestUtil:Pln(Object) (at Assets/Scripts/Utils/TestUtil.cs:19)
Dog:OnAfterDeserialize() (at Assets/Scripts/SerializeTest.cs:55)
UnityEngine.GUIUtility:ProcessEvent(Int32, IntPtr)  -->

第1次是在绘制Inspector窗口的时候

- InspectorWindow.OnGUI -> .InspectorWindow.DrawEditors -> ... -> InspectorWindow.DoOnInspectorGUI -> SerializedObject.ApplyModifiedProperties





  <!-- at Dog.OnAfterDeserialize () [0x00001] in <9a12e3c18a3143c783def3ed04df2917>:0  
  at UnityEditor.PrefabUtility.SavePrefabAsset_Internal (UnityEngine.GameObject root, System.Boolean& success) [0x00000] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.PrefabUtility.SavePrefabAsset (UnityEngine.GameObject asset, System.Boolean& savedSuccessfully) [0x0008b] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.PrefabImporterEditor.SaveDirtyPrefabAssets () [0x0008e] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.PrefabImporterEditor.Update () [0x0003c] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.EditorApplication.Internal_CallUpdateFunctions () [0x00010] in <c05656eb351c456098342c96326d36df>:0  @@@12:34:17:557
UnityEngine.Debug:LogError(Object)
Utils.TestUtil:P(Object) (at Assets/Scripts/Utils/TestUtil.cs:15)
Utils.TestUtil:Pln(Object) (at Assets/Scripts/Utils/TestUtil.cs:19)
Dog:OnAfterDeserialize() (at Assets/Scripts/SerializeTest.cs:55)
UnityEditor.EditorApplication:Internal_CallUpdateFunctions() -->

第2次是在自动保存prefab的时候

- `EditorApplication.Internal_CallUpdateFunctions` -> PrefabImporterEditor.Update -> PrefabImporterEditor.SaveDirtyPrefabAssets -> PrefabUtility.SavePrefabAsset

第3, 4次都是在保存prefab后的收尾工作时

- `EditorApplication.Internal_CallUpdateFunctions` -> PrefabImporterEditor.Update -> PrefabImporterEditor.SaveDirtyPrefabAssets -> AssetDatabase.StopAssetEditing 

  <!-- at Dog.OnAfterDeserialize () [0x00001] in <9a12e3c18a3143c783def3ed04df2917>:0
  at UnityEditor.AssetDatabase.StopAssetEditing () [0x00000] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.PrefabImporterEditor.SaveDirtyPrefabAssets () [0x000ef] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.PrefabImporterEditor.Update () [0x0003c] in <c05656eb351c456098342c96326d36df>:0 
  at UnityEditor.EditorApplication.Internal_CallUpdateFunctions () [0x00010] in <c05656eb351c456098342c96326d36df>:0  @@@13:58:21:996
UnityEngine.Debug:LogError(Object)
Utils.TestUtil:P(Object) (at Assets/Scripts/Utils/TestUtil.cs:15)
Utils.TestUtil:Pln(Object) (at Assets/Scripts/Utils/TestUtil.cs:19)
Dog:OnAfterDeserialize() (at Assets/Scripts/SerializeTest.cs:55)
UnityEditor.EditorApplication:Internal_CallUpdateFunctions()   -->


## 2. Inspector里显示Object的时候


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**


