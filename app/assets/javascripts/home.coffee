$ ->
  $('body.home #new_site').submit (event)->
    if $('#name').val() == ''
      $('#new_site .help-block').text("Please enter your site name")
      $("#new_site .form-group").addClass("has-error")
      event.preventDefault()
    else
      $("#site_domain").val($('#name').val() + ".kissr.com")
