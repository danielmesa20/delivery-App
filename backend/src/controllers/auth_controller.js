const jwt = require('jsonwebtoken');
const User = require("../models/User");
const Commerce = require('../models/Commerce');

//SignUp Commerce
exports.signUpCommerce = async (req, res) => {

    const { email, password, category, country, state, name } = req.body;

    try {
        //Check email use
        const commerce = await Commerce.findOne({ email });

        if (!commerce) {
            const newCommerce = new Commerce({
                name,
                email,
                password,
                category,
                country,
                state
            });
            newCommerce.password = await newCommerce.encryptPassword(password);
            try {
                await newCommerce.save();
                return res.status(200).json({ err: null });
            } catch (err) {
                return res.status(400).json({ err });
            }
        }
        return res.status(400).json({ err: 'Email already used' });
        
    } catch (err) {
        console.log("Error signup: ", err);
        return res.status(400).json({ err });
    }
};

//SignIn Commmerce
exports.signInCommerce = async (req, res) => {

    const { email, password } = req.body;

    try {
        //Find if exist that email
        const commerce = await Commerce.findOne({ email });

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



//Get user data
exports.userData = async (req, res, next) => {
    try {
        const user = await User.findById(req.user.id).select('-password');
        if (user) {
            res.status(200).json(user);
        }
        res.status(400).json({ err: 'User Does not exist' });
    } catch (e) {
        res.status(400).json({ msg: e.message });
    }
}

//Logout
exports.logout = (req, res, next) => {
    try {
        res.status(200).send({ token: null });
    } catch (e) {
        res.status(400).json({ message: 'There was a problem Logout' });
    }
};

