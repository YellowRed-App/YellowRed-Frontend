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

let map;
let poly;

function initMap() {
    map = new google.maps.Map(document.getElementById("map"), {
        center: {lat: 38.0293, lng: -78.4767}, zoom: 12
    });

    poly = new google.maps.Polyline({
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 3
    });
    poly.setMap(map);
}

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
                    updateMapWithLocation(locationData);
                }
            });
        });
}

function updateMapWithLocation(locationData) {
    const latLng = new google.maps.LatLng(locationData.geopoint.latitude, locationData.geopoint.longitude);
    const path = poly.getPath();

    path.push(latLng);

    const marker = new google.maps.Marker({
        position: latLng, map: map
    });
    map.setCenter(latLng);
}

const {userId, sessionId} = getParamsFromUrl();
if (userId && sessionId) {
    listenToSessionUpdates(userId, sessionId);
} else {
    console.error('User ID or Session ID is missing from the URL');
}