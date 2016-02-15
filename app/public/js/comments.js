var promiseId = -1;

var comments = function() {
  var create = function() {
    var text = $('#comment-text').val();
    $('#comment-text').val('');
    ajax.postComment(text, promiseId, loadAll);
  };

  var parseComments = function(rawComments) {
    var data = JSON.parse(rawComments);
    comments = [];
    for (var i = 0; i < data.length; ++i) {
      comment = {};
      for (var key in data[i]) {
        var newKey = key.substring(1);
        comment[newKey] = data[i][key];
      }

      comments.push(comment);
    }

    return comments;
  }

  var renderComments = function(data) {
    ajax.getTemplate('comment.mst', function(template) {
      var rendered = Mustache.render(template, {comments: data});
      $("#comments-container").html(rendered);
    });
  };

  var loadAll = function() {
    ajax.getComments(promiseId, function(resp) {
      var parsed = parseComments(resp);
      renderComments(parsed);
    });
  };

  return {
    loadAll: loadAll,
    create: create
  };
}();

$(document).ready(function() {
  promiseId = $('#promise-id').text();
  $('.add-comment').on('click', comments.create);
  comments.loadAll();
});
