// app/javascript/controllers/clipboard_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "source", "button" ]

    copy(event) {
        event.preventDefault()
        navigator.clipboard.writeText(this.sourceTarget.textContent)
            .then(() => {
                this.buttonTarget.textContent = 'Copied!'
                setTimeout(() => {
                    this.buttonTarget.textContent = 'Copy Order ID'
                }, 2500)
            })
            .catch(err => {
                console.error('Could not copy text: ', err)
            })
    }
}