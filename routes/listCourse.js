var express = require('express');
var router = express.Router();
const fileUpload = require('express-fileupload');
const CourseDB = require('../models/courses')
const HW = require('../models/homework')
const GradeDB = require('../models/grades')
const studentDB = require('../models/student')



/* GET homework home page. */
router.get('/:studentID', function(req, res){
  let result = {
    studentID: req.params.studentID,
    course: []
  }
  studentDB.find({"studentID" :req.params.studentID}).then(function(student){
      console.log(student[0].studentID) 
      return student[0].courseID
  }).then(function(courseID){
      CourseDB.find({'courseID':courseID}).then(function(courseInfo){
        result.course = courseInfo
        console.log(result)
        res.render('listCourse',{title: req.params.studentID+" Online Classroom",result:result})
      })
  })
})


// router.get('/', function(req, res) {
//   CourseDB.find({}).then(function(result){
//     console.log(result)
//     res.render('listCourse', { title:'作業繳交區' , result :result });
//   })
// });

module.exports = router;