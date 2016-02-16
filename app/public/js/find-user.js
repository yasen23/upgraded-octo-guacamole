var users = [];

$(document).ready(function() {
  var viewUserPage = function(event) {
    if (event.which != 13) {
      return;
    }

    var username = $(event.target).val();
    for (var i in users) {
      if (users[i]['@username'] === username) {
        window.location = '/show?id=' + users[i]['@id'];
      }
    }
  };

  var createSuggestions = function(users) {
    var suggestions = [];
    $.each(users, function(i, user) {
      suggestions.push(user['@username'].toLowerCase());
    });

    var options = '';
    for (var i in suggestions) {
      options += '<option value="' + suggestions[i] + '">';
    }

    $('#users').html(options);
    $('#user-search').on('keyup', viewUserPage);
  };

  ajax.getUsers(function(data) {
    users = JSON.parse(data);
    createSuggestions(users);
  });
});
