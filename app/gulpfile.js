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
var requirejs = require('gulp-requirejs');
var minifyHtml = require('gulp-minify-html');

var env = 'dev';
// var env = 'prod';

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

  gulp.src('src/coffee/config.coffee')
    .pipe(template({env: env}))
    .pipe(plumber())
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulpif(env === 'prod', uglify() ))
    .pipe(gulp.dest('public/js'));


  return gulp.src(['src/coffee/**', '!src/coffee/config.coffee'])
        .pipe(plumber())
        .pipe(sourcemaps.init())
          .pipe(coffee({bare: true}).on('error', gutil.log))
          .pipe(gulpif(env === 'prod', uglify() ))
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest('public/js'));
});


// ================================================================= Vendor task

gulp.task('vendor', function(){
  return gulp.src(mainBowerFiles({
      paths: {
        bowerDirectory: '../bower_components'
      }
    }))
    .pipe(gulpif(env === 'prod', uglify()))
    .pipe(gulp.dest('public/js/libs'));
});

// =================================================================== Sass task

gulp.task('sass', function(){
  return gulp.src('src/sass/main.scss')
        .pipe(plumber({
    			handleError: function (err) {
    				console.log(err);
    				this.emit('end');
    			}
    		}))
        .pipe(sourcemaps.init())
          .pipe(sass({outputStyle: 'compressed'}).on('error', gutil.log))
        .pipe(autoprefixer())
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('public/css'));
});


// =================================================================== Jade task

gulp.task('jade', function(){
  gulp.src('src/jade/index.jade')
  .pipe(template({env: env}))
  .pipe(plumber())
  .pipe(jade({pretty: true}).on('error', gutil.log))
  .pipe(gulpif(env === 'prod', minifyHtml()))
  .pipe(gulp.dest('public'));

  return gulp.src(['src/jade/**/*.jade', '!src/jade/index.jade'])
        .pipe(plumber())
        .pipe(jade().on('error', gutil.log) )
        .pipe(gulp.dest('public/js'));
});


gulp.task('rjs', function() {
    return requirejs({
      baseUrl: 'public/js',
      out: 'application.js',
			mainConfigFile: 'public/js/config.js',
      findNestedDependencies: true,
			name: 'main'
    })
    .pipe(gulp.dest('public/js'));
});


// =============================================================================
// =============================================================================
// =============================================================================

gulp.task('default', ['clean', 'prepare_env'], function(){
  if (env === 'dev') {
    runSequence(['vendor', 'coffee', 'sass', 'jade']);

    gulp.watch('src/coffee/**/*.coffee',['coffee']);
    gulp.watch('src/sass/**/*.scss',['sass']);
    gulp.watch('src/jade/**/*.jade',['jade']);
  } else if (env === 'prod') {
    runSequence(['vendor', 'sass', 'jade'], 'coffee', 'rjs');
  }
});
