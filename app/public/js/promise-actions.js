$(document).ready(function() {
  var UPDATE = '<a href="#" class="update action">Update</a>';
  var EDIT = '<a href="#" class="edit action">Edit</a>';

  var editPromise = function(event) {
    var id = $(event.target.parentNode).data('id');
  };

  var updatePromise = function(event) {
    var id = $(event.target.parentNode).data('id');

  };

  var addActions = function(data) {
    rights = JSON.parse(data);
    var html = '';
    if (rights['@edit'] == true) {
      html += EDIT;
    }

    if (rights['@update'] == true) {
      html += UPDATE;
    }

    if (html == '') {
      html = 'N/A';
    }

    $('.promise-' + rights['@promise_id']).html(html);
    $('.promise-' + rights['@promise_id'] + ' .edit').on('click', editPromise);
    $('.promise-' + rights['@promise_id'] + ' .update').on('click', updatePromise);
  };

  $('.actions').each(function(i, obj) {
    var promiseId = parseInt($(obj).text().trim());
    ajax.getRights(promiseId, addActions);
  });
});
