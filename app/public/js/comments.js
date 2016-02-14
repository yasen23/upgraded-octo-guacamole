var promiseId = -1;

var comments = {
  create: function() {
    var text = $('#comment-text').val();

    $.ajax({
      url: '/comment',
      method: 'POST',
      body: {
        comment_text: text,
        promise_id: promiseId
      }
    }).then(function(respose) {}, function(error) {
      console.log(error);
    });
  },

  loadAll: function() {
    var renderComments = function(data) {
    };

    $.ajax({
      url: '/comments?promise_id=' + promiseId,
      method: 'GET',
    }).then(function(data) {
      renderComments(data);
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
