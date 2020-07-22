const Commerce = require("../models/Commerce");
const Cloudinary = require("../config/cloudinary");
const jwt = require('jsonwebtoken');
const fs = require('fs-extra');

//SignUp Commerce
exports.signUpCommerce = async (req, res) => {

    const { email, password, category, country, state, name } = req.body;

    try {
        //Check email use
        const commerce = await Commerce.findOne({ email }).select('_id');

        if (!commerce) {

            //Upload image to Cloudinary
            const result = await Cloudinary.v2.uploader.upload(req.file.path);

            const newCommerce = new Commerce({
                name,
                email,
                password,
                category,
                country,
                state,
                imageURL: result.url,
                public_id: result.public_id,
            });
            //Encrypt password 
            newCommerce.password = await newCommerce.encryptPassword(password);
            //Save commerce in MongoDB
            await newCommerce.save();
            //Delete image 
            fs.unlinkSync(req.file.path);
            return res.status(200).json({ err: null });
        }

        return res.status(400).json({ err: 'Email already used' });

    } catch (err) {
        console.log("Error signup: ", err);
        return res.status(400).json({ err });
    }
};

//SignIn Commmerce
exports.signInCommerce = async (req, res) => {

    //User credentials
    const { email, password } = req.body;

    try {
        //Find if exist that email
        const commerce = await Commerce.findOne({ email }).select('email password _id');

        //Exist email
        if (commerce) {
            //Check password
            if (commerce.validatePassword(password)) {
                const token = jwt.sign({ id: commerce._id },
                    process.env.SECRET, {
                    expiresIn: '24h'
                });
                return res.status(200).json({
                    err: null,
                    token,
                    id: commerce._id,
                    name: commerce.name,
                    email: commerce.email
                });
            }
            return res.status(400).json({ err: 'Wrong password' });
        }

        //Dont exist email
        return res.status(400).json({ err: 'Unregistered email' });

    } catch (err) {
        console.log("Error signIn: ", err);
        return res.status(400).json({ err });
    }
};

exports.checkEmail = async (req, res) => {
    //User credentials
    const { email } = req.body;
    try {
        //Find if exist that email
        const commerce = await Commerce.findOne({ email }).select('_id');

        //Exist email
        if (commerce) {
            return res.status(200).json({ err: 'Email already used' });
        }

        //Dont exist email
        return res.status(200).json({ err: null });

    } catch (err) {
        return res.status(400).json({ err });
    }
}

//Get commerce data
exports.commerceData = async (req, res) => {
    try {
        //Find commerce data
        const commerce = await Commerce.findById({ _id: req.params.id });
        //If exists 
        if (commerce != null) {
            return res.status(200).json({ err: null, commerce });
        }
        return res.status(400).json({ err: 'The commerce id does not exist', commerce: null });
    } catch (err) {
        return res.status(400).json({ err, commerce: null });
    }
}

