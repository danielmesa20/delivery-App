if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config();
}

const app = require('./app');

//Database
require('./database');

//Server
async function main(){
  try{
    app.listen(app.get('port'), () => {
      console.log('Listening on port', app.get('port'));
    });
  }catch(e){
    console.log('Error al iniciar el servidor: ', e);
  }
}

//Run Server
main();

