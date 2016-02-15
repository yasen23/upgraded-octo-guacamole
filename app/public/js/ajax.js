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

  var getRights = function(promiseId, callback) {
    $.ajax({
        url: '/promiseRights?promiseId=' + promiseId,
        method: 'GET'
      }).then(callback, logError);
  };

  return {
    postComment: postComment,
    getComments: getComments,
    getTemplate: getTemplate,
    getRights: getRights
  };
}();
