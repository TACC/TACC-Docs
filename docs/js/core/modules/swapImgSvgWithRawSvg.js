import 'https://cdn.jsdelivr.net/npm/@iconfu/svg-inject@1.2.3/dist/svg-inject.min.js';

/* To change an <img> loading a .svg to be that .svg inline (allows styling) */
SVGInject( document.querySelectorAll('.logo'), {
  onAllFinish: () => console.info('Image SVGs replaced with inline SVGs.')
});
