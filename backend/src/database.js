const mongoose = require('mongoose');

const { HOST, DATABASE } = process.env;
const URI = `mongodb://${HOST}/${DATABASE}`;

mongoose.connect(URI,{
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
    useFindAndModify: false,
}).then(db => console.log('Conexión establecida correctamente con la base de datos'))
  .catch(err => console.error(err));