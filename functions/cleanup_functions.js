const functions = require('firebase-functions');
const admin = require('firebase-admin');

if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.deleteLocationUpdatesForRedButton = functions.pubsub.schedule('every 24 hours').onRun(() => {
    console.log("Scheduled cleanup function triggered");

    const db = admin.firestore();

    const now = new Date();
    const sevenDaysAgo = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));

    return db.collectionGroup('locationUpdates')
        .where('deactivationTime', '<=', sevenDaysAgo)
        .get()
        .then(snapshot => {
            console.log(`Found ${snapshot.size} location updates to delete`);
            let batch = db.batch();

            if (snapshot.empty) {
                console.log('No location updates found to delete.');
                return null;
            }

            snapshot.docs.forEach(doc => {
                console.log(`Deleting document with ID: ${doc.id}`);
                batch.delete(doc.ref);
            });

            return batch.commit().then(() => {
                console.log('Successfully deleted location updates.');
            });
        })
        .catch(error => {
            console.error('Error deleting location updates:', error);
            throw new Error('Error in Firestore operation');
        });
});
