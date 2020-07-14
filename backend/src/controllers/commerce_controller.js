const Commerce = require("../models/Commerce");
const Cloudinary = require("../config/cloudinary");
const jwt = require('jsonwebtoken');

//SignUp Commerce
exports.signUpCommerce = async (req, res) => {

    const { email, password, category, country, state, name } = req.body;

    try {
        //Check email use
        const commerce = await Commerce.findOne({ email }).select('_id');;

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
            
            newCommerce.password = await newCommerce.encryptPassword(password);
            try {
                await newCommerce.save();
                return res.status(200).json({ err: null });
            } catch (err) {
                return res.status(400).json({ err: 'error' });
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

//Reset password commerce
exports.resetPasswordCommerce = async (req, res) => {
    const { email } = req.body;
    try {
        //Find if exist that email
        const commerce = await Commerce.findOne({ email });

        //Exist email
        if (commerce) {

            const token = jwt.sign({ id: commerce._id },
                process.env.RESET_PASSWORD_KEY, {
                expiresIn: '24h'
            });

            const data = {
                from: 'noreply@hello.com',
                to: email,
                subject: 'Acoount Activation Link',
                html: `
                <h2>Please click on given link to reset your passoword</h2>
                <p>${process.env.CLIENT_URL}/authentication/resetpassword/${token}</p>
                `
            };

            return res.status(200).json({
                err: null,
                token,
                id: commerce._id,
                name: commerce.name,
                email: commerce.email
            });

        }

        //Dont exist email
        return res.status(400).json({ err: 'Unregistered email' });

    } catch (err) {
        console.log("Error reset: ", err);
        return res.status(400).json({ err });
    }
}
