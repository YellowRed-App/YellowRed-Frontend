const admin = require('firebase-admin');
const functions = require('firebase-functions');

if (admin.apps.length === 0) {
    admin.initializeApp();
}

exports.deleteOldRedButtonLocationUpdates = functions.pubsub.schedule('every 24 hours').onRun(() => {
    console.log("Scheduled cleanup function triggered");

    const db = admin.firestore();

    const now = new Date();
    const sevenDaysAgo = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));

    return db.collectionGroup('sessions')
        .where('endTime', '<=', sevenDaysAgo)
        .get()
        .then(snapshot => {
            console.log(`Found ${snapshot.size} sessions to delete`);
            const promises = [];

            snapshot.docs.forEach(doc => {
                const locationUpdatesRef = doc.ref.collection('locationUpdates');
                promises.push(deleteCollection(db, locationUpdatesRef, 100));
            });

            return Promise.all(promises).then(() => console.log('Successfully deleted location updates sub-collections.'));
        })
        .catch(error => {
            console.error('Error deleting location updates:', error);
            throw new Error('Error in Firestore operation');
        });
});

function deleteCollection(db, collectionRef, batchSize) {
    let query = collectionRef.orderBy('__name__').limit(batchSize);
    return new Promise((resolve, reject) => deleteQueryBatch(db, query, batchSize, resolve, reject));
}

function deleteQueryBatch(db, query, batchSize, resolve, reject) {
    query.get()
        .then(snapshot => {
            if (snapshot.size === 0) {
                return 0;
            }

            let batch = db.batch();
            snapshot.docs.forEach(doc => batch.delete(doc.ref));
            return batch.commit().then(() => snapshot.size);
        })
        .then(deleted => {
            if (deleted === 0) {
                resolve();
                return;
            }

            process.nextTick(() => deleteQueryBatch(db, query, batchSize, resolve, reject));
        })
        .catch(reject);
}