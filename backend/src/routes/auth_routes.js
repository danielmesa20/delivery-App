const express = require("express");
const router = express.Router();
const authController = require("../controllers/auth_controller");
const verifyToken = require('../config/token');

//SignIn
router.post('/signin', authController.signIn);

//SignUp
router.post('/signup', authController.signUp);

//Logout
router.get('/logout', verifyToken, authController.logout);

//Get user data
router.get('/user', verifyToken, authController.userData);

module.exports = router;
