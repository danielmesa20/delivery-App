const express = require("express");
const router = express.Router();
const authController = require("../controllers/auth_controller");
const verifyToken = require('../config/token');

//SignUp Commerce
router.post('/signincommerce', authController.signInCommerce);

//SignIn Commerce
router.post('/signupcommerce', authController.signUpCommerce);

//Logout
router.get('/logout', verifyToken, authController.logout);

//Get user data
router.get('/user', verifyToken, authController.userData);

module.exports = router;
