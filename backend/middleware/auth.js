const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Access token required' });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Invalid token' });
        }
        req.user = user;
        next();
    });
}

// Middleware pour vérifier si l'utilisateur est un serveur ou un admin
function isStaff(req, res, next) {
    if (req.user.role !== 'serveur' && req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Access denied. Staff only.' });
    }
    next();
}

// Middleware pour vérifier si l'utilisateur est un admin
function isAdmin(req, res, next) {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ error: 'Access denied. Admin only.' });
    }
    next();
}

module.exports = {
    authenticateToken,
    isStaff,
    isAdmin
};