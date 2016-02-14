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
    }).then(function(res) {
    }, function(res) {
    });
  },

  loadAll: function() {
  }
};

$(document).ready(function() {
  var promiseId = $('#promise-id').val();
  $('.add-comment').on('click', comments.create);
  comments.loadAll();
});
