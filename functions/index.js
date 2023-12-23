const {sendEmergencySMS} = require('./twilio_functions')
const {deleteLocationUpdatesForRedButton} = require('./cleanup_functions');

exports.sendEmergencySMS = sendEmergencySMS;
exports.deleteLocationUpdatesForRedButton = deleteLocationUpdatesForRedButton;