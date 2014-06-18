CONTRIBUTORS =
  alexgorbatchev:
    name: 'Alex Gorbatchev'
    github: 'alexgorbatchev'
  akoenig:
    name: 'André König'
    github: 'akoenig'

docpadConfig =
  env: 'static'

  templateData:
    site:
      title: 'npm awesome'
      author: 'Alex Gorbatchev'
      description: 'Daily dose of awesome NPM modules for Node.js, old and new!'
      url: 'http://npmawesome.com'

    includeCodeExample: (filename, {npm, exampleName} = @document) ->
      fs = require 'fs'
      path = require 'path'

      exampleName = exampleName or npm?.install or npm?.name

      exampleDir = path.join process.cwd(), '.examples', 'example-' + (exampleName)
      throw new "No example for #{exampleName}" unless fs.existsSync exampleDir

      exampleFile = path.join exampleDir, filename
      throw new "No file #{filename} found in #{doc.npm?.name} example." unless fs.existsSync exampleFile

      fs
        .readFileSync(exampleFile, 'utf-8')
        .split(/\n/g)
        # add four spaces infront of each line so that markdown creates code blocks
        .map((line) -> "    #{line}")
        .join('\n')

    fullUrl: (doc = @document) ->
      @site.url + doc.url

    preparedTitle: (doc = @document) ->
      doc.title or doc.npm?.name

    preparedSlug: (doc = @document) ->
      doc.npm?.name

    githubUrl: (slug) ->
      "https://github.com/#{slug}"

    npm: ({npm} = @document) ->
      """<a href="#{@githubUrl npm.repo}">#{npm.displayName}</a>""" if npm?

    browsenpm: ({npm} = @document) ->
      """<a href="http://browsenpm.org/package/#{npm.name}">#{npm.displayName}</a>""" if npm?

    reference: ({npm} = @document) ->
      """#{@browsenpm npm} (Github: <a href="https://github.com/#{npm.repo}">#{npm.repo}</a>, License: #{npm.license})""" if npm?

    author: ({npm} = @document) ->
      {author} = npm or {}
      """<a href="#{@githubUrl author.github}">#{author.name}</a>""" if author?

    install: ({npm} = @document) ->
      """npm install #{npm.install or npm.name}"""

    by: (doc = @document) ->
      slug = doc.author or 'alexgorbatchev'
      author = CONTRIBUTORS[slug]

      throw "Unknown author `#{slug}`" unless author?
      "<a href=\"https://github.com/#{author.github}\">#{author.name}</a>"

    url: (href) ->
      @site.url + href

    image: (href) ->
      @url "/images/posts#{href}"

    pageTitle: ->
      @preparedTitle() or @site.title

    readMore: ->
      '<div class="read-more"></div>'

    getPreview: (doc = @document) ->
      body = doc.contentRenderedWithoutLayouts
      return '' unless body?

      split = body.indexOf @readMore()

      if split >= 0
        body = body.substr(0, split) + """<p class="read-more"><a href="#{doc.url}">Continue...</a></p>"""

      body

  events:
    parseAfter: ({collection}, done) ->
      # @docpad.collections.posts.forEach (post) ->
      done()

    writeAfter: (opts, next) ->
      # Prepare
      {rootPath, outPath} = @docpad.getConfig()

      @docpad.log 'info', 'Browserifying client side files'

      # Bundle the scripts the editor uses together
      command = """
        cd #{rootPath} &&
        #{rootPath}/node_modules/.bin/browserify #{outPath}/scripts/npmawesome.js | #{rootPath}/node_modules/.bin/uglifyjs > #{outPath}/scripts/npmawesome.min.js &&
        rm #{outPath}/scripts/npmawesome.js
      """.replace(/\n/g,' ')

      # Execute
      shelljs = require 'shelljs'

      shelljs.exec command, next
      # safeps.exec "find ./out/scripts | grep -v 'npmawesome.bundle.js' | xargs rm", {cwd:rootPath}, ->

      # Chain
      @

  collections:
    pagedPosts: (database) ->
      query =
        relativeOutDirPath: /^posts/
        isPagedAuto: $ne: true

      sort = [date: -1, basename: -1]

      database.findAllLive query, sort

    posts: (database) ->
      query =
        relativeOutDirPath: /^posts/
        ignored: $ne: true

      sort = [date: -1, basename: -1]

      database.findAllLive query, sort

# Export the DocPad Configuration
module.exports = docpadConfig
