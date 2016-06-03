module.exports = (grunt) ->

  # configuration
  grunt.initConfig

    # grunt sass
    sass:
      compile:
        options:
          style: 'expanded'
        files: [
          expand: true
          cwd: 'src/sass'
          src: ['**/*.scss']
          dest: 'src/css'
          ext: '.css'
        ]

    # grunt coffee
    coffee:
      compile:
        expand: true
        cwd: 'src/coffee'
        src: ['**/*.coffee']
        dest: 'src/js'
        ext: '.js'
        options:
          bare: true
          preserve_dirs: true

    # grunt concat
    concat:
      options:
        separator: ';'
      dist:
        src: ['src/js/jquery-2.2.4.js', 'src/js/boostrap-tooltip.js', 'src/qm-trips-visualization.js'],
        dest: 'dist/js/qm-trips.js',

    # grunt uglify
    uglify:
      my_target:
        files:
          'dist/js/qm-trips.min.js': ['dist/js/qm-trips.js']

    # grunt cssmin
    cssmin:
      dist:
        files:
          'dist/css/qm-trips.min.css': ['src/css/**/*.css']

    # grunt watch (or simply grunt)
    watch:
      html:
        files: ['**/*.html']
      sass:
        files: '<%= sass.compile.files[0].src %>'
        tasks: ['sass']
      coffee:
        files: '<%= coffee.compile.src %>'
        tasks: ['coffee']
      options:
        livereload: true

  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'

  # tasks
  grunt.registerTask 'default', ['sass', 'coffee', 'concat', 'uglify', 'cssmin', 'watch']