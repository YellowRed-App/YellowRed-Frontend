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

function getParamsFromUrl() {
    const params = new URLSearchParams(window.location.search);
    return {
        userId: params.get('user'),
        sessionId: params.get('session')
    };
}

function listenToSessionUpdates(userId, sessionId) {
    db.collection('users').doc(userId)
        .collection('sessions').doc(sessionId)
        .collection('locationUpdates')
        .orderBy('timestamp', 'desc')
        .onSnapshot(snapshot => {
            snapshot.docChanges().forEach(change => {
                if (change.type === 'added') {
                    const locationData = change.doc.data();
                    printLocationData(locationData);
                }
            });
        });
}

function printLocationData(locationData) {
    const updatesDiv = document.getElementById('locationUpdates');
    const updateElement = document.createElement('p');
    updateElement.textContent = `Timestamp: ${locationData.timestamp.toDate().toString()}, Latitude: ${locationData.geopoint.latitude}, Longitude: ${locationData.geopoint.longitude}`;
    updatesDiv.appendChild(updateElement);
}

const {userId, sessionId} = getParamsFromUrl();
if (userId && sessionId) {
    listenToSessionUpdates(userId, sessionId);
} else {
    console.error('User ID or Session ID is missing from the URL');
}