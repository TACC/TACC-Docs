/* To use TACC link style for links outside main content */
/* FAQ: The `.x-link` class is usually applied via @extend (pre-processing)
        using CSS pre-processing (not available on Docs, to reduce overhead);
        so we use it directly via JS to obscure usage of this internal tool */
const linksOutsideMainContent = document.querySelectorAll(`
  .wy-breadcrumbs-aside a,
  .wy-side-nav-search .cms-link
`);

[ ...linksOutsideMainContent ].forEach( link => {
  link.classList.add('x-link');
});
