# TamerTimer Changelog

## v1.1 (2025-12-25)

### English Version
#### ✨ UI Overhaul
- **Minimalist Design**: Significantly increased transparency for the main window and title bar for a modern look.
- **Unified Style**: Redesigned "Add" and "Close" buttons with a flat, coordinated style.
- **Visual Enhancements**:
  - **Enhanced Progress Bar**: Doubled height (16px) for better visibility.
  - **Floating Timer**: Timer text is now centered on the progress bar, removing the redundant status dot.
  - **Larger Font**: Increased font size for timer display to ensure readability.

#### 🚀 New Features
- **Smart List Mode**:
  - **Auto Mode**: With <=9 pets, window height adapts automatically. No scrollbar.
  - **Extended Mode**: With >9 pets, automatically switches to a fixed-height (800px) scrollable list supporting up to 20 pets.
- **Streamlined Operations**:
  - Replaced context menus with intuitive icon buttons for all actions (Set Time, Note, Delete).
  - One-click adding in "Add Pet" mode.

#### 🐛 Bug Fixes
- Fixed an issue where "Add Mode" would incorrectly add all pets at once.
- Fixed UI loading issues (black screen or incorrect render order).
- Fixed item overlapping issues during scrolling.
- Code cleanup and optimization.

---

### 中文版 (Chinese Version)
#### ✨ UI 重构与美化
- **极简设计**：大幅提升了主窗口和标题栏的透明度，打造更现代、干扰更少的视觉体验。
- **统一风格**：重新设计了"添加"和"关闭"按钮，采用扁平化色块风格，视觉更加统一。
- **信息优化**：
  - **进度条增强**：高度翻倍（16px），更加醒目清晰。
  - **悬浮时间**：时间文本现在居中悬浮在进度条上方，移除了冗余的状态点，提升了信息读取效率。
  - **字体升级**：增大了时间显示字体，确保在各种分辨率下都清晰可见。

#### 🚀 新功能特性
- **智能列表模式**：
  - **自动模式**：追踪 ≤9 个宠物时，窗口高度自动适应内容，无滚动条，保持界面清爽。
  - **扩展模式**：追踪 >9 个宠物时，自动切换为固定高度（800px）的滚动列表，支持追踪全部20个宠物。
- **操作便捷化**：
  - 移除了繁琐的右键菜单，所有操作（设置时间、备注、删除、重置）现在都通过直观的图标按钮直接完成。
  - 即使在未追踪列表（添加模式）中，也可以直接点击添加，无需额外确认。

#### 🐛 问题修复
- 修复了添加模式下可能会错误地一次性添加所有宠物的问题。
- 修复了UI加载时可能出现的黑屏或渲染顺序错误。
- 修复了列表滚动时可能导致的条目重叠或遮挡问题。
- 优化了内存占用，清理了冗余的代码逻辑。

---

## v1.0.0 - Initial Release

Welcome to the first release of TamerTimer! / 欢迎使用 TamerTimer 初始版本！

### New Features / 新功能
*   **Auto Timer**: Automatically detects rare pet kills via combat log and starts a respawn timer.
    *   **自动计时**：通过战斗日志自动检测稀有宠物击杀并开始刷新倒计时。
*   **Status Tracking**: Visualizes respawn status (Countdown / Camping).
    *   **状态追踪**：可视化显示刷新状态（倒计时 / 蹲守中）。
*   **Bilingual UI**: Fully supports English and Chinese.
    *   **双语界面**：完美支持中英双语。
*   **Minimap Button**: Quick access via minimap button or `/tamt` command.
    *   **快捷入口**：支持小地图按钮或 `/tamt` 命令快速打开。

Happy Hunting! / 祝狩猎愉快！
