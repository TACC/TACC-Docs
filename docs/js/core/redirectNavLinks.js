/* To change specific internal links to external links */
/* FAQ: The array should be an array of dictionaries of oldHref and newHref */
(window.NAV_REDIRECTS || []).forEach( dict => {
  const link = document.querySelector('[href*="' + dict.oldHref + '"]');
  const subnav = link.parentNode.getElementsByTagName('ul')[ 0 ];

  subnav.remove();
  link.href = dict.newHref;
});
