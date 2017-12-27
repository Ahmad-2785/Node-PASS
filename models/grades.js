const mongoose = require('mongoose')
const Schema = mongoose.Schema

const GradeSchema = new Schema({
    studentID:{
        type : String
    },
    studentName:{
        type : String
    },
    homeworkGrade:{
        type : String,
        default : '0'
    },
    submitTime:{
        type : String
    },
    homework_uuid:{
        type : String
    },
    homeworkState:{
        type : String,
        default : '未繳交'
    },
    homeworkName:{
        type : String 
    },
     homeworkReport:{
        type : String
    }
})

const gradesDB = mongoose.model("gradesCollection", GradeSchema)
module.exports = gradesDB