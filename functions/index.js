const functions = require('firebase-functions');
const twilio = require('twilio');

// Twilio configuration from Firebase config
const twilioAccountSid = functions.config().twilio.sid;
const twilioAuthToken = functions.config().twilio.token;
const twilioPhoneNumber = functions.config().twilio.phone;

const client = new twilio(twilioAccountSid, twilioAuthToken);

exports.sendEmergencySMS = functions.https.onRequest((req, res) => {
    const { contacts, message } = req.body;

    if (!contacts || !message) {
        return res.status(400).send('Contacts and message are required');
    }

    const smsPromises = contacts.map(contact => {
        return client.messages.create({
            to: contact,
            from: twilioPhoneNumber,
            body: message
        });
    });

    Promise.all(smsPromises)
        .then(results => res.status(200).json({ success: true, results }))
        .catch(error => res.status(500).json({ success: false, error: error.message }));
});