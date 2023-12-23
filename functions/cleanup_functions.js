const functions = require('firebase-functions');
const admin = require('firebase-admin');

if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.deleteLocationUpdatesForRedButton = functions.pubsub.schedule('every 24 hours').onRun(() => {
    console.log("Scheduled cleanup function triggered");

    const db = admin.firestore();
    const sevenDaysAgo = admin.firestore.Timestamp.now().toDate();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    db.collectionGroup('locationUpdates')
        .where('deactivationTime', '<=', sevenDaysAgo)
        .get()
        .then(snapshot => {
            console.log(`Found ${snapshot.size} location updates to delete`);
            let batch = db.batch();
            snapshot.docs.forEach(doc => batch.delete(doc.ref));
            return batch.commit();
        })
        .then(() => {
            console.log('Successfully deleted location updates.');
            return null;
        })
        .catch(error => {
            console.error('Error deleting location updates:', error);
            return null;
        });
});
