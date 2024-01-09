const {sendEmergencySMS} = require('./twilio_functions');
const {onNewLocationUpdate, fetchActiveSessions, fetchLocationUpdates} = require('./location_functions');

const {deleteOldRedButtonLocationUpdates} = require('./cleanup_functions');

exports.sendEmergencySMS = sendEmergencySMS;
exports.onNewLocationUpdate = onNewLocationUpdate;
exports.fetchActiveSessions = fetchActiveSessions;
exports.fetchLocationUpdates = fetchLocationUpdates;

exports.deleteOldRedButtonLocationUpdates = deleteOldRedButtonLocationUpdates;