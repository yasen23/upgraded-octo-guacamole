$(document).ready(function() {
  var UPDATE = '<a href="#" class="update action"><img id="update-icon" src="images/update-icon.png" /></a>';
  var EDIT = '<a href="#" class="edit action"><img id="edit-icon" src="images/edit-icon-new.png" /></a>';

  var updateRow = function(promise) {
    console.log(promise);
    var promiseRow = '#promise-row-' + promise['@id'];
    $(promiseRow + ' .p-status').data('status', promise['@status']);
    $(promiseRow + ' .p-title').text(promise['@title']);
    $(promiseRow + ' .p-body').text(promise['@body']);
    $(promiseRow + ' .p-ref').attr('href', promise['@completed_reference']);

    promiseStatus.renderPromises();
  };

  var closePopup = function() {
    $('.popup').remove();
    $('.black-overlay').remove();
  };

  var completeUpdate = function(promise) {
    updateRow(JSON.parse(promise));
    closePopup();
  };

  var renderUpdatePopup = function(promise) {
	  ajax.getTemplate('update-popup.mst', function(template) {
      var rendered = Mustache.render(template, {
        title: promise['@title'],
        completedReference: promise['@completed_reference']
      });

      $('body').append(rendered);

      var selectedId = 'o-' + promise['@status'];
      $('#status option').filter(function() {
        return this.id === selectedId;
      }).prop('selected', true);

      $('#update').on('click', function() {
        var status = $('#status').val();
        var ref = $('#completed-reference').val();
        ajax.updatePromise({
          status: status,
          completedReference: ref,
          promiseId: promise['@id']
        }, completeUpdate);
      });

      $('#cancel').on('click', closePopup);
		});
  };

  var editPromise = function(event) {
    var id = $(event.target.parentNode).data('id');
	};

  var updatePromise = function(event) {
    var id = $(event.target.parentNode.parentNode).data('id');
    ajax.getPromise(id, function(promise) {
      renderUpdatePopup(JSON.parse(promise));
    });
  };

  var addActions = function(data) {
    rights = JSON.parse(data);
    var html = '';
    if (rights['@edit'] == true) {
      html += EDIT + ' &nbsp;';
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
    var promiseId = $(obj).data('id');
		console.log(promiseId);
    ajax.getRights(promiseId, addActions);
  });
});
