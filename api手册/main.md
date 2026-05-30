# WoW Addon Dev — 魔兽世界泰坦时光服 (3.80.1) 插件开发

面向魔兽世界泰坦时光服 **3.80.1** 版本的插件创建、迁移与修复技能。API 体系向正式服对齐。

## 适用场景

| 场景 | 说明 |
|------|------|
| 从零创建插件 | 提供完整的入门模板和开发流程 |
| 迁移旧插件 | 正式服/怀旧服 API 迁移至 3.80.1 |
| 修复插件报错 | 废弃 API 识别与替代方案查找 |
| 学习插件开发 | 参考文档覆盖常用 API、事件 |

## 目录结构

```
api手册/
├── main.md                              # 本文件（入口文档）
├── SKILL.md                             # AI技能触发文件
├── 实践可用.md                           # 完整API接口手册（3.80.1版）
├── 最后一次变更.md                        # API变更记录
├── assets/
│   └── starter-addon/                   # 入门插件模板
├── references/                           # 参考文档
│   ├── wow-ui-source.md                  # 官方UI源码索引
│   ├── api-changes-3801.md               # API变更对照表
│   ├── api-quick-ref.md                  # 常用API速查
│   ├── events.md                         # 常用事件列表
│   └── secure-action-button.md           # SecureActionButton用法指南
└── 魔兽暴雪官方实现/                      # 暴雪官方UI源码
```

## 核心版本信息

- **目标版本**：泰坦时光服 3.80.1
- **TOC Interface**：`38001`
- **API 体系**：C_ 命名空间 + 全局函数 + FrameXML 事件驱动
- **关键特性**：BackdropTemplate、AnimationGroup、C_Timer、C_Map、C_Container、Settings API

## 快速开始

1. 创建 `.toc` 文件，设置 `## Interface: 38001`
2. 使用 `PLAYER_LOGIN` 事件初始化
3. 全局变量通过 `## SavedVariables` 声明持久化
4. UI 通过 `CreateFrame(type, name, parent, "BackdropTemplate")` + `SetBackdrop` 构建
5. 动画通过 `CreateAnimationGroup` + `CreateAnimation` 原生实现
6. 定时器使用 `C_Timer.After` / `C_Timer.NewTicker`

## 技能触发关键词

制作插件、编写插件、创建插件、适配插件、修复插件、WoW 插件开发、Lua API、时光服插件
