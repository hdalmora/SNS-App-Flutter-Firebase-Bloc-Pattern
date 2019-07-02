import firebase_admin
from firebase_admin import credentials, firestore, auth
from reselpy_randomizer import randomizer

credentials = credentials.Certificate('./ServiceAccountKey.json')
default_app = firebase_admin.initialize_app(credentials)
db = firestore.client()

for i in range(5):
    doc_ref = db.collection(u'blogs').document()
    doc_ref.set({
        u'authorEmail': u'dal@email.com',
        u'authorID': u'2zzLa9akToOdVK13pIuTiudy2za2',
        u'content': randomizer.Randomizer.get_random_phrase(10),
        u'likesCounter': 0,
        u'timestamp': firestore.firestore.SERVER_TIMESTAMP,
        u'title': randomizer.Randomizer.get_random_phrase(3)
    })

    print('Blog #' + str(i + 1) + ' OK')
