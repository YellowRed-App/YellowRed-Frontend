const admin = require('firebase-admin');
const functions = require('firebase-functions');

if (admin.apps.length === 0) {
    admin.initializeApp();
}

// function to get active sessions
exports.fetchActiveSessions = functions.https.onRequest(async (req, res) => {
    console.log("Function triggered to get active sessions.");

    const {userId} = req.query;
    if (!userId) {
        console.error("Missing user ID");
        return res.status(400).send('User ID is required');
    }

    try {
        const snapshot = await admin.firestore()
            .collection('users')
            .doc(userId)
            .collection('sessions')
            .where('active', '==', true)
            .get();

        const activeSessions = snapshot.docs.map(doc => ({
            sessionId: doc.id,
            ...doc.data()
        }));

        console.log("Active sessions:", activeSessions);
        res.status(200).json(activeSessions);
    } catch (error) {
        console.error('Error fetching active sessions:', error);
        res.status(500).send('Internal Server Error');
    }
});