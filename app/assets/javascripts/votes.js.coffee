ready = ->

  $(document).on('ajax:success', '.link-to-vote', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    question_id = '#' + vote.type.toLowerCase() + '-vote-' + vote.votable_id
    $(question_id).find('.total-rating').html(vote.rating)
    $(question_id).find('.like').hide()
    $(question_id).find('.dislike').hide()
    $(question_id).find('.cancel-vote').show()
    console.log(xhr.responseText))

  $(document).on('ajax:success', '.link-to-cancel-vote', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    question_id = '#' + vote.type.toLowerCase() + '-vote-' + vote.votable_id
    $(question_id).find('.total-rating').html(vote.rating)
    $(question_id).find('.like').show()
    $(question_id).find('.dislike').show()
    $(question_id).find('.cancel-vote').hide())

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)