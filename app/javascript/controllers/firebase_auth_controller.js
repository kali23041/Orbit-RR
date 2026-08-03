import { Controller } from "@hotwired/stimulus"

// Signs in with Firebase Auth (Google), then posts the ID token to Rails.
export default class extends Controller {
  static targets = ["status"]
  static values = {
    config: Object,
    configured: Boolean
  }

  async signIn() {
    this.clearStatus()

    if (!this.configuredValue || !this.configValue?.apiKey) {
      this.setStatus("Add Firebase keys to .env, then restart bin/dev. Or use Dev login on the home page.")
      return
    }

    try {
      const { initializeApp } = await import("https://www.gstatic.com/firebasejs/10.14.1/firebase-app.js")
      const { getAuth, GoogleAuthProvider, signInWithPopup } = await import("https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js")

      const app = initializeApp(this.configValue)
      const auth = getAuth(app)
      const result = await signInWithPopup(auth, new GoogleAuthProvider())
      const idToken = await result.user.getIdToken()

      const response = await fetch("/session", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ id_token: idToken })
      })

      const data = await response.json()
      if (!response.ok || !data.ok) {
        throw new Error(data.error || "Sign-in failed")
      }

      window.location.href = data.redirect_to || "/dashboard"
    } catch (error) {
      this.setStatus(error.message)
    }
  }

  setStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message
  }

  clearStatus() {
    this.setStatus("")
  }
}
