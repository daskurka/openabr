$(document).ready(function(){

  $("#create-button").click(function(){
    username = $("#username").val();
    password = $("#password").val();

    user = {
      name: username,
      password: password,
      type: 'user',
      roles: ['openabr-user']
    };

    options = {
      url: "/_users/org.couchdb.user:" + username,
      method: "PUT",
      dataType: 'json',
      data: JSON.stringify(user),
      contentType: 'application/json'
    };

    $.ajax(options)
      .success(function() { window.location.href = "."; })
      .fail(function(err) {
        alert("There was an error creating the user:\n" + err);
      });
  });

  $("#cancel-button").click(function(){
    window.location.href = ".";
  });
});
