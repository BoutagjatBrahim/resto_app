const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const db = require('../config/database');
const { authenticateToken, isStaff } = require('../middleware/auth');

// Get user reservations (pour les clients)
router.get('/', authenticateToken, async (req, res) => {
    try {
        const [reservations] = await db.execute(
            'SELECT * FROM reservations WHERE user_id = ? ORDER BY date DESC, time DESC',
            [req.user.id]
        );
        res.json(reservations);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch reservations' });
    }
});

// Get all reservations (pour les serveurs et admin)
router.get('/all', authenticateToken, isStaff, async (req, res) => {
    try {
        const [reservations] = await db.execute(
            'SELECT r.*, u.name as user_name, u.email as user_email, u.phone as user_phone ' +
            'FROM reservations r ' +
            'JOIN users u ON r.user_id = u.id ' +
            'ORDER BY FIELD(r.status, \'pending\', \'confirmed\', \'cancelled\'), r.date DESC, r.time DESC'
        );
        res.json(reservations);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to fetch reservations' });
    }
});

// Update reservation status (pour les serveurs et admin)
router.patch('/:id/status', authenticateToken, isStaff, [
    body('status').isIn(['pending', 'confirmed', 'cancelled'])
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const [result] = await db.execute(
            'UPDATE reservations SET status = ? WHERE id = ?',
            [req.body.status, req.params.id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Reservation not found' });
        }

        res.json({ message: 'Reservation status updated successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to update reservation status' });
    }
});

// Create new reservation (pour les clients)
router.post('/', authenticateToken, [
    body('date').isDate(),
    body('time').matches(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
    body('number_of_people').isInt({ min: 1, max: 20 }),
    body('special_requests').optional().isString(),
    body('phone').optional().isString(),
    body('name').optional().isString()
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const { date, time, number_of_people, special_requests, phone, name } = req.body;
        
        const [result] = await db.execute(
            'INSERT INTO reservations (user_id, date, time, number_of_people, special_requests, phone, name) ' +
            'VALUES (?, ?, ?, ?, ?, ?, ?)',
            [req.user.id, date, time, number_of_people, special_requests, phone || req.user.phone, name || req.user.name]
        );

        res.status(201).json({
            id: result.insertId,
            message: 'Reservation created successfully'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to create reservation' });
    }
});

// Cancel reservation
router.delete('/:id', async (req, res) => {
    try {
        const [result] = await db.execute(
            'UPDATE reservations SET status = "cancelled" WHERE id = ? AND user_id = ?',
            [req.params.id, req.user.id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Reservation not found' });
        }

        res.json({ message: 'Reservation cancelled successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to cancel reservation' });
    }
});

// Get available slots
router.get('/availability/:date', async (req, res) => {
    try {
        const timeSlots = ['12:00', '12:30', '13:00', '13:30', '19:00', '19:30', '20:00', '20:30', '21:00'];
        const availability = {};

        for (const time of timeSlots) {
            const [result] = await db.execute(
                'SELECT SUM(number_of_people) as total FROM reservations WHERE date = ? AND time = ? AND status != "cancelled"',
                [req.params.date, time]
            );

            availability[time] = 20 - (result[0].total || 0);
        }

        res.json(availability);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to check availability' });
    }
});

module.exports = router;