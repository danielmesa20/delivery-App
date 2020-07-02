const jwt = require('jsonwebtoken');

async function verifyToken(req, res, next) {
    
    const token = req.headers['x-access-token'];

    //CHECK FOR TOKEN
    if (!token)
        return res.status(401).json({ token: null, message: 'No token, authorizaton denied' });

    try {
        // Verify token
        const decoded = jwt.verify(token, process.env.SECRET);
        // Add user from payload
        req.user = decoded;
        next();
    } catch (e) {
        res.status(400).json({ message: 'Token is not valid' });
    }

};

module.exports = verifyToken;