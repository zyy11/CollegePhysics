// 大学物理讲义交互脚本

document.addEventListener('DOMContentLoaded', function() {
  // 初始化答案折叠功能
  initAnswers();

  // 初始化目录高亮
  initSidebarHighlight();
});

function initAnswers() {
  // 找到所有包含【补充练习】的元素
  const elements = document.querySelectorAll('p, li, div');

  elements.forEach(el => {
    if (el.textContent.includes('【补充练习】')) {
      // 检查是否已经是 supplement 容器的子元素
      if (el.closest('.supplement')) return;

      // 找到这个元素的下一个兄弟元素，直到下一个章节标题
      let wrapper = document.createElement('div');
      wrapper.className = 'supplement';

      let answerDiv = document.createElement('div');
      answerDiv.className = 'answer collapsed';
      answerDiv.innerHTML = '<div class="answer-header"><span>答案</span><span class="toggle-icon">▼</span></div><div class="answer-content"></div>';

      const answerContent = answerDiv.querySelector('.answer-content');

      // 收集这个补充练习后面的内容直到下一个 h2/h3
      let current = el;
      while (current) {
        const next = current.nextElementSibling;
        if (!next) break;
        if (next.tagName === 'H2' || next.tagName === 'H3' || next.tagName === 'H4') break;
        if (next.textContent && next.textContent.includes('【补充练习】')) break;

        // 把内容移到答案容器
        answerContent.appendChild(next);
        current = next;
      }

      // 把原始元素也放入
      wrapper.appendChild(el);
      wrapper.appendChild(answerDiv);

      // 替换
      if (el.parentElement) {
        el.parentElement.replaceChild(wrapper, el);
      }

      // 添加点击事件
      answerDiv.querySelector('.answer-header').addEventListener('click', function() {
        answerDiv.classList.toggle('collapsed');
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