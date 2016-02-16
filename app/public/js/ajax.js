var ajax = function() {
  var logError = function(error) {
    console.log(error);
  };

  var postComment = function(text, promiseId, callback) {
    $.ajax({
      url: '/comment',
      method: 'POST',
      data: JSON.stringify({
        comment_text: text,
        promise_id: promiseId
      })
    }).then(callback, logError);
  };

  var getComments = function(promiseId, callback) {
    $.ajax({
      url: '/comments?promise_id=' + promiseId,
      method: 'GET',
    }).then(callback, logError);
  };

  var getTemplate = function(name, callback) {
    $.ajax({
        url: 'js/templates/' + name,
        method: 'GET'
      }).then(callback, logError);
  };

  var getPromise = function(promiseId, callback) {
    $.ajax({
      url: '/getPromise?promiseId=' + promiseId,
      method: 'GET'
    }).then(callback, logError);
  };

  var getRights = function(promiseId, callback) {
    $.ajax({
        url: '/promiseRights?promiseId=' + promiseId,
        method: 'GET'
      }).then(callback, logError);
  };

  var updatePromise = function(data, callback) {
    $.ajax({
      url: '/updatePromise',
      method: 'POST',
      data: JSON.stringify(data)
    }).then(callback, logError);
  };

  var editPromise = function(data, callback) {
    $.ajax({
      url: '/editPromise',
      method: 'POST',
      data: JSON.stringify(data)
    }).then(callback, logError);
  };

  var getUsers = function(callback) {
    $.ajax({
        url: '/getUsers',
        method: 'GET'
      }).then(callback, logError);
  };

  return {
    postComment: postComment,
    getComments: getComments,
    getTemplate: getTemplate,
    getRights: getRights,
    getPromise: getPromise,
    updatePromise: updatePromise,
    editPromise: editPromise,
    getUsers: getUsers
  };
}();
