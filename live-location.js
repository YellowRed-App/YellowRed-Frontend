const firebaseConfig = {
    apiKey: "AIzaSyBQp_oLkx1l0fc8jFdZA5NfftqB-mU04Bw",
    authDomain: "yellowred-app.firebaseapp.com",
    projectId: "yellowred-app",
    storageBucket: "yellowred-app.appspot.com",
    messagingSenderId: "21183287",
    appId: "1:21183287:web:165fde11bb32da751f78b2",
    measurementId: "G-VZ2Z1WW24Q"
};

firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();

let userFullName = '';

function getSessionIdFromUrl() {
    const params = new URLSearchParams(window.location.search);
    return params.get('session');
}

function getUserIdFromSessionId(sessionId) {
    return db.collectionGroup('sessions')
        .where(db.FieldPath.documentId(), '==', sessionId)
        .get()
        .then(snapshot => {
            if (!snapshot.empty) {
                const sessionDoc = snapshot.docs[0];
                return sessionDoc.ref.parent.parent.id;
            } else {
                throw new Error('Session not found');
            }
        })
        .catch(error => {
            console.error("Error finding user for session:", error);
            throw error;
        });
}

function getUserFullNameFromUserId(userId) {
    return db.collection('users').doc(userId).get()
        .then(userDoc => {
            if (userDoc.exists) {
                const userData = userDoc.data();
                return userData.fullName || 'No name available';
            } else {
                throw new Error('User not found');
            }
        })
        .catch(error => {
            console.error("Error fetching user's full name:", error);
            throw error;
        });
}

function listenToSessionUpdates(sessionId) {
    getUserIdFromSessionId(sessionId)
        .then(userId => {
            getUserFullNameFromUserId(userId)
                .then(fullName => {
                    userFullName = fullName;
                    listenForLocationUpdates(sessionId);
                })
                .catch(error => {
                    console.error("Error fetching user's full name:", error);
                });
        })
        .catch(error => {
            console.error("Error finding user for session:", error);
        });
}

function listenForLocationUpdates(sessionId) {
    db.collectionGroup('sessions')
        .where(db.FieldPath.documentId(), '==', sessionId)
        .onSnapshot(sessionSnapshot => {
            sessionSnapshot.forEach(sessionDoc => {
                sessionDoc.ref.collection('locationUpdates')
                    .orderBy('timestamp', 'desc')
                    .onSnapshot(locationUpdateSnapshot => {
                        locationUpdateSnapshot.docChanges().forEach(change => {
                            if (change.type === 'added') {
                                const locationData = change.doc.data();
                                printLocationData(locationData);
                            }
                        });
                    });
            });
        });
}

function printLocationData(locationData) {
    const updatesDiv = document.getElementById('locationUpdates');
    const updateElement = document.createElement('p');
    updateElement.textContent = `Timestamp: ${locationData.timestamp.toDate().toString()}, Latitude: ${locationData.geopoint.latitude}, Longitude: ${locationData.geopoint.longitude}`;
    updatesDiv.appendChild(updateElement);
}

const sessionId = getSessionIdFromUrl();
if (sessionId) {
    listenToSessionUpdates(sessionId);
} else {
    console.error('Session ID is missing from the URL');
}
