const admin = require('firebase-admin');
const fs = require('fs');

// Initialize Firebase Admin with service account
admin.initializeApp({
  credential: admin.credential.cert('path/to/your/serviceAccountKey.json'),
  databaseURL: 'https://your-project-id.firebaseio.com',
});

// Read JSON file containing event data
const eventData = JSON.parse(fs.readFileSync('events.json', 'utf8'));

// Get Firestore reference
const db = admin.firestore();

// Loop through each event and add it to the Firestore collection
eventData.forEach(event => {
  db.collection('events').add(event)
    .then(docRef => {
      console.log('Document written with ID: ', docRef.id);
    })
    .catch(error => {
      console.error('Error adding document: ', error);
    });
});