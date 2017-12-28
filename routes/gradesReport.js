var express = require('express')
var router = express.Router()
const HW = require('../models/homework')
const GradesDB = require('../models/grades')

router.get('/', function(req, res){
    if(req.query.hasMsg=='true') {
        req.flash('msg','Please choose homework.');
        res.locals.messages = req.flash();
    }
    let homeworkCollections = []
    HW.find({}).then(function(findHwResults){
        findHwResults.forEach(function(result){
            let eachHwinfo ={
            courseName:result.courseName,
            hwinfo:[{
                      homeworkName:result.homeworkName,
                      homework_id:result._id
                   }]
            }
        //要把同一個課程下的作業都歸類在一起  
        if(valueExists(homeworkCollections, result.courseName)==false){
            homeworkCollections.push(eachHwinfo)
        }
        else{
            for(let index=0 ; index<homeworkCollections.length; index++){
                if(homeworkCollections[index].courseName == result.courseName){
                    homeworkCollections[index].hwinfo.push({
                        homeworkName:result.homeworkName,
                        homework_id:result._id
                    })
                }
            }
        }
        })
        return homeworkCollections
    }).then(function(homeworkCollections){
        console.log(homeworkCollections)
        res.render('gradesReportIndex', {title:'Grades Report', result : homeworkCollections})
    })
})

router.get('/generate', function(req, res){
    if(!req.query.noSelect) {
        GradesDB.find({"homework_uuid" : req.query.homework_id}).then(function(result){
            let gradeRange = new Map();
            gradeRange.set("10",0)
            gradeRange.set("9",0)
            gradeRange.set("8",0)
            gradeRange.set("7",0)
            gradeRange.set("6",0)
            gradeRange.set('UnderSixty',0)
            let average=0
            result.forEach(function(collectGrade){
                if(collectGrade.homeworkGrade!="" && Number.isInteger(collectGrade.homeworkGrade*1)) {
                    average = average + collectGrade.homeworkGrade*1
                    let grade = Math.floor(collectGrade.homeworkGrade/10)
                    if(gradeRange.has(String(grade))){
                        gradeRange.set(String(grade),gradeRange.get(String(grade))*1+1)
                    }
                    else{
                        gradeRange.set('UnderSixty',gradeRange.get('UnderSixty')*1+1)
                    }
                }
           })
           result.average=average/result.length
           res.render('homeworkScore',{title: req.query.courseName, result: result, pieChartInfos: gradeRange})
        })
    }
    else 
        res.redirect('/gradesReport?hasMsg=true')
})

function valueExists(homeworkCollections, value){
    if(homeworkCollections.length == 0) {
            return false        
    }
    for(let i=0 ; i<homeworkCollections.length; i++){
        if(homeworkCollections[i].courseName == value){
               return true
        }
    }
    return false
}

module.exports = router;