$(function(){
  var checkAvailability = function (event){
    $.ajax({
      url: "/domains",
      data: {domain: event.target.value + ".kissr.com"},
    })
    .complete(function(response){
      if(response.status == 200) {
        $('#new_site .help-block').text("This subdomain is already taken. Please try another.")
        $("#new_site .form-group").addClass("has-error")
      } else {
        $("#new_site .form-group").addClass("has-success")
      }
    });
  }
  $('body.home #new_site').on('keyup', function(){
    $('#new_site .help-block').text("")
    $("#new_site .form-group").removeClass("has-error")
    $("#new_site .form-group").removeClass("has-success")
  });
  $('body.home #new_site').on('keyup', _.debounce(checkAvailability, 300, {leading: false}));
  $('body.home #new_site').on('submit', function(event){
    if($('#name').val() == ''){
      $('#new_site .help-block').text("Please enter your site name")
      $("#new_site .form-group").addClass("has-error")
      event.preventDefault()
    } else {
      $("#site_domain").val($('#name').val() + ".kissr.com")
    }
  });
});
