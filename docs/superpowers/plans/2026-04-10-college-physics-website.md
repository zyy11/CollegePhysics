# 大学物理讲义网页实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 LaTeX 讲义转换为静态网页，包含公式高亮、答案折叠展开、目录导航

**Architecture:**
- Python 脚本调用 pandoc 将 LaTeX 转换为 HTML
- CSS 实现样式和动画效果
- JavaScript 实现交互功能
- 纯静态输出，无需服务器端代码

**Tech Stack:** Python, pandoc, HTML, CSS, JavaScript

---

### Task 1: 创建项目目录结构和基础文件

**Files:**
- Create: `css/style.css`
- Create: `js/main.js`
- Create: `build.py`
- Create: `templates/page.html` (HTML 模板)

- [ ] **Step 1: 创建 css/style.css**

```css
/* 大学物理讲义网页样式 */

:root {
  --main-green: #16a085;
  --main-purple: #8e44ad;
  --bg-color: #fafafa;
  --text-color: #2c3e50;
  --sidebar-width: 260px;
}

/* 基础样式 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Noto Serif SC", "Source Han Serif SC", serif;
  background: var(--bg-color);
  color: var(--text-color);
  line-height: 1.8;
}

/* 侧边栏目录 */
.sidebar {
  position: fixed;
  left: 0;
  top: 0;
  width: var(--sidebar-width);
  height: 100vh;
  background: #fff;
  border-right: 1px solid #e0e0e0;
  overflow-y: auto;
  padding: 20px;
}

.sidebar h2 {
  font-size: 1.2em;
  margin-bottom: 15px;
  color: var(--text-color);
}

.sidebar ul {
  list-style: none;
}

.sidebar li {
  margin: 8px 0;
}

.sidebar a {
  text-decoration: none;
  color: var(--text-color);
  display: block;
  padding: 8px 12px;
  border-radius: 4px;
  transition: background 0.2s;
}

.sidebar a:hover {
  background: #f0f0f0;
}

.sidebar a.current {
  background: var(--main-green);
  color: #fff;
}

/* 主内容区 */
.main-content {
  margin-left: var(--sidebar-width);
  padding: 40px 60px;
  max-width: 900px;
}

/* 章节标题 */
.chapter {
  margin-bottom: 40px;
}

.chapter h1 {
  font-size: 2em;
  margin-bottom: 30px;
  padding-bottom: 10px;
  border-bottom: 3px solid var(--main-green);
}

.chapter.purple h1 {
  border-bottom-color: var(--main-purple);
}

/* 节标题 */
.section h2 {
  font-size: 1.5em;
  margin: 30px 0 20px;
}

.section h3 {
  font-size: 1.2em;
  margin: 20px 0 15px;
}

/* 公式高亮 - 力学章节 */
.formula {
  background: #e8f5e9;
  border-left: 4px solid var(--main-green);
  border-radius: 6px;
  padding: 12px 16px;
  margin: 15px 0;
  overflow-x: auto;
}

.chapter.purple .formula {
  background: #f3e5f5;
  border-left-color: var(--main-purple);
}

/* 例题 */
.example {
  background: #fff;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 20px;
  margin: 20px 0;
}

.example-title {
  font-weight: bold;
  color: var(--main-green);
  margin-bottom: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chapter.purple .example-title {
  color: var(--main-purple);
}

/* 答案容器 */
.answer {
  background: #f9f9f9;
  border-radius: 6px;
  padding: 15px;
  margin-top: 15px;
}

.answer-header {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  user-select: none;
}

.answer-header .toggle-icon {
  transition: transform 0.3s;
}

.answer.collapsed .answer-content {
  display: none;
}

.answer.collapsed .toggle-icon {
  transform: rotate(-90deg);
}

/* 补充练习 */
.supplement {
  background: #fffde7;
  border: 1px solid #fff59d;
  border-radius: 8px;
  padding: 15px;
  margin: 20px 0;
}

/* 响应式 */
@media (max-width: 768px) {
  .sidebar {
    display: none;
  }

  .main-content {
    margin-left: 0;
    padding: 20px;
  }
}
```

- [ ] **Step 2: 创建 js/main.js**

```javascript
// 大学物理讲义交互脚本

document.addEventListener('DOMContentLoaded', function() {
  // 初始化答案折叠功能
  initAnswers();

  // 初始化目录高亮
  initSidebarHighlight();

  // 移动端菜单
  initMobileMenu();
});

function initAnswers() {
  // 补充练习答案默认折叠
  const supplementAnswers = document.querySelectorAll('.supplement .answer');
  supplementAnswers.forEach(answer => {
    answer.classList.add('collapsed');
    const header = answer.querySelector('.answer-header');
    if (header) {
      header.addEventListener('click', () => {
        answer.classList.toggle('collapsed');
      });
    }
  });
}

function initSidebarHighlight() {
  const currentPath = window.location.pathname;
  const links = document.querySelectorAll('.sidebar a');
  links.forEach(link => {
    if (link.getAttribute('href') === currentPath ||
        link.getAttribute('href') === currentPath.split('/').pop()) {
      link.classList.add('current');
    }
  });
}

function initMobileMenu() {
  // 移动端菜单逻辑（如果需要）
}
```

- [ ] **Step 3: 创建 HTML 模板 templates/page.html**

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title$</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
</head>
<body>
  <nav class="sidebar">
    <h2>目录</h2>
    <ul>
      <li><a href="index.html">封面</a></li>
      <li><a href="ch1.html">第1章 质点运动学</a></li>
      <li><a href="ch2.html">第2章 运动定律</a></li>
      <li><a href="ch3.html">第3章 动量与角动量</a></li>
      <li><a href="ch4.html">第4章 功和能</a></li>
      <li><a href="ch5.html">第5章 机械振动</a></li>
      <li><a href="ch6.html">第6章 机械波</a></li>
    </ul>
  </nav>

  <main class="main-content $chapter_class$">
    $content$
  </main>

  <script src="js/main.js"></script>
</body>
</html>
```

- [ ] **Step 4: Commit**

```bash
git add css/style.css js/main.js templates/page.html
git commit -m "feat: 创建基础文件和模板"
```

---

### Task 2: 创建构建脚本 build.py

**Files:**
- Create: `build.py`

- [ ] **Step 1: 编写 build.py 脚本**

```python
#!/usr/bin/env python3
"""
大学物理讲义构建脚本
将 LaTeX 文件转换为静态 HTML 网页
"""

import os
import re
import subprocess
import sys
from pathlib import Path

# 配置
LATEX_DIR = Path("latex")
OUTPUT_DIR = Path(".")
TEMPLATE_FILE = Path("templates/page.html")

# 章节到文件的映射
CHAPTERS = [
    ("ch1", "ch1.tex", "第1章 质点运动学", ""),
    ("ch2", "ch2.tex", "第2章 运动定律", ""),
    ("ch3", "ch3.tex", "第3章 动量与角动量", ""),
    ("ch4", "ch4.tex", "第4章 功和能", ""),
    ("ch5", "ch5.tex", "第5章 机械振动", "purple"),
    ("ch6", "ch6.tex", "第6章 机械波", "purple"),
]

# 章节配色映射
CHAPTER_COLORS = {
    "ch1": "green",
    "ch2": "green",
    "ch3": "green",
    "ch4": "green",
    "ch5": "purple",
    "ch6": "purple",
}


def check_pandoc():
    """检查 pandoc 是否安装"""
    try:
        subprocess.run(["pandoc", "--version"], capture_output=True, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("错误: 未安装 pandoc，请先安装 https://pandoc.org/")
        return False


def read_template():
    """读取 HTML 模板"""
    if TEMPLATE_FILE.exists():
        return TEMPLATE_FILE.read_text(encoding="utf-8")
    # 默认模板
    return '''<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title$</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <nav class="sidebar">
    <h2>目录</h2>
    <ul>
      <li><a href="index.html">封面</a></li>
      <li><a href="ch1.html">第1章 质点运动学</a></li>
      <li><a href="ch2.html">第2章 运动定律</a></li>
      <li><a href="ch3.html">第3章 动量与角动量</a></li>
      <li><a href="ch4.html">第4章 功和能</a></li>
      <li><a href="ch5.html">第5章 机械振动</a></li>
      <li><a href="ch6.html">第6章 机械波</a></li>
    </ul>
  </nav>
  <main class="main-content $chapter_class$">
    $content$
  </main>
  <script src="js/main.js"></script>
</body>
</html>'''


def latex_to_html(latex_file, chapter_class):
    """使用 pandoc 将 LaTeX 转换为 HTML"""
    try:
        result = subprocess.run(
            [
                "pandoc",
                str(latex_file),
                "-f", "latex",
                "-t", "html",
                "--standalone",
                "--mathjax",
                "--wrap=none",
            ],
            capture_output=True,
            text=True,
            check=True,
        )
        content = result.stdout

        # 后处理：添加章节类名
        if chapter_class:
            content = re.sub(
                r'<main class="main-content"',
                f'<main class="main-content {chapter_class}"',
                content
            )

        # 处理公式样式
        content = process_formulas(content)

        # 处理例题
        content = process_examples(content)

        # 处理答案
        content = process_answers(content)

        return content

    except subprocess.CalledProcessError as e:
        print(f"转换 {latex_file} 失败: {e.stderr}")
        return None


def process_formulas(content):
    """处理公式样式 - 为公式添加高亮类"""
    # 匹配 LaTeX 的 formula 环境
    formula_pattern = r'<div class="formula">(.+?)</div>'
    content = re.sub(
        formula_pattern,
        r'<div class="formula">\1</div>',
        content,
        flags=re.DOTALL
    )
    return content


def process_examples(content):
    """处理例题样式"""
    # 匹配 example 环境
    example_pattern = r'<div class="example">'
    content = re.sub(
        example_pattern,
        '<div class="example"><div class="example-title">例题</div>',
        content
    )
    return content


def process_answers(content):
    """处理答案 - 添加折叠功能"""
    # 查找答案部分并添加折叠类
    # 这里需要根据 LaTeX 的实际输出调整
    return content


def generate_page(title, content, chapter_class=""):
    """生成完整 HTML 页面"""
    template = read_template()
    template = template.replace("$title$", title)
    template = template.replace("$content$", content or "")
    template = template.replace("$chapter_class$", chapter_class)
    return template


def build():
    """构建所有页面"""
    if not check_pandoc():
        sys.exit(1)

    print("开始构建网页...")

    # 确保输出目录存在
    OUTPUT_DIR.mkdir(exist_ok=True)

    # 转换每个章节
    for chapter_id, filename, title, chapter_class in CHAPTERS:
        latex_path = LATEX_DIR / filename
        if not latex_path.exists():
            print(f"警告: {latex_path} 不存在，跳过")
            continue

        print(f"转换 {filename}...")

        # LaTeX 转 HTML
        content = latex_to_html(latex_path, chapter_class)
        if content is None:
            continue

        # 生成完整页面
        html_content = generate_page(title, content, chapter_class)

        # 写入文件
        output_path = OUTPUT_DIR / f"{chapter_id}.html"
        output_path.write_text(html_content, encoding="utf-8")
        print(f"生成 {output_path}")

    print("构建完成!")


if __name__ == "__main__":
    build()
```

- [ ] **Step 2: Commit**

```bash
git add build.py
git commit -m "feat: 添加构建脚本 build.py"
```

---

### Task 3: 测试和优化

**Files:**
- Modify: `build.py`
- Modify: `css/style.css`
- Modify: `js/main.js`

- [ ] **Step 1: 运行构建脚本测试**

```bash
python build.py
```

- [ ] **Step 2: 检查输出并根据需要调整样式和脚本**

(根据实际输出进行调整)

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "feat: 完成网页构建功能"
```

---

### Task 4: 创建使用说明

**Files:**
- Create: `README.md`

- [ ] **Step 1: 编写 README**

```markdown
# 大学物理讲义网页

将 LaTeX 讲义转换为静态网页的构建系统。

## 快速开始

### 前置要求

1. 安装 [pandoc](https://pandoc.org/installing.html)
2. 安装 Python 3.7+

### 构建网页

```bash
python build.py
```

### 部署

构建完成后，将生成的 HTML 文件和 css/, js/ 目录上传到服务器：

```bash
# 通过 git
git add -A
git commit -m "Update website"
git push server main

# 或手动上传
scp -r *.html css js user@server:/var/www/html/
```

## 目录结构

```
.
├── build.py           # 构建脚本
├── css/
│   └── style.css      # 样式文件
├── js/
│   └── main.js        # 交互脚本
├── templates/
│   └── page.html      # HTML 模板
├── latex/             # LaTeX 源文件
└── *.html             # 生成的网页
```

## 功能

- 公式高亮显示
- 例题答案默认展开
- 补充练习答案默认折叠
- 侧边栏目录导航
- 响应式设计
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: 添加使用说明"
```
