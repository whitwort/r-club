// document.ready
$(function() {

  // Update code block classes to be all R
  $('p > code').addClass('r inline')
  $('code').addClass( function(i, currentClass) {
    
    if (currentClass !== 'r') {
      return('r output')
    }
    
  })
  
  
  hljs.initHighlightingOnLoad()

});