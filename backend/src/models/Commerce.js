const { Schema, model } = require('mongoose');
const bcrypt = require('bcryptjs');

const CommerceSchema = new Schema({
    name:        { type: String, required: true },
    email:       { type: String, required: true },
    password:    { type: String, required: true },
    category:    { type: String, require: true },
    country:     { type: String, require: true },
    state:       { type: String, require: true },
    description: { type: String, require: true,  default: null },
    reputation:  { type: Number, require: true, default: 0 }
});

CommerceSchema.methods.encryptPassword = (password) => {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(10));
};

CommerceSchema.methods.validatePassword = function(password) {
    return bcrypt.compareSync(password, this.password);
};

module.exports = model('Commerce', CommerceSchema);