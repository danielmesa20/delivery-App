const { Schema, model } = require('mongoose');

const OrderSchema = new Schema({
    userId:    {type: String, required: true},
    commerceId: {type: String, required: true},
    create: { type: Date, default: Date.now }
});

module.exports = model('Order', OrderSchema);