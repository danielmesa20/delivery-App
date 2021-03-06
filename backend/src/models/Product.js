const { Schema, model } = require('mongoose');

const ProductSchema = new Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: String, required: true },
    rating: { type: String, required: true, default: '0' },
    available: { type: Boolean, required: true },
    imageURL: { type: String, required: true },
    public_id: { type: String, required: true },
    commerce_id: { type: String, required: true },
    create: { type: Date, default: Date.now }
});

module.exports = model('Product', ProductSchema);