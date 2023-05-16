/* FAQ: jQuery element selector is used cuz Firefox does not support :has() */

/* To add class for nav items that have sub-navs */
$('.wy-menu-vertical li:has(li)').each(function() { 
  this.classList.add('has-list');
});

/* To add icon to nav items that are external links */
document.querySelectorAll('.wy-menu-vertical a:not(.internal)').forEach( a => {
  const icon = document.createElement('i');

  icon.classList.add('fa', 'fa-external-link');
  a.prepend(icon);
});
