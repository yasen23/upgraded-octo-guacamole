var promiseStatus = function() {
  var iconNames = {
    0: 'not_started.png',
    1: 'in_progress.png',
    2: 'broken.png',
    3: 'completed.png'
  };

  var statusMessages = {
    0: "Not started",
    1: "In progress",
    2: "Broken",
    3: "Completed"
  };

  var statusClasses = {
    0: "not-started",
    1: "in-progress",
    2: "broken",
    3: "completed"
  };

  var renderPromises = function(template) {
    $(".promise-status").each(function(i, obj) {
      var status = $(obj).data('status');
      var rendered = Mustache.render(template, {
        status: statusMessages[status],
        statusClass: statusClasses[status],
        icon: 'images/' + iconNames[status]
      });

      $(obj).html(rendered);
    });
  };

  var fetchTemplateAndRender = function() {
    ajax.getTemplate('promise-status.mst', renderPromises);
  };

  return {
    renderPromises: fetchTemplateAndRender
  };
}();

$(document).ready(function() {
  promiseStatus.renderPromises();
});
