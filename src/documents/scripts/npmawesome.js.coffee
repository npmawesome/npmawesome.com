require '../../vendor/unveil/jquery.unveil'
{githubStars} = require '../../vendor/github-stars/github-stars'
numeral = require '../../vendor/numeral'

initGithubStars = ->
  stars = $ '.github-stars'

  stars.one 'unveil', (e) ->
    setTimeout ->
      target = $ e.target

      githubStars target.data('githubRepo'), (stars) ->
        target.data 'githubStars', stars
        target.html numeral(stars).format('0a')

  stars.unveil()

$ ->
  initGithubStars()
