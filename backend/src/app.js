var express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
import { v4 as uuidv4 } from 'uuid';
if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config();
}
//Database
require('./database');

//Initializations
var app = express();

//Socket.io
var server = require('http').createServer(app);
var io = require('socket.io')(server);

//Reserved Events
let ON_CONNECTION = 'connection';
let ON_DISCONNECT = 'disconnect';

//Main Events
let EVENT_IS_USER_ONLINE = 'check_online';
let EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';

//Sub Events
let SUB_EVENT_RECEIVE_MESSAGE = 'receive_message';
let SUB_EVENT_MESSAGE_FROM_SERVER = 'message_from_server';
let SUB_EVENT_IS_USER_CONNECTED = 'is_user_connected';

//Status
let STATUS_MESSAGE_NOT_SENT = 10001;
let STATUS_MESSAGE_SENT = 10002;

// This map has all users connected
const userMap = new Map();

io.sockets.on(ON_CONNECTION, function (socket) {
    onEachUserConnection(socket);
});

function onEachUserConnection(socket) {
    print("-------------------");
    print("Connected => Socket ID: " + socket.id + ", User: " + stringifyToJson(socket.handshake.query));
    var from_user_id = socket.handshake.query.from;
    // Add to Map
    let userMapVal = {socket_id : socket.id};
    addUserToMap(from_user_id, userMapVal);
    printNumOnlineUsers();
    onMessage(socket);
    checkOnline(socket);
    onDisconnect(socket);
}

// CHECK if a user is online
function checkOnline(socket) {
	socket.on(EVENT_IS_USER_ONLINE, function (chat_user_data) {
		checkOnlineHandler(socket, chat_user_data);
	});
}

function checkOnlineHandler(socket, chat_user_data) {
	let to_user_id = chat_user_data.to;
	print('Checking Online User: ' + to_user_id);

	let to_user_socket_id = getSocketIDfromMapForthisUser(`${to_user_id}`);
	let user_online = userFoundOnMap(to_user_id);

	print('To User Socket ID: ' + to_user_socket_id);

	chat_user_data.message_sent_status = user_online ? STATUS_MESSAGE_SENT : STATUS_MESSAGE_NOT_SENT;
	chat_user_data.to_user_online_status = user_online ? true : false;
	sendBackToClient(socket, SUB_EVENT_IS_USER_CONNECTED, chat_user_data);
}


function userFoundOnMap(to_user_id) {
	let to_user_socket_id = getSocketIDfromMapForthisUser(to_user_id);
	return to_user_socket_id != undefined;
}


// This is for Private Chat/Single Chat
function onMessage(socket) {
	socket.on(EVENT_SINGLE_CHAT_MESSAGE, function (chat_message) {
		singleChatHandler(socket, chat_message);
	});
}

function singleChatHandler(socket, chat_message) {
	//
	print('Message: ' + stringifyToJson(chat_message));
	// Get the 'to' User...
	let to_user_id = chat_message.to;
	let from_user_id = chat_message.from;
	print(from_user_id + '=>' + to_user_id);

	let to_user_socket_id = getSocketIDfromMapForthisUser(to_user_id);
	let userOnline = userFoundOnMap(to_user_id);

	print('to_user_socket_id: ' + to_user_socket_id + ', userOnline: ' + userOnline);

	if (!userOnline) {
		print('To Chat User not connected.');
		chat_message.message_sent_status = STATUS_MESSAGE_NOT_SENT;
		chat_message.to_user_online_status = false;
		sendBackToClient(socket, SUB_EVENT_MESSAGE_FROM_SERVER, chat_message);
		return;
	}

	// User Connected and his Socket ID Found on the UserMap
	chat_message.message_sent_status = STATUS_MESSAGE_SENT;
	chat_message.to_user_online_status = true;
	sendToConnectedSocket(socket, to_user_socket_id, SUB_EVENT_RECEIVE_MESSAGE, chat_message);

	// Sending Status back to Client
	// Update the Chat ID and send back
	chat_message.message_sent_status = STATUS_MESSAGE_SENT;
	chat_message.to_user_online_status = false;
	sendBackToClient(socket, SUB_EVENT_MESSAGE_FROM_SERVER, chat_message);

    print('Message Sent!!');
    
}
function sendToConnectedSocket(socket, to_user_socket_id, event, message) {
	socket.to(`${to_user_socket_id}`).emit(event, stringifyToJson(message));
}

function sendBackToClient(socket, event, message) {
	socket.emit(event, stringifyToJson(message));
}

function getSocketIDfromMapForthisUser(to_user_id) {
	let userMapVal = userMap.get(`${to_user_id}`);
	if (userMapVal == undefined) {
		return undefined;
	}
	return userMapVal.socket_id;
}

function onDisconnect(socket) {
    socket.on(ON_DISCONNECT, function () {
        print("Disconnected " + socket.id);
        removeUserWithSocketIdFromMap(socket.id),
        socket.removeAllListeners(SUB_EVENT_RECEIVE_MESSAGE);
		socket.removeAllListeners(SUB_EVENT_IS_USER_CONNECTED);
        socket.removeAllListeners(ON_DISCONNECT);
    });
}

function addUserToMap(key_user_id, val) {
	userMap.set(key_user_id, val);
}


function printNumOnlineUsers() {
	print('Online Users: ' + userMap.size);
}

function print(txt) {
    console.log(txt);
}

function stringifyToJson(data) {
    return JSON.stringify(data);
}

function removeUserWithSocketIdFromMap(socket_id) {
	print('Deleting user with socket id: ' + socket_id);
	let toDeleteUser;
	for (let key of userMap) {
		// index 1, returns the value for each map key
		let userMapValue = key[1];
		if (userMapValue.socket_id == socket_id) {
			toDeleteUser = key[0];
		}
	}
	print('Deleting User: ' + toDeleteUser);
	if (undefined != toDeleteUser) {
		userMap.delete(toDeleteUser);
	}
	print(userMap);
	printNumOnlineUsers();
}

//OLD CODE (PRETTY CODE JAJA)

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
    console.log('Error al iniciar el servidor');
}

module.exports = app;
