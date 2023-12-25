const admin = require('firebase-admin');
const functions = require('firebase-functions');

if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.deleteOldRedButtonSessions = functions.pubsub.schedule('every 24 hours').onRun(() => {
    console.log("Scheduled cleanup function triggered");

    const db = admin.firestore();

    const now = new Date();
    const sevenDaysAgo = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));

    return db.collectionGroup('sessions')
        .where('endTime', '<=', sevenDaysAgo)
        .get()
        .then(snapshot => {
            console.log(`Found ${snapshot.size} sessions to delete`);
            let batch = db.batch();

            if (snapshot.empty) {
                console.log('No sessions found to delete.');
                return null;
            }

            snapshot.docs.forEach(doc => {
                console.log(`Deleting session with ID: ${doc.id}`);
                batch.delete(doc.ref);
            });

            return batch.commit().then(() => {
                console.log('Successfully deleted old sessions.');
            });
        })
        .catch(error => {
            console.error('Error deleting sessions:', error);
            throw new Error('Error in Firestore operation');
        });
});