import { Controller } from "@hotwired/stimulus"
import { getFirebaseAuth, loadAuthHelpers } from "firebase/app"

export default class extends Controller {
  static targets = ["status"]
  static values = {
    config: Object,
    configured: Boolean
  }

  async signIn() {
    this.clearStatus()

    if (!this.configuredValue || !this.configValue?.apiKey) {
      this.setStatus("Add Firebase keys to .env, then restart. Or use Dev login on the home page.")
      return
    }

    try {
      const auth = await getFirebaseAuth(this.configValue)
      const { GoogleAuthProvider, signInWithPopup } = await loadAuthHelpers()
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
