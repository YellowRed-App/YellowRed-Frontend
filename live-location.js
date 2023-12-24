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

function getSessionIdFromUrl() {
    const params = new URLSearchParams(window.location.search);
    return params.get('session');
}

function listenToSessionUpdates(sessionId) {
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
