const { Schema, model } = require('mongoose');

const ChatSchema = new Schema({
    userID:    {type: String, required: true},
    commerceID: {type: String, required: true},
    userURL:    {type: String, required: true},
    commerceURL: {type: String, required: true},
    userName:    {type: String, required: true},
    commerceName: {type: String, required: true},
    create: { type: Date, default: Date.now }
});

module.exports = model('Chat', ChatSchema);