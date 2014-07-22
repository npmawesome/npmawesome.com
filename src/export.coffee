fs = require 'fs'
moment = require 'moment-timezone'
path = require 'path'
XRegExp = require 'xregexp'
eco = require 'eco'
yaml = require 'js-yaml'
serialize = require './serialize'

documentsDir = "#{__dirname}/documents/posts"
metaRegex = /^---([\s\S]*?)---/
results = []
imageCache = {}
uniqidSeed = null

uuid = (prefix, more_entropy) ->
  # +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # +    revised by: Kankrelune (http://www.webfaktory.info/)
  # %        note 1: Uses an internal counter (in php_js global) to avoid collision
  # *     example 1: uniqid();
  # *     returns 1: 'a30285b160c14'
  # *     example 2: uniqid('foo');
  # *     returns 2: 'fooa30285b1cd361'
  # *     example 3: uniqid('bar', true);
  # *     returns 3: 'bara20285b23dfd1.31879087'
  prefix = ""
  prefix = ""  if typeof prefix is "undefined"
  retId = undefined
  formatSeed = (seed, reqWidth) ->
    seed = parseInt(seed, 10).toString(16) # to hex str
    # so long we split
    return seed.slice(seed.length - reqWidth)  if reqWidth < seed.length
    # so short we pad
    return Array(1 + (reqWidth - seed.length)).join("0") + seed  if reqWidth > seed.length
    seed

  # init seed with big random int
  uniqidSeed = Math.floor(Math.random() * 0x75bcd15)  unless uniqidSeed
  uniqidSeed++
  retId = prefix # start with prefix, add current milliseconds hex string
  retId += formatSeed(parseInt(new Date().getTime() / 1000, 10), 8)
  retId += formatSeed(uniqidSeed, 5) # add seed hex string

  # for more entropy we add a float lower to 10
  retId += (Math.random() * 10).toFixed(8).toString()  if more_entropy
  retId

context =
  author: -> '[author]'

  install: -> '[module install]'

  browsenpm: -> '[module]'

  readMore: -> '<!--more-->'

  url: (url) -> url

  includeCodeExample: (filename, {npm, exampleName} = @document) ->
    exampleName = exampleName or npm?.install or npm?.name
    exampleDir = path.join process.cwd(), '..', '.examples', 'example-' + (exampleName)
    throw new "No example for #{exampleName}" unless fs.existsSync exampleDir

    exampleFile = path.join exampleDir, filename
    throw new "No file #{filename} found in #{doc.npm?.name} example." unless fs.existsSync exampleFile

    fs
      .readFileSync(exampleFile, 'utf-8')
      .split(/\n/g)
      # add four spaces infront of each line so that markdown creates code blocks
      .map((line) -> "    #{line}")
      .join('\n')

  reference: ({displayName, repo, license, name} = {}) ->
    attrs = ['full']
    attrs.push "name=\"#{name}\"" if name?
    attrs.push "displayName=\"#{displayName}\"" if displayName?
    attrs.push "github=\"#{repo}\"" if repo?
    attrs.push "license=\"#{license}\"" if license?
    "[module #{attrs.join ' '}]"

  image: (src) ->
    date = moment @document.date
    images[src] = "http://npmawesome.com/images/posts#{src}"
    full = imageCache[src] or "http://npmawesome.com/wp-content/uploads/#{date.format 'YYYY/MM'}/#{path.basename src}"
    imageCache[src] ?= full
    full

findModules = (post) ->
  r = /\[([\w-]+)\]\(http:\/\/browsenpm.org\/package\/([\w-]+)\) [\(\[]GitHub: \[([\w-]+\/[\w-]+)\]\(.*?\), License: (.*?)[\)\]]/g

  post.replace r, (full, displayName, name, github, license) ->
    displayName = " displayName=\"#{displayName}\"" if displayName isnt name
    displayName = '' if displayName is name

    """[module name="#{name}"#{displayName} github="#{github}" license="#{license}" full]"""

print = (s) -> process.stdout.write s
md5 = (s) -> require('crypto').createHash('md5').update(s).digest('hex')

print """
  <?xml version="1.0" encoding="UTF-8" ?>
  <rss version="2.0"
    xmlns:excerpt="http://wordpress.org/export/1.2/excerpt/"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:wp="http://wordpress.org/export/1.2/"
  >

  <channel>
    <title>npmawesome.com</title>
    <link>http://npmawesome.com</link>
    <wp:wxr_version>1.2</wp:wxr_version>
    <wp:base_site_url>http://npmawesome.com</wp:base_site_url>
    <wp:base_blog_url>http://npmawesome.com</wp:base_blog_url>
"""

acfField = (key, value) ->
  fieldId = "field_#{uuid(key + value)}"
  fieldInfo =
    name: key
    key: key

  print """
    <wp:postmeta>
      <wp:meta_key>#{fieldId}</wp:meta_key>
      <wp:meta_value><![CDATA[#{serialize fieldInfo}]]></wp:meta_value>
    </wp:postmeta>
    <wp:postmeta>
      <wp:meta_key>#{key}</wp:meta_key>
      <wp:meta_value><![CDATA[#{value}]]></wp:meta_value>
    </wp:postmeta>
    <wp:postmeta>
      <wp:meta_key>_#{key}</wp:meta_key>
      <wp:meta_value><![CDATA[#{fieldId}]]></wp:meta_value>
    </wp:postmeta>
  """

for filename, postId in fs.readdirSync documentsDir when filename.indexOf('20') is 0
  images = {}
  post = fs.readFileSync "#{documentsDir}/#{filename}", 'utf8'
  meta = yaml.safeLoad post.match(metaRegex)[1]
  post = findModules post
    .replace metaRegex, ''
    .replace /<img.*?(gravatar.com|githubusercontent.com).*?\/>/g, '[author photo]'

  post = "[partner #{meta.partner}]\n\n#{post}" if meta.partner?

  meta.tags = meta.tags.split /\s*,\s*/g if meta.tags?
  meta.slug = filename.match(/^(.*?)\..*$/)[1]
  meta.author ?= 'alexgorbatchev'
  meta.description ?= ''

  context.document = meta
  # uuid = (s) -> md5(meta.slug + s).substr(0, 13)
  context.github = ({displayName, repo} = meta?.npm or {}) ->
    """[#{displayName or repo}](https://github.com/#{repo})"""

  post = eco.render post, context

  print """
    <item>
      <wp:post_id>#{postId}</wp:post_id>
      <title><![CDATA[#{meta.title}]]></title>
      <link>http://npmawesome.com/#{meta.slug}/</link>
      <pubDate>#{moment(meta.date).toString()}</pubDate>
      <dc:creator><![CDATA[#{meta.author}]]></dc:creator>
      <guid isPermaLink="false">http://npmawesome.com/#{meta.slug}/</guid>
      <description>#{meta.description}</description>
      <excerpt:encoded><![CDATA[]]></excerpt:encoded>
      <wp:post_date>#{moment(meta.date).tz('America/Los_Angeles').format 'YYYY-MM-DD HH:mm:ss'}</wp:post_date>
      <wp:post_date_gmt>#{moment(meta.date).tz('UTC').format 'YYYY-MM-DD HH:mm:ss'}</wp:post_date_gmt>
      <wp:comment_status>open</wp:comment_status>
      <wp:ping_status>closed</wp:ping_status>
      <wp:post_name>#{meta.slug.substr(11)}</wp:post_name>
      <wp:status>publish</wp:status>
      <wp:post_parent>0</wp:post_parent>
      <wp:menu_order>0</wp:menu_order>
      <wp:post_type>post</wp:post_type>
      <wp:post_password></wp:post_password>
      <wp:is_sticky>0</wp:is_sticky>
      <category domain="author" nicename="cap-#{meta.author}"><![CDATA[#{meta.author}]]></category>
      <wp:postmeta>
        <wp:meta_key>_wpcom_is_markdown</wp:meta_key>
        <wp:meta_value><![CDATA[1]]></wp:meta_value>
      </wp:postmeta>
      <wp:postmeta>
        <wp:meta_key>_amt_description</wp:meta_key>
        <wp:meta_value><![CDATA[#{meta.description}]]></wp:meta_value>
      </wp:postmeta>
  """

  if 'links' in meta.tags or meta.slug.indexOf('links') > -1
    post = post.replace ///\s\s>[^*]*///g, (full) -> "\n#{full}\n"

    print """
      <category domain="category" nicename="nerd-links"><![CDATA[Nerd Links]]></category>
    """

  for tag in meta.tags when tag not in ['npm', 'links']
    print """
      <category domain="post_tag" nicename="#{tag}"><![CDATA[#{tag}]]></category>
    """

  if meta.npm?
    print """
      <category domain="category" nicename="npm"><![CDATA[npm]]></category>
    """
    acfField "module_name", meta.npm.install or meta.npm.name
    acfField "module_github", meta.npm.repo
    acfField "module_license", meta.npm.license

    if meta.npm.install?
      acfField "module_display_name", meta.npm.name

  post = post
    .replace /\n{3}/g, '\n\n'
    .replace /^\s*|\s$/g, ''
    .replace /^    \[module install\]$/m, '```bash\n[module install]\n```'
    .replace /(    [\s\S]*?)(?=(?:\n\n[\S]))/g, (full) ->
      full = full.replace /^    /gm, ''
      "```javascript\n#{full}\n```"

  print """
      <content:encoded><![CDATA[#{post}]]></content:encoded>
    </item>
  """

  for src, full of images
    print """
      <item>
        <title>#{path.basename(src).replace /\.\w+$/, ''}</title>
        <wp:post_parent>#{postId}</wp:post_parent>
        <wp:attachment_url>#{full}</wp:attachment_url>
        <wp:post_type>attachment</wp:post_type>
        <wp:post_date>#{moment(meta.date).tz('America/Los_Angeles').format 'YYYY-MM-DD HH:mm:ss'}</wp:post_date>
        <wp:post_date_gmt>#{moment(meta.date).tz('UTC').format 'YYYY-MM-DD HH:mm:ss'}</wp:post_date_gmt>
        <category domain="author" nicename="cap-#{meta.author}"><![CDATA[#{meta.author}]]></category>
      </item>
    """

print """
  </channel>
  </rss>
"""