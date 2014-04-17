require './stars'

require '../../vendor/shine/shine.js'

$ ->
  shine = new Shine $('#logo .name')[0]
  shine.light.position.x = window.innerWidth * 0.5
  shine.light.position.y = window.innerHeight * 0.5
  shine.draw()
