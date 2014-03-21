gulp         = require 'gulp'
gutil        = require 'gulp-util'
notify       = require 'gulp-notify'
rename       = require 'gulp-rename'

# templates
jade         = require 'gulp-jade'

# Scripts
coffee       = require 'gulp-coffee'
coffeelint   = require 'gulp-coffeelint'
jshint       = require 'gulp-jshint'
uglify       = require 'gulp-uglify'

# Styles
sass         = require 'gulp-ruby-sass'
prefixer     = require 'gulp-autoprefixer'
minifycss    = require 'gulp-minify-css'

# Source and dest paths
paths =
    templates:
        src:  'src/**/*.jade'
        dest: 'dest/'
    scripts:
        src:  'src/assets/coffee/*.coffee'
        dest: 'dest/assets/scripts/'
    styles:
        src:  'src/assets/sass/*.scss'
        dest: 'dest/assets/css/'

# Templates
gulp.task 'templates', ->
    gulp.src paths.templates.src
    .pipe jade({
        # locals: YOUR_LOCALS
        pretty: true
    })
    .pipe gulp.dest paths.templates.dest
    .pipe notify({message: 'Templates task complete!!'})

# Scripts
gulp.task 'scripts', ->
    gulp.src paths.scripts.src
    .pipe coffee({bare: true})
    .pipe jshint()
    .pipe jshint.reporter 'default'
    .pipe gulp.dest paths.scripts.dest
    .pipe rename({suffix: '.min'})
    .pipe uglify({unsafe: true})
    .pipe gulp.dest paths.scripts.dest
    .pipe notify({message: 'Scripts task complete!!'})

# Styles
gulp.task 'styles', ->
    gulp.src paths.styles.src
    .pipe sass({style: 'expanded'})
    .pipe prefixer('last 2 version')
    .pipe gulp.dest paths.styles.dest
    .pipe rename({suffix: '.min'})
    .pipe minifycss()
    .pipe gulp.dest paths.styles.dest
    .pipe notify({message: 'Styles task complete!!'})


# copyというタスクを定義（サンプル）
###
gulp.task 'copy', ->
    # client/imgフォルダ以下を絞込
    gulp.src 'client/img/**'
    .pipe gulp.dest 'build/img' #全てbuild/img以下にコピー

    # client/cssフォルダにコピー
    gulp.src 'client/css/**'
    .pipe gulp.dest 'build/css'

    # HTMLをコピー
    gulp.src 'client/*.html'
    .pipe gulp.dest 'build'
###

# Default（引数無しで、'gulp'と実行した際に呼び出されるタスク）の定義
gulp.task 'default', ['templates','scripts', 'styles', 'watch']

# Watch
gulp.task 'watch', ->
    gulp.watch paths.templates.src, ['templates']
    gulp.watch paths.styles.src, ['styles']
    gulp.watch paths.scripts.src, ['scripts']
