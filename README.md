# Pico-8 Animation System / Pico-8 动画系统

A modular, timeline-based animation system for Pico-8.

一个基于时间线的模块化 Pico-8 动画系统，支持组件级层绘制、类似 CSS 动画和灵活的演练时序管理。

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
crt(1, "rec", 32, 32, 8, 8, 8, 0.1)
steps[1] = {
  {1, 20, 0, 0.1, ein, -1}  -- move right
}
tm = {"step"}
```

Then call in your game loop:

```lua
maincontrol_up() -- update timeline
_draw()          -- call drawcomponents() inside
```

然后在游戏循环里调用:

```lua
maincontrol_up() -- 动画逻辑
_draw()          -- 绘制组件
```

---

## Timeline Format / 时间线格式

```lua
tm = {"step", 2, "step"} -- run step1, wait 2s, run step2
```

* `"step"` executes the next step in `steps[]`
* `number` is wait time in seconds

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
* `dx`, `dy`: movement offset
* `speed`: 0 \~ 1 (progress/frame)
* `easing_fn`: animation curve
* `sfx_id`: -1 for none

---

## Object Format / 组件字段

```lua
crt(id, type, x, y, w, h, color, speed, layer, spr_id)
```

* `type`: "rec" or "spr"
* `layer`: rendering order
* `spr_id`: sprite sheet index (for type="spr")

---

## Drawing / 绘制

```lua
drawcomponents()
```

Renders objects by layer. You can use `hide[id]=true` to hide specific ones.

按级层排序绘制，支持通过 `hide` 隐藏特定 ID 组件。

---

## License / 协议

MIT License
