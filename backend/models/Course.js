const mongoose = require('mongoose');

const courseSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String },
    icon: { type: String, default: '📚' },
    color: { type: String, default: '#6366F1' },
    totalProblems: { type: Number, default: 0 },
    courseId: { type: String, required: true, unique: true }
});

module.exports = mongoose.model('Course', courseSchema);
