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

initSocial = ->
  social = $ 'article > header > .social-box'

  social.one 'unveil', (e) ->
    setTimeout ->
      target = $(e.target).find('> .social')
      url = target.data('url') + '/'

      target.html """
        <div data-href="#{url}" data-layout="button_count" data-action="like" data-show-faces="false" data-share="false" class="fb-like"></div>
        <a href="https://twitter.com/share" data-url="#{url}" data-via="alexgorbatchev" data-hashtags="nodejs" class="twitter-share-button"></a>
        <div data-size="medium" data-href="#{url}" class="g-plusone"></div>
      """

      gapi?.plusone.go()
      twttr?.widgets.load()
      FB?.XFBML.parse()

  social.unveil()

initLogoSine = ->
  shine = new Shine $('#logo .name')[0]
  shine.light.position.x = window.innerWidth * 0.5
  shine.light.position.y = window.innerHeight * 0.5
  shine.draw()

$ ->
  initGithubStars()
  initLogoSine()
  initSocial()
