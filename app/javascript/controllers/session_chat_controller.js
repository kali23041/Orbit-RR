import { Controller } from "@hotwired/stimulus"
import {
  getFirestore,
  getFirebaseStorage,
  loadFirestoreHelpers,
  loadStorageHelpers
} from "firebase/app"

// Firestore live room: messages, presence, typing, attachments.
export default class extends Controller {
  static targets = ["messages", "input", "status", "presence", "typing", "file"]
  static values = {
    config: Object,
    configured: Boolean,
    room: Object,
    user: String
  }

  async connect() {
    this.unsubscribers = []
    this.seenIds = new Set()

    if (!this.configuredValue || !this.configValue?.apiKey) {
      this.presenceTarget.textContent = "demo mode"
      this.statusTarget.textContent = "Configure Firebase to enable Firestore chat. Local messages stay in this browser."
      this.localMode = true
      return
    }

    try {
      this.db = await getFirestore(this.configValue)
      this.fs = await loadFirestoreHelpers()
      const roomId = this.roomValue.roomId
      this.roomRef = this.fs.doc(this.db, "rooms", roomId)

      await this.fs.setDoc(this.roomRef, {
        learnerUid: this.roomValue.learnerUid,
        mentorUid: this.roomValue.mentorUid,
        railsBookingId: roomId,
        status: this.roomValue.bookingStatus,
        updatedAt: this.fs.serverTimestamp()
      }, { merge: true })

      await this.fs.setDoc(this.fs.doc(this.db, "user_public", this.roomValue.currentUid), {
        displayName: this.roomValue.displayName,
        role: "participant",
        updatedAt: this.fs.serverTimestamp()
      }, { merge: true })

      await this.joinPresence(roomId)
      await this.postSystemJoin(roomId)
      this.listenMessages(roomId)
      this.listenPresence(roomId)
      this.listenTyping(roomId)
    } catch (error) {
      this.presenceTarget.textContent = "offline"
      this.statusTarget.textContent = error.message
    }
  }

  disconnect() {
    this.unsubscribers.forEach((fn) => fn && fn())
    if (this.typingTimeout) clearTimeout(this.typingTimeout)
  }

  async joinPresence(roomId) {
    const presenceRef = this.fs.doc(this.db, "rooms", roomId, "presence", this.roomValue.currentUid)
    await this.fs.setDoc(presenceRef, {
      displayName: this.roomValue.displayName,
      online: true,
      lastActiveAt: this.fs.serverTimestamp()
    })
    this.presenceTarget.textContent = "online"
  }

  async postSystemJoin(roomId) {
    const key = `orbit-joined-${roomId}-${this.roomValue.currentUid}`
    if (sessionStorage.getItem(key)) return
    await this.fs.addDoc(this.fs.collection(this.db, "rooms", roomId, "messages"), {
      text: `${this.roomValue.displayName} joined the room`,
      senderUid: this.roomValue.currentUid,
      senderName: "Orbit",
      type: "system",
      createdAt: this.fs.serverTimestamp()
    })
    sessionStorage.setItem(key, "1")
  }

  listenMessages(roomId) {
    const q = this.fs.query(
      this.fs.collection(this.db, "rooms", roomId, "messages"),
      this.fs.orderBy("createdAt", "asc")
    )
    const unsub = this.fs.onSnapshot(q, (snap) => {
      snap.docChanges().forEach((change) => {
        if (change.type !== "added") return
        if (this.seenIds.has(change.doc.id)) return
        this.seenIds.add(change.doc.id)
        this.appendMessage(change.doc.data())
      })
    }, (error) => {
      this.statusTarget.textContent = error.message
    })
    this.unsubscribers.push(unsub)
  }

  listenPresence(roomId) {
    const unsub = this.fs.onSnapshot(
      this.fs.collection(this.db, "rooms", roomId, "presence"),
      (snap) => {
        const online = []
        snap.forEach((doc) => {
          const data = doc.data()
          if (data.online) online.push(data.displayName || doc.id)
        })
        this.presenceTarget.textContent = online.length ? online.join(", ") : "empty"
      }
    )
    this.unsubscribers.push(unsub)
  }

  listenTyping(roomId) {
    if (!this.hasTypingTarget) return
    const unsub = this.fs.onSnapshot(
      this.fs.collection(this.db, "rooms", roomId, "typing"),
      (snap) => {
        const names = []
        snap.forEach((doc) => {
          if (doc.id === this.roomValue.currentUid) return
          const data = doc.data()
          if (data.isTyping) names.push(data.displayName || "Someone")
        })
        this.typingTarget.textContent = names.length ? `${names.join(", ")} typing…` : ""
      }
    )
    this.unsubscribers.push(unsub)
  }

  async send(event) {
    event.preventDefault()
    const text = this.inputTarget.value.trim()
    if (!text && !(this.hasFileTarget && this.fileTarget.files[0])) return

    if (this.localMode) {
      this.appendMessage({
        user: this.userValue,
        senderName: this.userValue,
        text: text || "(attachment)",
        type: "text"
      })
      this.inputTarget.value = ""
      return
    }

    try {
      const roomId = this.roomValue.roomId
      let attachment = null
      if (this.hasFileTarget && this.fileTarget.files[0]) {
        attachment = await this.uploadFile(roomId, this.fileTarget.files[0])
        this.fileTarget.value = ""
      }

      await this.fs.addDoc(this.fs.collection(this.db, "rooms", roomId, "messages"), {
        text: text || (attachment ? attachment.name : ""),
        senderUid: this.roomValue.currentUid,
        senderName: this.roomValue.displayName,
        type: attachment ? "file" : "text",
        attachmentPath: attachment?.path || null,
        attachmentName: attachment?.name || null,
        attachmentUrl: attachment?.url || null,
        createdAt: this.fs.serverTimestamp()
      })

      this.inputTarget.value = ""
      await this.setTyping(false)
    } catch (error) {
      this.statusTarget.textContent = error.message
    }
  }

  async uploadFile(roomId, file) {
    const storage = await getFirebaseStorage(this.configValue)
    const { ref, uploadBytes, getDownloadURL } = await loadStorageHelpers()
    const path = `rooms/${roomId}/attachments/${Date.now()}-${file.name}`
    const storageRef = ref(storage, path)
    await uploadBytes(storageRef, file)
    const url = await getDownloadURL(storageRef)
    return { path, name: file.name, url }
  }

  async onType() {
    if (this.localMode) return
    await this.setTyping(true)
    if (this.typingTimeout) clearTimeout(this.typingTimeout)
    this.typingTimeout = setTimeout(() => this.setTyping(false), 1200)
  }

  async setTyping(isTyping) {
    if (!this.db) return
    const roomId = this.roomValue.roomId
    await this.fs.setDoc(
      this.fs.doc(this.db, "rooms", roomId, "typing", this.roomValue.currentUid),
      {
        isTyping,
        displayName: this.roomValue.displayName,
        updatedAt: this.fs.serverTimestamp()
      },
      { merge: true }
    )
  }

  appendMessage(message) {
    const row = document.createElement("div")
    const type = message.type || "text"
    row.className = type === "system"
      ? "rounded-sm px-2 py-1 text-center text-xs text-teal-100/70"
      : "rounded-sm bg-white/10 px-2 py-1"

    if (type === "file" && message.attachmentUrl) {
      row.innerHTML = `<strong>${this.escape(message.senderName || message.user || "Someone")}:</strong>
        <a class="underline" href="${this.escape(message.attachmentUrl)}" target="_blank" rel="noopener">${this.escape(message.attachmentName || "file")}</a>
        ${message.text ? `<span class="block opacity-80">${this.escape(message.text)}</span>` : ""}`
    } else {
      row.innerHTML = `<strong>${this.escape(message.senderName || message.user || "Someone")}:</strong> ${this.escape(message.text || "")}`
    }

    this.messagesTarget.appendChild(row)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  escape(value) {
    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
  }
}
