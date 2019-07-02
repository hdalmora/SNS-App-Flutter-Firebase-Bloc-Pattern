import firebase_admin
from firebase_admin import credentials, firestore, auth
from reselpy_randomizer import randomizer

credentials = credentials.Certificate('./ServiceAccountKey.json')
default_app = firebase_admin.initialize_app(credentials)
db = firestore.client()

for i in range(5):
    first_name = randomizer.Randomizer.get_random_first_name()
    last_name = randomizer.Randomizer.get_random_last_name()

    user = auth.create_user(
        email=randomizer.Randomizer.get_random_email(first_name, last_name),
        email_verified=True,
        password=u'secret',
        display_name=first_name + ' ' + last_name,
        disabled=False
    )

    doc_ref = db.collection(u'users').document(user.uid)
    doc_ref.set({
        u'about': randomizer.Randomizer.get_random_phrase(5),
        u'arrivalOfJapan': firestore.firestore.SERVER_TIMESTAMP,
        u'email': user.email,
        u'id': user.uid,
        u'industry': u'Software',
        u'language': {
            u'English': u'Basic'
        },
        u'name': user.display_name,
        u'nationality': u'England',
        u'role': u'Registered User'
    })

    print('User #' + str(i + 1) + ' OK')
