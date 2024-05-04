/* https://github.com/mkdocs/mkdocs/blob/1.0.4/mkdocs/themes/readthedocs/js/theme.js#L79-L105 */
/* All changes must start and end with comments " TACC: " and " /TACC " */

// The code below is a copy of @seanmadsen code from:
// https://github.com/mkdocs/mkdocs/issues/803
// This makes auto scroll work on page reload not just nav within the same page.
//
$(function() {
  /* TACC: Do not scroll if at an anchor */
  /* FAQ: Nav already (sometimes) scrolls to link of an anchor */
  if (window.location.hash) {
    return;
  }
  /* /TACC */

  $.fn.isFullyWithinViewport = function(){
      var viewport = {};
      viewport.top = $(window).scrollTop();
      viewport.bottom = viewport.top + $(window).height();
      var bounds = {};
      bounds.top = this.offset().top;
      bounds.bottom = bounds.top + this.outerHeight();
      return ( ! (
        (bounds.top <= viewport.top) ||
        (bounds.bottom >= viewport.bottom)
      ) );
  };
  if( $('li.toctree-l1.current').length && !$('li.toctree-l1.current').isFullyWithinViewport() ) {
    console.log(
      $('li.toctree-l1.current').offset().top -
      $('.wy-side-scroll').offset().top
    );
    /* TACC: Update to use '.wy-side-scroll' not '.wy-nav-side' */
    $('.wy-side-scroll')
    /* /TACC */
      .scrollTop(
        $('li.toctree-l1.current').offset().top -
        /* TACC: Update to use '.wy-side-scroll' not '.wy-nav-side' */
        $('.wy-side-scroll').offset().top -
        /* /TACC */
        60 /* TACC: HELP: What does this magic number represent? */
      );
  }
});
