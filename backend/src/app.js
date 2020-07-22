var express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
import { v4 as uuidv4 } from 'uuid';

//Initializations
var app = express();

//Connect two servers
app.use(cors());

// Settings
app.set('port', process.env.PORT || 4000);
app.set('views', path.join(__dirname, 'views'));

// Midlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(morgan('dev'));

//Multer (images)
const storage = multer.diskStorage({
    destination: path.join(__dirname, 'public/uploads'),
    filename: (req, file, cb) => {
        cb(null, uuidv4() + path.extname(file.originalname));
    }
});
app.use(multer({ storage }).single('myImage'));

//Global Variables
app.use((req, res, next) => {
    res.locals.user = req.user || null;
    next();
});

// Routes
app.use('/products', require('./routes/products_routes'));
app.use('/commerce', require('./routes/commerce_routes'));

//PORT
app.set("port", process.env.PORT || 4000);

try {
    server.listen(app.get('port'), () => {
        console.log('Listening on port', app.get('port'));
    });
} catch (e) {
    console.log('Error to init the server');
}

module.exports = app;
