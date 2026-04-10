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
                "--mathjax",
                "--wrap=none",
            ],
            capture_output=True,
            encoding="utf-8",
            errors="replace",
        )
        content = result.stdout or ""

        if not content:
            print(f"警告: {latex_file} 转换结果为空")
            return ""

        # 提取 body 内容
        if "<body>" in content:
            body_match = re.search(r'<body>(.*?)</body>', content, re.DOTALL)
            if body_match:
                content = body_match.group(1)

        # 处理公式样式
        content = process_formulas(content)

        # 处理例题
        content = process_examples(content)

        # 处理答案
        content = process_answers(content)

        return content

    except subprocess.CalledProcessError as e:
        print(f"转换 {latex_file} 失败: {e.stderr}")
        return ""


def process_formulas(content):
    """处理公式样式 - 为公式添加高亮类"""
    if not content:
        return content
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
    if not content:
        return content
    example_pattern = r'<div class="example">'
    content = re.sub(
        example_pattern,
        '<div class="example"><div class="example-title">例题</div>',
        content
    )
    return content


def process_answers(content):
    """处理答案 - 添加折叠功能"""
    if not content:
        return content
    return content


def generate_page(title, content, chapter_class=""):
    """生成完整 HTML 页面"""
    template = read_template()
    template = template.replace("$title$", title)
    template = template.replace("$content$", content or "")
    template = template.replace("$chapter_class$", chapter_class or "")
    return template


def build():
    """构建所有页面"""
    if not check_pandoc():
        sys.exit(1)

    print("开始构建网页...")

    # 转换每个章节
    for chapter_id, filename, title, chapter_class in CHAPTERS:
        latex_path = LATEX_DIR / filename
        if not latex_path.exists():
            print(f"警告: {latex_path} 不存在，跳过")
            continue

        print(f"转换 {filename}...")

        # LaTeX 转 HTML
        content = latex_to_html(latex_path, chapter_class)
        if not content:
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