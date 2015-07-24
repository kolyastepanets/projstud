# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.add-comment-link').click (e) -> 
    e.preventDefault();
    com_id = $(this).data('commentableId')
    com_type= $(this).data('commentableType')
    $('form#add-comment-' + com_id + '-' + com_type).show()
    
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)