# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig =
  env: 'static'

  templateData:
    site:
      title: 'npm awesome'
      author: 'Alex Gorbatchev'
      url: 'http://npmawesome.com'

    preparedTitle: (doc = @document)->
      doc.title or doc.npm?.name

    preparedSlug: (doc = @document)->
      doc.npm?.name

    githubUrl: ->
      "https://github.com/#{@document.npm.repo}"

    npm: ->
      """<a href="#{@githubUrl()}">#{@document.npm.name}</a>"""

  collections:
    posts: (database) ->
      database.findAllLive {relativeOutDirPath: /^posts/, isPagedAuto: $ne: true}, [basename: -1]

  plugins:
    rss:
      collection: 'posts'
      url: '/rss'

# Export the DocPad Configuration
module.exports = docpadConfig
