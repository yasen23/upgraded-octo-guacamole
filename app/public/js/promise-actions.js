var promiseActions = function() {
  var UPDATE = '<a href="#" class="update action"><img id="update-icon" src="images/update-icon.png" /></a>';
  var EDIT = '<a href="#" class="edit action"><img id="edit-icon" src="images/edit-icon-new.png" /></a>';
  var CONFIRM = '<a href="#" class="confirm action"><img id="confirm-icon" src="images/confirm-icon.png" /></a>';

  var updateRow = function(promise) {
    var promiseRow = '#promise-row-' + promise['@id'];
    $(promiseRow + ' .p-status').data('status', promise['@status']);
    $(promiseRow + ' .p-status').data('confirmed', promise['@confirmed']);
    $(promiseRow + ' .p-title').text(promise['@title']);
    $(promiseRow + ' .p-body').text(promise['@body']);
    $(promiseRow + ' .p-ref').attr('href', promise['@completed_reference']);

    promiseStatus.renderPromises();
    populateActions();
  };

  var closePopup = function() {
    // Close all open popups.
    $('.popup').remove();
    $('#edit-promise-popup').remove();
    $('#update-promise-popup').remove();
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

      $('#update-btn').on('click', function() {
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

  var renderEditPopup = function(promise) {
    ajax.getTemplate('edit-popup.mst', function(template) {
      var rendered = Mustache.render(template, {
        title: promise['@title'],
        body: promise['@body']
      });

      $('body').append(rendered);

      var selectedId = 'o-' + promise['@privacy'];
      $('#pr option').filter(function() {
        return this.id === selectedId;
      }).prop('selected', true);

      $('#edit-btn').on('click', function() {
        var title = $('#title').val();
        var body = $('#promise-edit-body').val();
        var privacy = $('#pr').val();

        ajax.editPromise({
          title: title,
          body: body,
          privacy: privacy,
          promiseId: promise['@id']
        }, completeUpdate);
      });

      $('#cancel').on('click', closePopup);
    });
  };

  var renderConfirmPopup = function(promise) {
    ajax.getTemplate('confirm-popup.mst', function(template) {
      var rendered = Mustache.render(template, {
        title: promise['@title'],
      });

      $('body').append(rendered);
      $('#confirm').on('click', function() {
        ajax.confirmPromise(promise['@id'], completeUpdate);
      });

      $('#cancel').on('click', closePopup);
    });
  };

  var editPromise = function(event) {
    var id = $(event.target.parentNode.parentNode).data('id');
    ajax.getPromise(id, function(promise) {
      renderEditPopup(JSON.parse(promise));
    });
	};

  var updatePromise = function(event) {
    var id = $(event.target.parentNode.parentNode).data('id');
    ajax.getPromise(id, function(promise) {
      renderUpdatePopup(JSON.parse(promise));
    });
  };

  var confirmPromise = function(event) {
    var id = $(event.target.parentNode.parentNode).data('id');
     ajax.getPromise(id, function(promise) {
      renderConfirmPopup(JSON.parse(promise));
    });
  };

  var addActions = function(data) {
    rights = JSON.parse(data);
    console.log(data);
    var html = '';
    if (rights['@edit'] == true) {
      html += EDIT + ' &nbsp;';
    }

    if (rights['@update'] == true) {
      html += UPDATE + ' &nbsp;';
    }

    if (rights['@confirm'] == true) {
      html += CONFIRM + ' &nbsp;';
    }

    if (html == '') {
      html = 'N/A';
    }

    $('.promise-' + rights['@promise_id']).html(html);
    $('.promise-' + rights['@promise_id'] + ' .edit').on('click', editPromise);
    $('.promise-' + rights['@promise_id'] + ' .update').on('click', updatePromise);
    $('.promise-' + rights['@promise_id'] + ' .confirm').on('click', confirmPromise);
  };

  var populateActions = function() {
    $('.actions').each(function(i, obj) {
      var promiseId = $(obj).data('id');
      ajax.getRights(promiseId, addActions);
    });
  }

  return {
    populate: populateActions
  }
}();

$(document).ready(function() {
  promiseActions.populate();
});
