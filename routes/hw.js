var express = require('express');
var router = express.Router();
const fs = require('fs'); 
const HW = require('../models/homework')
const GradeDB = require('../models/grades')
const studentDB = require('../models/student')
var controller = require('../controllers/homeworkController');


router.get('/download/:_id', function(req, res){
    HW.findOne({"_id":req.params._id}).then(function(result){
        console.log(result)
        res.download(result.homeworkTestScriptPath)
    })
})

router.get('/edit/:_id', function(req, res){
    HW.find({"_id":req.params._id}).then(function(result){
        console.log(result[0])
        res.render('editHomework', {title:'Edit Homework', result :result})
    })
})

router.get('/delete/:_id', function(req, res){
    HW.find({"_id":req.params._id}).then(function(hwinfo){
        return hwinfo[0].courseName
    }).then(function(courseName){
        HW.remove({"_id":req.params._id}).then(function(result){
            GradeDB.remove({"homework_uuid":req.params._id}).then(function(result){
                 console.log(courseName)
                 res.redirect('/hw/'+courseName)
            })
        })
    })
})

/* GET homework home page. */
router.get('/:courseName', controller.showSpecificCourseHw)

/* POST Add homework. */
router.post('/addHW', function(req, res, next){
    let uploadFile = req.files.homeworkTestScript;
    var dir = './homeworkCollection';
    //check for dir, if not create dir
    if (!fs.existsSync(dir)){
        fs.mkdirSync(dir);
    }
    if(uploadFile !== undefined) {
        req.body.homeworkTestScriptName =uploadFile.name
        req.body.homeworkTestScriptPath ='homeworkCollection/'+uploadFile.name
        uploadFile.mv('homeworkCollection/'+uploadFile.name, function(err) {
            if (err)
                return res.status(500).send(err);
        fs.createReadStream('homeworkCollection/'+uploadFile.name).pipe(fs.createWriteStream('C:/Program Files (x86)/Jenkins/workspace/teacher/'+uploadFile.name))
        })
      
    }
    HW.create(req.body).then(function(homework){
        studentDB.find({role:'student'}).then(function(students) {
            students.forEach(function(student) {
                let grade = {
                    studentID:student.studentID,
                    studentName:student.studentName,
                    submitTime:'',
                    homework_uuid:homework._id.toString(),
                    homeworkName:homework.homeworkName
                }
                GradeDB.create(grade).then(function(result) {
                    console.log(result)
                })
            })
        })
   })

    res.redirect('/hw/'+req.body.courseName)
})

/* POST Edit homework. */
router.post('/editHW', function(req, res){
    let uploadFile = req.files.homeworkTestScript;
    var dir = './homeworkCollection';
    //check for dir, if not create dir
    if (!fs.existsSync(dir)){
        fs.mkdirSync(dir);
    }
    if(uploadFile !== undefined) {
        req.body.homeworkTestScriptName = uploadFile.name
        req.body.homeworkTestScriptPath ='homeworkCollection/'+uploadFile.name
        uploadFile.mv('homeworkCollection/'+uploadFile.name, function(err) {
            if (err)
            return res.status(500).send(err);
        })
    }
    HW.findOneAndUpdate({"_id" : req.query.homework_uuid}, {$set:
        {
            homeworkName : req.body.homeworkName,
            dueDate : req.body.dueDate, 
            percentage : req.body.percentage, 
            fileExtension : req.body.fileExtension, 
            homeworkDescription : req.body.homeworkDescription,
            dueDateExtension : req.body.dueDateExtension,
            homeworkTestScriptName : req.body.homeworkTestScriptName,
            homeworkTestScriptPath : req.body.homeworkTestScriptPath
        }
    },{ new: true }).then(function(result){
       if(req.header('Content-Type')=='application/json'){
          console.log(result)
          res.json({result: result})
       }else{
          console.log(result)
          res.redirect('/hw/'+req.body.courseName)    
       }
    })
})

module.exports = router;
