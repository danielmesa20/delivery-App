const Product = require("../models/Product");
const Comment = require("../models/Comment");
const Cloudinary = require("../config/cloudinary");
const fs = require('fs-extra');

//Get all products (DELETE)
exports.allProducts = async (req, res) => {
    try {
        const products = await Product.find().select('-description');
        return res.status(200).json({ err: null, products });
    } catch (err) {
        return res.status(400).json({ err });
    }
};

//Get commerce products
exports.commerceProducts = async (req, res) => {
    try {
        const products = await Product.find({ commerce_id: req.params.id });
        return res.status(200).json({ err: null, products });
    } catch (err) {
        return res.status(400).json({ err });
    }
};

//Creaate a new product
exports.newProduct = async (req, res) => {

    const { name, description, available, price, commerce_id } = req.body;
    try {
        //Upload image to Cloudinary
        const result = await Cloudinary.v2.uploader.upload(req.file.path);

        //New Product Object
        const newProduct = new Product({
            name,
            description,
            available,
            price,
            imageURL: result.url,
            public_id: result.public_id,
            commerce_id
        });
        //Save product in MongoDB
        const product = await newProduct.save();
        //Delete image 
        fs.unlinkSync(req.file.path);
        return res.status(200).json({ err: null, product });
    } catch (err) {
        return res.status(400).json({ err });
    }
};

//Update one product
exports.updateProduct = async (req, res) => {

    let { name, description, price, available, imageURL, commerce_id, public_id, id } = req.body;

    if (req.file !== undefined) {
        try {
            //Delete old image of product in Cloudinary
            await Cloudinary.v2.uploader.destroy(public_id);
            //Upload new image to Cloudinary
            const result = await Cloudinary.v2.uploader.upload(req.file.path);
            //Update imageURL and public_id
            imageURL = result.url;
            public_id = result.public_id;
            //Delete image in backend
            fs.unlinkSync(req.file.path);
        } catch (error) {
            console.log("err update cloudinary ", err);
            return res.status(400).json({ err });
        }
    }

    try {
        const product = await Product.findByIdAndUpdate(
            { _id: id },
            {
                name,
                description,
                price,
                available,
                imageURL,
                public_id,
                commerce_id
            },
            {
                new: true,
                upsert: true
            });

        return res.status(200).json({ err: null, product });

    } catch (err) {
        console.log("err update ", err);
        return res.status(400).json({ err });
    }
}

//Delete One product
exports.deleteProduct = async (req, res) => {
    const { idProduct } = req.params;
    try {
        const product = await Product.findByIdAndDelete({ _id: idProduct });
        await Cloudinary.v2.uploader.destroy(product.public_id);
        return res.status(200).json({ err: null });
    } catch (err) {
        return res.status(400).json({ err: 'Error to delete the product id: ',idProduct });
    }
}

//Get one product
exports.findOne = async (req, res) => {
    try {
        //Find product data
        const product = await Product.findById({ _id: req.params.idProduct });
        if (product != null) {
            //Find comments of the product
            const comments = await Comment.find({ product_id: req.params.idProduct });
            if (comments != null) {
                return res.status(200).json({ err: null, product, comments });
            }
            return res.status(200).json({ err: null, product, comments: null });
        } else {
            return res.status(400).json({ err: 'The product id does not exist', product: null });
        }

    } catch (err) {
        return res.status(400).json({ err, product: null, comments: null });
    }
}

//Add comment
exports.addComment = async (req, res) => {

    const { body, user_id, product_id } = req.body;

    console.log("body", product_id);

    const newCommentary = new Comment({
        body,
        user_id,
        product_id,
    });

    try {
        const commentary = await newCommentary.save();
        return res.status(200).json({ comment: commentary });
    } catch (err) {
        console.log("Error add comment: ", err);
        return res.status(400).json({ err });
    }
};