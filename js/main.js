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
