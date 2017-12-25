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
        default : 'Not Upload'
    },
    homeworkName:{
        type : String 
    },
    homeworkFeedback:{
        type : String 
    }
})

const gradesDB = mongoose.model("gradesCollection", GradeSchema)
module.exports = gradesDB