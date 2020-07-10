const express = require("express");
const router = express.Router();
const productController = require("../controllers/product_controller");
const verifyToken = require('../config/token');

//Add New Product
router.post('/add', productController.newProduct);

//Update One Product
router.put('/update', productController.updateProduct);

//Find Commerce Products
router.get('/commerceProducts/:id', productController.commerceProducts);

//Delete One Product
router.delete('/delete/:idProduct', productController.deleteProduct);

//Find All Products (DELETE)
router.get('/findAll', productController.allProducts);

//Find One Product
router.get('/findOne/:idProduct', productController.findOne);

//Add comment
router.post('/addComment', verifyToken, productController.addComment);

module.exports = router;
