module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-gh-pages'

  grunt.initConfig
    'gh-pages':
      options:
        base: 'out'
      src: ['**']

  grunt.registerTask 'publish', ['gh-pages']
