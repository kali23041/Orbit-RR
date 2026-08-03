const FIREBASE_VERSION = "10.14.1"
const CDN = `https://www.gstatic.com/firebasejs/${FIREBASE_VERSION}`

let appPromise = null

export async function getFirebaseApp(config) {
  if (!config?.apiKey) {
    throw new Error("Firebase web config is missing")
  }

  if (!appPromise) {
    appPromise = (async () => {
      const { initializeApp, getApps } = await import(`${CDN}/firebase-app.js`)
      return getApps().length ? getApps()[0] : initializeApp(config)
    })()
  }

  return appPromise
}

export async function getFirebaseAuth(config) {
  const app = await getFirebaseApp(config)
  const { getAuth } = await import(`${CDN}/firebase-auth.js`)
  return getAuth(app)
}

export async function getFirestore(config) {
  const app = await getFirebaseApp(config)
  const { getFirestore } = await import(`${CDN}/firebase-firestore.js`)
  return getFirestore(app)
}

export async function getFirebaseStorage(config) {
  const app = await getFirebaseApp(config)
  const { getStorage } = await import(`${CDN}/firebase-storage.js`)
  return getStorage(app)
}

export async function loadAuthHelpers() {
  return import(`${CDN}/firebase-auth.js`)
}

export async function loadFirestoreHelpers() {
  return import(`${CDN}/firebase-firestore.js`)
}

export async function loadStorageHelpers() {
  return import(`${CDN}/firebase-storage.js`)
}

export function roomCollectionPath(roomId) {
  return `rooms/${roomId}`
}
