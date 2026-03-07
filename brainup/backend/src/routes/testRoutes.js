const router = require('express').Router();
const notificationService = require('../services/notificationService');

router.post('/test-notification', async (req, res) => {
    try {
        const {user_id} = req.body;

        await notificationService.sendInstantNotification(
            [user_id],
            'Test Notification',
            'Tap untuk membuka jadwal',
            {
                type: 'jadwal_reminder',
                deep_link: 'brainup://jadwal',
            }
        );
        res.status(200).json({
            success: true,
            message: 'Notification sent!'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

module.exports = router;