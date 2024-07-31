import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirmation"
export default class extends Controller {
  static targets = ["dialog", "confirmButton", "cancelButton"]

  show(event) {
    event.preventDefault()
    this.dialogTarget.classList.remove("hidden")
  }

  confirm(event) {
    event.preventDefault()
    this.dialogTarget.classList.add("hidden")
    this.element.querySelector("form").submit()
  }

  cancel(event) {
    event.preventDefault()
    this.dialogTarget.classList.add("hidden")
  }
}
