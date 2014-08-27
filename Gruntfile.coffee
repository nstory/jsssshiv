module.exports = (grunt) ->
  grunt.initConfig
    clean:
      build: ['lib']
      test: ['tmp']

    coffee:
      options:
        sourceMap: true
      build:
        files: [
          expand: true
          ext: '.js'
          extDot: 'last'
          cwd: 'src/'
          src: ['**.coffee']
          dest: 'lib/'
        ]
      test:
        files: [
          expand: true
          ext: '.js'
          extDot: 'last'
          cwd: 'specs/'
          src: ['**.coffee']
          dest: 'tmp/'
        ]

    jasmine:
      test:
        src: ['lib/*.js']
        options:
          specs: ['tmp/*.spec.js']

    watch:
      options:
        atBegin: true
      test:
        files: ['Gruntfile.coffee', 'src/**.coffee', 'specs/**.coffee']
        tasks: ['test']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'test', ['clean:test', 'build', 'coffee:test', 'jasmine']
  grunt.registerTask 'build', ['clean:build', 'coffee:build']
  grunt.registerTask 'default', ['build']
