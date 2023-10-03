// Select all movie titles
$('tr td:first-child')

$('tr td:first-child').map((index, elm) => $(elm).text())


// Add count of movies
$('h1').text(`${$('tbody tr').length} Movies`)

// Alternatively:
let movie_count = $('tbody tr').length;
$('h1').text(`${$('tbody tr').length} Movies`)
