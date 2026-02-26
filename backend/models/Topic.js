const mongoose = require('mongoose');

const topicSchema = new mongoose.Schema({
    _id: { type: String, default: () => new mongoose.Types.ObjectId().toString() }, // Use stable string IDs or fallback to stringified ObjectId
    courseId: { type: String, required: true },
    name: { type: String, required: true },
    description: { type: String },
    problemCount: { type: Number, default: 0 },
    order: { type: Number }
});

module.exports = mongoose.model('Topic', topicSchema);
