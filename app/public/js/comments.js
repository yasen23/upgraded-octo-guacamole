var promiseId = -1;

var comments = {
  create: function() {
    var text = $('#comment-text').val();
    $('#comment-text').val('');

    $.ajax({
      url: '/comment',
      method: 'POST',
      data: JSON.stringify({
        comment_text: text,
        promise_id: promiseId
      })
    }).then(function(respose) {}, function(error) {
      console.log(error);
    });
  },

  loadAll: function() {
    var renderComments = function(data) {
      $.ajax({
        url: 'js/templates/comment.mst',
        method: 'GET'
      }).then(function(mst) {
        var rendered = Mustache.render(mst, {comments: data});
        $("#comments-container").html(rendered);
      }, function(error) {
        console.log(error);
      });
    };

    $.ajax({
      url: '/comments?promise_id=' + promiseId,
      method: 'GET',
    }).then(function(resp) {
      var data = JSON.parse(resp);
      comments = [];
      for (var i = 0; i < data.length; ++i) {
        comment = {};
        for (var key in data[i]) {
          var newKey = key.substring(1);
          comment[newKey] = data[i][key];
        }

        comments.push(comment);
      }

      renderComments(comments);
    }, function(error) {
      console.log(error);
    });
  }
};

$(document).ready(function() {
  promiseId = $('#promise-id').text();
  $('.add-comment').on('click', comments.create);
  comments.loadAll();
});
