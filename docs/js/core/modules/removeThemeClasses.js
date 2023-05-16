/* To remove "section" class from main content inner wrapper */
/* FAQ: The "section" class conflicts with TACC/Core-Styles o-section pattern */
document
  .querySelector('[role="main"] > div.section[itemprop]')
  .classList.remove('section');
