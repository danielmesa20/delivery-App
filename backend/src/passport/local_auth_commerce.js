const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const User = require('../models/User');

passport.serializeUser((user, done) => {
    done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
    try {
        const user = await User.findById(id);
        done(null, user);
    } catch (err) {
        done(err, null);
    }
});

//SignUp User
passport.use('local-signup-commerce', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true,
}, async (req, email, password, done) => {
    try {
        //Check email use from a User
        const userCheck = await User.findOne({ email });
        const commerceCheck = await User.findOne({ email });

        if (!userCheck) {
            const user = new User({
                username: req.body.username,
                email,
                password
            });
            user.password = await user.encryptPassword(password);
            try {
                const newUser = await user.save();
                return done(null, newUser);
            } catch (err) {
                return done(err, null);
            }
        }

        return done('Email already used', null);
        
    } catch (err) {
        return done(err, null);
    }
}));

passport.use('local-signin', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true,
}, async (req, email, password, done) => {
    try {
        const user = await User.findOne({ email });
        if (user) {
            if (user.validatePassword(password)) {
                return done(null, user);
            } else {
                return done('Wrong password', null);
            }
        } 

        return done('Unregistered email', null);
        
    } catch (err) {
        return done(err, null);
    }
}));