const functions = require('firebase-functions');

if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config();
}

const twilio = require('twilio');

const twilioAccountSid = process.env.NODE_ENV === 'production'
    ? functions.config().twilio.sid
    : process.env.TWILIO_ACCOUNT_SID;
const twilioAuthToken = process.env.NODE_ENV === 'production'
    ? functions.config().twilio.token
    : process.env.TWILIO_AUTH_TOKEN;
const twilioPhoneNumber = process.env.NODE_ENV === 'production'
    ? functions.config().twilio.phone
    : process.env.TWILIO_PHONE_NUMBER;

const client = new twilio(twilioAccountSid, twilioAuthToken);

exports.sendEmergencySMS = functions.https.onRequest((req, res) => {
    console.log("Function triggered with body:", req.body);

    const { contacts, message } = req.body;

    if (!contacts || !message) {
        console.log("Missing contacts or message");
        return res.status(400).send('Contacts and message are required');
    }

    console.log("Sending messages to contacts:", contacts);

    const smsPromises = contacts.map(contact => {
        return client.messages.create({
            to: contact,
            from: twilioPhoneNumber,
            body: message
        });
    });

    Promise.all(smsPromises)
        .then(results => {
            console.log("Messages sent:", results);
            res.status(200).json({ success: true, results })
        })
        .catch(error => {
            console.error("Error sending messages:", error);
            res.status(500).json({ success: false, error: error.message });
        });
});