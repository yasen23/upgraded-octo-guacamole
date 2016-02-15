$(document).ready(function() {
  // Set sort handler for the table.
  $('.header').click(function(element) {
    var rows = $('#promises-table > tbody').children('tr').get();

    if ($(this).hasClass('sorted')) {
      // It is already sorted, so simply reverse it.
      rows.reverse();
    } else {
      // Sort by the selected column.
      var element = $(this).text().toLowerCase();
      var sortItemClass = "." + element + "-sort-item";
      rows.sort(function(a, b) {
        var first = $(a).find(sortItemClass).text();
        var second = $(b).find(sortItemClass).text();
        console.log(first + ' ' + second)
        return first.localeCompare(second);
      });
    }

    console.log(rows);
    for (var i = 0; i < rows.length; i++) {
      $('#promises-table > tbody').append(rows[i]);
    }

    $('.header').removeClass('sorted');
    $(this).addClass('sorted');
  });
});
