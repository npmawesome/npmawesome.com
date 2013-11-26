module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-ftp-push'

  grunt.initConfig
    ftp_push:
      default:
        options:
          authKey: 'npmawesome',
          host: '69.163.149.228',
          dest: '/public/',
          port: 21
        files: [
          {
            expand: true
            cwd: 'out'
            src: ['**/*']
          }
        ]

  grunt.registerTask 'default', ['ftp_push']
