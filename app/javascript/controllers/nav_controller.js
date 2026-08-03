import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "openIcon", "closeIcon"]
  static values = { open: { type: Boolean, default: false } }

  toggle() {
    this.openValue = !this.openValue
  }

  close() {
    this.openValue = false
  }

  openValueChanged() {
    if (!this.hasPanelTarget) return
    this.panelTarget.classList.toggle("hidden", !this.openValue)
    this.panelTarget.setAttribute("aria-hidden", (!this.openValue).toString())
    if (this.hasOpenIconTarget) this.openIconTarget.classList.toggle("hidden", this.openValue)
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.toggle("hidden", !this.openValue)
  }
}
