/* To add class for nav items that have sub-navs */
$('.wy-menu-vertical li:has(li)').each(function() { 
  this.classList.add('has-list');
});
