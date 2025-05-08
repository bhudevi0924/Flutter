// web/firebase-messaging-sw.js
importScripts("https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyDgsPO4_zGo276K9ZlQ3LNmG7tm6d-xSqQ",
    appId: "1:1024277013397:web:68995a4e52a7852a2b8c9c",
    messagingSenderId: "1024277013397",
    projectId: "foodapp-92083",
    authDomain: "foodapp-92083.firebaseapp.com", // only for web
    storageBucket: "foodapp-92083.firebasestorage.app",
    measurementId: "G-44PHM71E1M",
});

const messaging = firebase.messaging();
