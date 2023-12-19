const express = require('express');
const bodyParser = require('body-parser');
const twilio = require('twilio');

// Twilio configuration
const twilioAccountSid = 'AC8e52888d3671bc5d5b590dcc1fc3d4a3';
const twilioAuthToken = '4160a19f76dc9b8b4167763eac412b58';
const twilioPhoneNumber = '+12056971499';

const app = express();
app.use(bodyParser.json());

// Initialize Twilio client
const client = new twilio(twilioAccountSid, twilioAuthToken);

app.post('/sendEmergencySMS', (req, res) => {
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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));