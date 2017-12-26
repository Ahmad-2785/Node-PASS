var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
const mongoose = require('mongoose')
const fileUpload = require('express-fileupload');
const moment = require('moment');
const flash = require('connect-flash');
const session = require('express-session');


var index = require('./routes/index');
var users = require('./routes/users');
var hw = require('./routes/hw');
var course = require('./routes/course')
var markHomework = require('./routes/markHomework')
var gradesReport = require('./routes/gradesReport')
var listCourse = require('./routes/listCourse')
var listHomework = require('./routes/listHomework')

var app = express();
mongoose.connect('mongodb://localhost/hwgo')
mongoose.Promise = global.Promise


// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Handle Sessions
app.use(session({
  secret:'secret',
  saveUninitialized: true,
  resave: true
}));
app.use(flash());// use connect-flash for flash messages stored in session



// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(fileUpload());


let authForTeacher = function(req, res, next) {
  if (req.session && req.session.isLogin == true && req.session.result[0].role=="teacher")
    return next();
  else{
    req.flash('msg','Unauthorized.');
    res.locals.messages = req.flash();
    res.render('login')
  }
    // return res.status(401).send('Unauthorized');
};

let authForStudent = function(req, res, next) {
  if (req.session && req.session.isLogin == true && req.session.result[0].role=="student")
    return next();
  else{
    req.flash('msg','Unauthorized.');
    res.locals.messages = req.flash();
    res.render('login')
  }
    // return res.status(401).send('Unauthorized');
};

app.use('/', index);
app.use('/users', users);
app.use('/hw', authForTeacher, hw)
app.use('/course', authForTeacher, course)
app.use('/markHomework', authForTeacher, markHomework)
app.use('/gradesReport', authForTeacher, gradesReport)
app.use('/listCourse', authForStudent, listCourse)
app.use('/listHomework', authForStudent, listHomework)

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});


module.exports = app;
