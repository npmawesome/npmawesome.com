(function() {
  var githubStars, numeral;

  require('../../vendor/unveil/jquery.unveil');

  numeral = require('../../vendor/numeral');

  githubStars = require('../../vendor/github-stars/github-stars').githubStars;

  $(function() {
    var stars;
    stars = $('.github-stars');
    stars.one('unveil', function(e) {
      var target;
      target = $(e.target);
      return githubStars(target.data('githubRepo'), function(stars) {
        target.data('githubStars', stars);
        return target.html(numeral(stars).format('0a'));
      });
    });
    return stars.unveil();
  });

}).call(this);
