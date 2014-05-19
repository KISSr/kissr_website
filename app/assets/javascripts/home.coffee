$ ->
  $('#new_site').submit (event)->
    if $('#site_name').val() == ''
      $('#new_site .help-block').text("Please enter your site name")
      $("#new_site .form-group").addClass("has-error")
      event.preventDefault()
