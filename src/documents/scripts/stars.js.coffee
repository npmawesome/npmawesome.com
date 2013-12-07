require '../../vendor/unveil/jquery.unveil'
numeral = require '../../vendor/numeral'
{githubStars} = require '../../vendor/github-stars/github-stars'

$ ->
  stars = $ '.github-stars'

  stars.one 'unveil', (e) ->
    target = $ e.target

    githubStars target.data('githubRepo'), (stars) ->
      target.data 'githubStars', stars
      target.html numeral(stars).format('0a')

  stars.unveil()
