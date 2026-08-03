import { Controller } from "@hotwired/stimulus"

// Live chat over Firebase Realtime Database for a single booking path.
export default class extends Controller {
  static targets = ["messages", "input", "status", "presence"]
  static values = {
    path: String,
    user: String,
    config: Object,
    configured: Boolean
  }

  async connect() {
    if (!this.configuredValue || !this.configValue?.databaseURL) {
      this.presenceTarget.textContent = "demo mode"
      this.statusTarget.textContent = "Configure FIREBASE_DATABASE_URL to enable live chat. Local demo messages stay in this browser only."
      this.localMessages = []
      return
    }

    try {
      const { initializeApp } = await import("https://www.gstatic.com/firebasejs/10.14.1/firebase-app.js")
      const {
        getDatabase,
        ref,
        push,
        onChildAdded,
        onDisconnect,
        set,
        serverTimestamp
      } = await import("https://www.gstatic.com/firebasejs/10.14.1/firebase-database.js")

      this.app = initializeApp(this.configValue, `orbit-chat-${this.pathValue}`)
      this.db = getDatabase(this.app)
      this.messagesRef = ref(this.db, this.pathValue)
      this.presenceRef = ref(
        this.db,
        this.pathValue.replace("/messages", "/presence/") + encodeURIComponent(this.userValue)
      )

      await set(this.presenceRef, { online: true, at: serverTimestamp() })
      onDisconnect(this.presenceRef).remove()
      this.presenceTarget.textContent = "online"

      onChildAdded(this.messagesRef, (snapshot) => {
        this.appendMessage(snapshot.val())
      })

      this.push = push
      this.serverTimestamp = serverTimestamp
    } catch (error) {
      this.presenceTarget.textContent = "offline"
      this.statusTarget.textContent = error.message
    }
  }

  send(event) {
    event.preventDefault()
    const text = this.inputTarget.value.trim()
    if (!text) return

    const payload = {
      user: this.userValue,
      text,
      createdAt: Date.now()
    }

    if (this.messagesRef && this.push) {
      this.push(this.messagesRef, {
        ...payload,
        createdAt: this.serverTimestamp()
      })
    } else {
      this.localMessages = this.localMessages || []
      this.localMessages.push(payload)
      this.appendMessage(payload)
    }

    this.inputTarget.value = ""
  }

  appendMessage(message) {
    const row = document.createElement("div")
    row.className = "rounded-sm bg-white/10 px-2 py-1"
    row.innerHTML = `<strong>${this.escape(message.user || "Someone")}:</strong> ${this.escape(message.text || "")}`
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
