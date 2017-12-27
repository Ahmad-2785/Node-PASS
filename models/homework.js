const mongoose = require('mongoose')
const Schema = mongoose.Schema;

const HwSchema = new Schema({
    courseName:{
        type : String
    },
    homeworkName:{
        type : String
    },
    dueDate:{
        type : String
    },
    percentage :{
        type : String
    },
    homeworkDescription:{
        type : String
    },
    fileExtension:{
        type : String
    },
    dueDateExtension:{
        type : Boolean,
        default : false
    },
    homeworkTestScriptName:{
        type : String
    },
    homeworkTestScriptPath:{
        type : String
    }
})

const HW = mongoose.model('hwCollection',HwSchema)

module.exports = HW