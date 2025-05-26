const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const db = require('../config/database');

// Get user reservations
router.get('/', async (req, res) => {
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

// Create reservation
router.post('/', [
    body('date').isISO8601(),
    body('time').matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/),
    body('numberOfPeople').isInt({ min: 1, max: 20 }),
    body('phone').notEmpty(),
    body('name').notEmpty()
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { date, time, numberOfPeople, specialRequests, phone, name } = req.body;

    try {
        // Check availability (20 places per time slot)
        const [existing] = await db.execute(
            'SELECT SUM(number_of_people) as total FROM reservations WHERE date = ? AND time = ? AND status != "cancelled"',
            [date, time]
        );

        const usedSlots = existing[0].total || 0;
        if (usedSlots + numberOfPeople > 20) {
            return res.status(400).json({ error: 'Not enough available slots' });
        }

        // Create reservation
        const [result] = await db.execute(
            'INSERT INTO reservations (user_id, date, time, number_of_people, special_requests, status, phone, name) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [req.user.id, date, time, numberOfPeople, specialRequests || null, 'confirmed', phone, name]
        );

        res.json({
            id: result.insertId,
            userId: req.user.id,
            date,
            time,
            numberOfPeople,
            specialRequests,
            status: 'confirmed',
            phone,
            name
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