var gulp = require('gulp'),
    runSequence = require('run-sequence'),
    del = require('del'),
    coffee = require('gulp-coffee'),
    uglify = require('gulp-uglify'),
    gutil = require('gulp-util'),
    sass = require('gulp-sass'),
    sourcemaps = require('gulp-sourcemaps'),
    plumber = require('gulp-plumber'),
    jade = require('gulp-jade'),
    autoprefixer = require('gulp-autoprefixer'),
    template = require('gulp-template'),
    rename = require('gulp-rename');
var mainBowerFiles = require('main-bower-files');
var gulpif = require('gulp-if');

var env = 'dev';

var prodIp = process.env['PROD_IP'];
var devIp = process.env['DEV_IP'];

gulp.task('prepare_env', function(){
  return gulp.src('src/coffee/_env.coffee')
    .pipe(gulpif(env === 'dev', template({env_ip: devIp}), template({env_ip: prodIp}) ))
    .pipe(rename('env.coffee'))
    .pipe(gulp.dest('src/coffee'));
});

gulp.task('clean', function(){
  return del.sync(['public']);
});

// ================================================================= Coffee task

gulp.task('coffee', function(){
  return gulp.src('src/coffee/**')
        .pipe(plumber())
        .pipe(sourcemaps.init())
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(gulpif(env === 'prod', uglify() ))
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest('public/js'));
});


// ================================================================= Vendor task

// gulp.task('vendor', function(){
//   var js = {
//     backbone_localStorage: '../bower_components/backbone.localStorage/backbone.localStorage.js',
//     backbone: '../bower_components/backbone/backbone.js',
//     domReady: '../bower_components/domReady/domReady.js',
//     i18n: '../bower_components/requirejs-i18n/i18n.js',
//     jquery: '../bower_components/jquery/dist/jquery.js',
//     requirejs: '../bower_components/requirejs/require.js',
//     text: '../bower_components/text/text.js',
//     underscore: '../bower_components/underscore/underscore.js',
//     jcookie: '../bower_components/jquery.cookie/jquery.cookie.js',
//     moment: '../bower_components/moment/moment.js',
//     marked: '../bower_components/marked/lib/marked.js',
//     hammerjs: '../bower_components/hammerjs/hammer.js',
//     jhammerjs: '../bower_components/jquery-hammerjs/jquery.hammer.js',
//     mandrill: '../bower_components/mandrill-api/mandrill.js',
//     marionette: '../bower_components/marionette/lib/backbone.marionette.js',
//   };
//
//   return gulp.src(_.values(js))
//     .pipe(uglify())
//     .pipe(gulp.dest('public/js/libs'));
// });

gulp.task('vendor', function(){
  return gulp.src(mainBowerFiles({
      paths: {
        bowerDirectory: '../bower_components'
      }
    }))
    // .pipe(gulpif(env === 'prod', uglify()))
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
        .pipe(gulp.dest('public/css'));
});


// =================================================================== Jade task

gulp.task('jade', function(){
  gulp.src('src/jade/index.jade')
  .pipe(plumber())
  .pipe(jade().on('error', gutil.log))
  .pipe(gulp.dest('public'));

  return gulp.src(['src/jade/**/*.jade', '!src/jade/index.jade'])
        .pipe(plumber())
        .pipe(jade().on('error', gutil.log))
        .pipe(gulp.dest('public/js'));
});


// =============================================================================
// =============================================================================
// =============================================================================

gulp.task('default', ['clean', 'prepare_env'], function(){
  runSequence(['vendor', 'coffee', 'sass', 'jade']);

  gulp.watch('src/coffee/**/*.coffee',['coffee']);
  gulp.watch('src/sass/**/*.scss',['sass']);
  gulp.watch('src/jade/**/*.jade',['jade']);
});


// gulp.task('dev', ['clean', 'prepare_env'], function(){
//   runSequence(['vendor', 'coffee', 'sass', 'jade']);
// });
