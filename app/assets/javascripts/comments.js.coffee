# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $(document).on('click', '.add-comment-link', (e) ->
    e.preventDefault();
    com_id = $(this).data('commentableId')
    com_type= $(this).data('commentableType')
    $('form#add-comment-' + com_id + '-' + com_type).show())

  $('a.cancel-comment').on 'click', (e) ->
    e.preventDefault()
    $commentForm = $(this).closest('form')
    $commentForm.hide()

  add_comment = (comment) ->
    $commentable = $('#comments_' + comment.commentable_type + '_' + comment.commentable_id)
    $commentable.append ->
      HandlebarsTemplates['comments/comment'](comment) if !$('div#comment-' + comment.id).length

  $('form.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    add_comment(response)
    $('textarea#comment_content').val("")
    $(this).hide()
  .on 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)

    $form = $(this).closest('form')
    $errors = $form.children('.error_explanation')
    errorsHtml = HandlebarsTemplates['errors/errors'](response)

    if $errors.length
      $errors.html(errorsHtml)
    else
      $form.prepend(errorsHtml)
      $errors = $form.children('.error_explanation')

    $errors.stop().css( {opacity: 1} ).fadeOut 5000, ->
        $(this).remove()

  questionId = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/" + questionId + "/comments", (data, channel) ->
    comment = $.parseJSON(data["comment"])
    add_comment(comment)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)