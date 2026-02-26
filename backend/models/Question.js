const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
  _id: { type: String, default: () => new mongoose.Types.ObjectId().toString() }, // Optional, but allows custom IDs or fallback to stringified ObjectId
  topicId: { type: String, required: true },
  questionText: { type: String, required: true },
  codeSnippet: { type: String },
  options: [{ type: String }],
  correctOptionIndex: { type: Number, required: true },
  explanation: { type: String },
  order: { type: Number }
});

module.exports = mongoose.model('Question', questionSchema);
