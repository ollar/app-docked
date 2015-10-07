var _ = require('../bower_components/underscore/underscore.js');
var gulp = require('gulp'),
    runSequence = require('run-sequence'),
    connect = require('gulp-connect'),
    del = require('del'),
    coffee = require('gulp-coffee'),
    uglify = require('gulp-uglify'),
    gutil = require('gulp-util'),
    sass = require('gulp-sass'),
    sourcemaps = require('gulp-sourcemaps'),
    watch = require('gulp-watch'),
    plumber = require('gulp-plumber'),
    jade = require('gulp-jade'),
    autoprefixer = require('gulp-autoprefixer'),
    template = require('gulp-template'),
    rename = require('gulp-rename');


var prodId = process.env['PROD_IP'];

gulp.task('prepare_env', function(){
  return gulp.src('src/coffee/_env.coffee')
  .pipe(template({env_ip: prodId}))
  .pipe(rename('env.coffee'))
  .pipe(gulp.dest('src/coffee'));
});

gulp.task('clean', function(){
  return del.sync(['public']);
});

gulp.task('connect', function() {
  connect.server({
    root: 'public',
    livereload: true
  });
});

// ================================================================= Coffee task

gulp.task('coffee', function(){
  return gulp.src('src/coffee/**')
        .pipe(plumber())
        .pipe(sourcemaps.init())
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(uglify())
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest('public/js'))
        // .pipe(connect.reload());
});


// ================================================================= Vendor task

gulp.task('vendor', function(){
  var js = {
    backbone_localStorage: '../bower_components/backbone.localStorage/backbone.localStorage.js',
    backbone: '../bower_components/backbone/backbone.js',
    domReady: '../bower_components/domReady/domReady.js',
    i18n: '../bower_components/requirejs-i18n/i18n.js',
    jquery: '../bower_components/jquery/dist/jquery.js',
    requirejs: '../bower_components/requirejs/require.js',
    text: '../bower_components/text/text.js',
    underscore: '../bower_components/underscore/underscore.js',
    jcookie: '../bower_components/jquery.cookie/jquery.cookie.js',
    moment: '../bower_components/moment/moment.js',
    marked: '../bower_components/marked/lib/marked.js',
    hammerjs: '../bower_components/hammerjs/hammer.js',
    jhammerjs: '../bower_components/jquery-hammerjs/jquery.hammer.js',
    mandrill: '../bower_components/mandrill-api/mandrill.js',
    marionette: '../bower_components/marionette/lib/backbone.marionette.js',
  };

  var css = {
    pure: '../bower_components/pure/pure.css'
  };

  gulp.src(_.values(css)).pipe(gulp.dest('public/css'));
  return gulp.src(_.values(js))
    .pipe(uglify())
    .pipe(gulp.dest('public/js/libs'));
});


// =================================================================== Sass task

gulp.task('sass', function(){
  return gulp.src('src/sass/main.scss')
        .pipe(plumber())
        .pipe(sourcemaps.init())
          .pipe(sass({outputStyle: 'compressed'}).on('error', gutil.log))
        .pipe(autoprefixer())
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('public/css'))
        // .pipe(connect.reload());
});


// =================================================================== Jade task

gulp.task('jade', function(){
  gulp.src('src/jade/index.jade')
  .pipe(plumber())
  .pipe(jade().on('error', gutil.log))
  .pipe(gulp.dest('public'))
  // .pipe(connect.reload());

  return gulp.src(['src/jade/**/*.jade', '!src/jade/index.jade'])
        .pipe(plumber())
        .pipe(jade().on('error', gutil.log))
        .pipe(gulp.dest('public/js'))
        // .pipe(connect.reload());
});


// =============================================================================
// =============================================================================
// =============================================================================

gulp.task('default', ['clean', 'prepare_env'], function(){
  runSequence(['vendor', 'coffee', 'sass', 'jade']);

  watch('src/coffee/**', {name: 'Coffee'}, function(){
    gulp.start('coffee');
  });

  watch('src/sass/**', {name: 'Sass'}, function(){
    gulp.start('sass');
  });

  watch('src/jade/**', {name: 'Jade'}, function(){
    gulp.start('jade');
  });

});


gulp.task('dev', ['clean', 'prepare_env'], function(){
  runSequence(['vendor', 'coffee', 'sass', 'jade']);
});
