const jwt = require('jsonwebtoken');
const passport = require('passport');
const User = require("../models/User");

//Register User
exports.signUp = async (req, res, next) => {
    passport.authenticate('local-signup', (err, user) => {
        if (!err) {
            return res.status(200).json({ err: null });
        }
        console.log("Error signup: ", err);
        return res.status(400).json({ err });

    })(req, res, next);
};

//Register Commer
exports.signUpCommerce = async (req, res, next) => {
    passport.authenticate('local-signup', (err, user) => {
        if (!err) {
            return res.status(200).json({ err: null });
        }
        console.log("Error signup: ", err);
        return res.status(400).json({ err });

    })(req, res, next);
};

//Login
exports.signIn = async (req, res, next) => {
    passport.authenticate('local-signin', (err, user) => {
        if (!err) {
            const token = jwt.sign({ id: user._id },
                process.env.SECRET, {
                expiresIn: '24h'
            });
            return res.status(200).json({
                err: null,
                token,
                user_id: user._id,
                user_name: user.username,
                email: user.email
            });
        }
        console.log("Error signIn: ", err);
        return res.status(400).json({ err });

    })(req, res, next);
};

//Login Commmerce
exports.signInCommerce = async (req, res, next) => {
    passport.authenticate('local-signin', (err, user) => {
        if (!err) {
            const token = jwt.sign({ id: user._id },
                process.env.SECRET, {
                expiresIn: '24h'
            });
            return res.status(200).json({
                err: null,
                token,
                user: {
                    id: user._id,
                    username: user.username,
                    email: user.email
                }
            });
        }
        console.log("Error signIn: ", err);
        return res.status(400).json({ err });

    })(req, res, next);
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

