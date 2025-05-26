const express = require('express');
const router = express.Router();
const db = require('../config/database');

// Get all menu items
router.get('/', async (req, res) => {
    try {
        const [items] = await db.execute('SELECT * FROM menu_items WHERE available = true');
        res.json(items);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch menu items' });
    }
});

// Get menu categories
router.get('/categories', async (req, res) => {
    try {
        const [categories] = await db.execute('SELECT DISTINCT category FROM menu_items');
        res.json(categories.map(c => c.category));
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch categories' });
    }
});

module.exports = router;