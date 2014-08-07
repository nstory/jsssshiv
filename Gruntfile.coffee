module.exports = (grunt) ->
  grunt.initConfig
    clean:
      build: ['build']

    coffee:
      build:
        files: [
          expand: true
          ext: '.js'
          extDot: 'last'
          src: ['src/**.coffee', 'specs/**.coffee']
          dest: 'build/'
        ]

    jasmine:
      test:
        src: ['build/src/*.js']
        options:
          specs: ['build/specs/*.spec.js']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.registerTask 'test', ['build', 'jasmine']
  grunt.registerTask 'build', ['clean', 'coffee']
  grunt.registerTask 'default', ['build']
