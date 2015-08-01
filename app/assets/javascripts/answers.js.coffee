# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) -> 
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  add_answer = (answer) ->

    if gon.current_user
      answer.isSigned = gon.current_user;
      answer.isAnswerAuthor = gon.current_user == answer.user_id;
      answer.isQuestionAuthor = gon.question_author == gon.current_user;
    
    answer.attachments = data.attachments
    for attach in answer.attachments
      attach.name = attach.file.url.split('/').slice(-1)[0]

    $('.answers').append ->
      HandlebarsTemplates['answers/answer'](answer)

    $newComment = $('#new_comment').clone()
    .attr('action',"/answers/#{answer.id}/comments")
    $("#answer-#{answer.id}").append($newComment)

    $editForm = $('#new_answer').clone();
    $editForm.removeClass('new_answer').addClass('edit_answer')
    .removeAttr('data-type')
    .removeAttr('enctype')
    .attr('action',"/answers/#{answer.id}")
    .attr('id',"edit-answer-#{answer.id}")
    .html('<input name="utf8" type="hidden" value="✓">' +
        '<input type="hidden" name="_method" value="patch">' +
        '<p><label for="answer_body">Edit Answer</label></p><p><textarea name="answer[body]" ' +
        'id="answer_body">' + 
        answer.body + 
        '</textarea></p><p><input type="submit" name="commit" value="Save"></p></form>')
    $($editForm).insertAfter("#answer-#{answer.id} .edit-answer-link")

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    add_answer(answer) if !$("#answer-#{answer.id}").length
    $("form.new_answer #answer_body").val("");

  questionId = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    answer = $.parseJSON(data["answer"])
    add_answer(answer)
    $("form.new_answer #answer_body").val("");

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)