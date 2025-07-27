# Pico-8 Animation System / Pico-8 动画系统

A modular, timeline-based animation system for Pico-8.

一个基于时间线的模块化 Pico-8 动画系统，支持组件级层绘制、类似 CSS 动画和灵活的演练时序管理。

obejcts CANNOT DO curve-movement
动画组件不能曲线运动

---

## Features / 功能特性

* Timeline scheduling / 时间线定时
* Per-object animation control / 单物体动画管理
* Easing functions / 精致的动画软化函数
* Layered rendering / 级层排序绘制
* Flexible drawing system / 灵活绘制系统

---

## Quick Preview / 快速预览

&#x20;

---

## Getting Started / 快速上手

```lua
-- Add this to _init()
crt(1, "rec", 32, 32, 8, 8, 8, 0.1) -- Creat a new obeject/新建一个动画组件
steps[1] = {
  {1, 20, 0, 0.1, ein, -1}  -- how it move/这个组件如何运动
}
tm = {"step"}  -- execute it on timeline/在时间线上执行这个动作
```

Then call in your game loop/然后在游戏循环里调用:

```lua
maincontrol_up() -- update 动画逻辑
drawcomponents() -- draw   绘制组件
```

---

## Object Format / 组件字段

```lua
crt(id, type, x, y, w, h, color, speed, layer, spr_id)
```

* `type`: "rec" or "spr“
* `type`: 长方形 或者 精灵
* `layer`: rendering order
* `layer`: 渲染的层级
* `spr_id`: sprite sheet index (for type="spr")
* `spr_id`：精灵贴图号码

---

## Timeline Format / 时间线格式

```lua
tm = {"step", 2, "step"} -- run step1, wait 2*30 frame, run step2
```

* `"step"` executes the next step in `steps[]`
* `"step"` 执行下一个step列表的动作
* `number` is wait time in seconds
* `number` 等待n*30帧

---

## Step Format / 动作步骤格式

```lua
steps = {
  {
    {id, dx, dy, speed, easing_fn, sfx_id}
  },
  ...
}
```

* `id`: object ID in `pkd[]`
* `id`: 在组件池里的id
* `dx`, `dy`: movement offset
* `dx`, `dy`: 组件的相对运动坐标
* `speed`: 0 \~ 1 (progress/frame)
* `speed`: 运动速度
* `easing_fn`: animation curve
* `easing_fn`: 动画速度曲线
* `sfx_id`: sfx id in Pico-8
* `sfx_id`: 音效号码

---

## Drawing / 绘制

```lua
drawcomponents()
```

Renders objects by layer. You can use `hide[id]=true` to hide specific ones.
按级层排序绘制，支持通过 `hide` 隐藏特定 ID 组件。

---
## Improvements can be made/有待提高的地方
* support text obejct type while creating the obejct instead of do it while rendering
* 在创建动画组件时直接支持字符种类的组件，而不是在渲染时手动改它
