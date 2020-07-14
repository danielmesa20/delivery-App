const express = require("express");
const router = express.Router();
const verifyToken = require('../config/token');

//Logout
//router.get('/logout', verifyToken, authController.logout);

//Get user data
//router.get('/user', verifyToken, authController.userData);

module.exports = router;
