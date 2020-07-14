const express = require("express");
const router = express.Router();
const commerceController = require("../controllers/commerce_controller");

//SignUp Commerce
router.post('/signincommerce', commerceController.signInCommerce);

//SignIn Commerce
router.post('/signupcommerce', commerceController.signUpCommerce);

//Get commerce data
router.get('/commerceData/:id', commerceController.commerceData);

//Reset password
router.put('/resetPasswordCommerce', commerceController.resetPasswordCommerce);

module.exports = router;