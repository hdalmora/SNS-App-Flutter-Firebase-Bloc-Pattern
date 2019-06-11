const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onLikeBlog = functions.firestore
    .document('/blogLikes/{likeId}')
    .onCreate((change, context) => {
        let blogId, userId;
        [blogId, userId] = context.params.likeId.split(':');

        const db = admin.firestore();
        const blogRef = db.collection('blogs').doc(blogId);
        db.runTransaction(t => {
            return t.get(blogRef)
            .then(doc => {
                t.update(blogRef, {
                    likesCounter: (doc.data().likesCounter || 0) + 1
                });
            })
        }).then(result => {
            console.log("Increased aggregate blog like counter");
        }).catch(err => {
            console.log("Failed to increased aggregate blog like counter", err);
        });
    });

exports.onUnlikeBlog = functions.firestore
    .document('/blogLikes/{likeId}')
    .onDelete((change, context) => {
        let blogId, userId;
        [blogId, userId] = context.params.likeId.split(':');

        const db = admin.firestore();
        const blogRef = db.collection('blogs').doc(blogId);
        return db.runTransaction(t => {
            return t.get(blogRef)
            .then(doc => {
                t.update(blogRef, {
                    likesCounter: (doc.data().likesCounter || 0) - 1
                });
            })
        }).then(result => {
            console.log("Decreased aggregate blog like counter");
        }).catch(err => {
            console.log("Failed to decrease aggregate blog like counter", err);
        });
    });