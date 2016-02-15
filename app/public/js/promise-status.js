$(document).ready(function() {
  var iconNames = {
    0: 'not_started.png',
    1: 'started.png',
    2: 'broken.png',
    3: 'finished.png'
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
      var status = parseInt($(obj).text().trim());
      var rendered = Mustache.render(template, {
        status: statusMessages[status],
        statusClass: statusClasses[status],
        icon: 'images/' + iconNames[status]
      });

      $(obj).html(rendered);
    });
  };

  ajax.getTemplate('promise-status.mst', renderPromises);
});
