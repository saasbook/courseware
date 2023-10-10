class Movie {
  constructor (title, year, rating) {
    this.title = title;
    this.year = year;
    this.rating = rating;
  }

  ok_for_kids() { // "instance method"
    return /^G|PG/.test(this.rating);
  };

  full_title = () => `${this.title} (${this.year})`;
}

// using 'new' makes Movie the new objects prototype:
var pianist = new Movie('The Pianist', 2002, 'R');
var chocolat = new Movie('Chocolat', 2000, 'PG-13');
pianist.full_title(); // => "The Pianist (2002)"
chocolat.full_title(); // => "Chocolat (2000)"
chocolat.ok_for_kids(); // => true
// adding methods to an individual object:
pianist.title_with_rating = function() {
    return `${this.title}: ${this.rating}`;
}
pianist.title_with_rating(); // => "The Pianist: R"
chocolat.title_with_rating(); // => Error: 'undefined' not a function
// but we can add functions to prototype "after the fact":
Movie.prototype.title_with_rating = function() {
    return `${this.title}: ${this.rating}`;
}

chocolat.title_with_rating(); // => "Chocolat: PG-13"
// we can also invoke using 'apply' -- 'this' will be bound to the
//  first argument:
Movie.full_title.apply(chocolat); // "Chocolat (2000)"
// BAD: without 'new', 'this' is bound to global object!!
juno = Movie('Juno', 2007, 'PG-13'); // DON'T DO THIS!!
juno;               // undefined
juno.title;         // error: 'undefined' has no properties
juno.full_title();  // e
