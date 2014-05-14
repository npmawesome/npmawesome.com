require '../../vendor/unveil/jquery.unveil'
require '../../vendor/shine/shine.js'
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

initLogoSine = ->
  shine = new Shine $('#logo .name')[0]
  shine.light.position.x = window.innerWidth * 0.5
  shine.light.position.y = window.innerHeight * 0.5
  shine.draw()

$ ->
  initGithubStars()
  initLogoSine()
