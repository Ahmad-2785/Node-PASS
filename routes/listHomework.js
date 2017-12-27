var express = require('express');
var router = express.Router();
const moment = require('moment');
const fs = require('fs'); 
const CourseDB = require('../models/courses')
const HW = require('../models/homework')
const GradeDB = require('../models/grades')
const studentDB = require('../models/student')



router.get('/', function(req, res){
  let result = {
    studentID : req.query.studentID,
    homeworks :  [],
    grades : []
  }
  HW.find({"courseName":req.query.courseName}).then(function(homeworks) {
    console.log(homeworks)
    result.homeworks = homeworks
    return homeworks
  }).then(function(homeworks){
    let homework_uuid = []
    for(let i = 0 ; i < homeworks.length ; i++){
      homework_uuid.push(homeworks[i]._id)
    }
    console.log(homework_uuid)
    GradeDB.find({"homework_uuid" :homework_uuid, "studentID" :req.query.studentID}).then(function(grade){
      result.grades = grade
      return result
    }).then(function(){
      console.log(result)
      res.render('listHomework', { title:req.query.studentID+' '
        +req.query.courseName+' '+'Homework Area' , result :result });
    })
  })
})

router.get('/uploadHomework', function(req, res){
  let result = {
      studentID :  req.query.studentID,
      homework :[],
      grade :[]
  }
  HW.find({"_id":req.query.homework_uuid}).then(function(homework){
    let canUpload = (homework[0].dueDateExtension == true) || !(overDeadline(homework[0].dueDate))
    result.homework = homework
    result.homework["canUpload"] = canUpload
    if(!canUpload){
      req.flash('msg','Overdue Submission.');
      res.locals.messages = req.flash();
    }
    return homework
  }).then(function(homework) {
    GradeDB.find({"homework_uuid": homework[0]._id, "studentID": req.query.studentID}).then(function(grade) {
      result.grade = grade
      return result
    }).then(function() {
      console.log(result)
      if(req.query.hasMsg == "true") {
        req.flash('msg','You did not upload file.');
        res.locals.messages = req.flash();
      }
      res.render('uploadHomework',{title : req.query.studentID+' '+homework[0].courseName ,
                                   subTitle : homework[0].homeworkName+' Upload Homework Area',
                                   result :result})
    })
  })
})

router.post('/upload', function(req, res){
  HW.find({"_id": req.query.homework_uuid}).then(function(homework){

    if(homework[0].dueDateExtension == false && overDeadline(homework[0].dueDate)){ //過期，而且不能補交

      console.log('過期了，而且不能補交')
      res.redirect('/listHomework?courseName='+homework[0].courseName+'&studentID='+req.query.studentID)
    }
    else { // 可以補交 || 沒有過期
      if (req.files.uploadFile == undefined )
        return res.status(500).send('No files were uploaded.');
      else {
        
        let uploadFile = req.files.uploadFile;
        var dir = './homeworkCollection';
        //check for dir, if not create dir
        if (!fs.existsSync(dir)){
            fs.mkdirSync(dir);
        }
        // Use the mv() method to place the file somewhere on your server
        uploadFile.mv('homeworkCollection/'+uploadFile.name, function(err) {
          if (err)
            return res.status(500).send(err);
          GradeDB.update({"homework_uuid":req.query.homework_uuid, "studentID" :req.query.studentID},
          {$set:{submitTime : upload(req.query.homework_uuid)}, homeworkState : 'Upload'}).then(function(result) {
            // console.log(result)
            res.redirect('/listHomework?courseName='+homework[0].courseName+'&studentID='+req.query.studentID)
            
          })
        })
      }

    }


  })


 
})

router.get('/download', function(req, res){
  let result = {
    studentID :  req.query.studentID,
    homework :[],
    grades : []
  }
  HW.find({"_id" : req.query.homework_uuid}).then(function(homework){
    result.homework = homework
    let homeworkName = homework[0].homeworkName
    let fileExtension = homework[0].fileExtension
    let filePath = 'homeworkCollection/'+req.query.studentID+'_'+homeworkName+'.'+fileExtension
    fs.exists(filePath, function(exists) { 
      if (exists) { 
        res.download(filePath)
      } 
      else {
        GradeDB.find({"homework_uuid": homework[0]._id, "studentID": req.query.studentID}).then(function(grade) {
          result.grade = grade
          return result
        }).then(function() {
          console.log(result)
          res.redirect('/listHomework/uploadHomework?homework_uuid='+req.query.homework_uuid+'&studentID='+req.query.studentID+'&hasMsg=true')
        })
      }
    })
    
  })
})

function upload(homework_uuid) {   

  return moment().format('YYYY/MM/DD,  H:mm:ss ')
}

function overDeadline(dueDate) {
    let check  = Date.now();
    let deadline = new Date(dueDate)
  
    if(check > deadline) //過期
      return true
    
    else //還沒到
      return false
   
  
}

module.exports = router;