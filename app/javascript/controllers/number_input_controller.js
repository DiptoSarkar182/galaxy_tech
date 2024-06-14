import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "input" ]

    restrict(event) {
        let input = this.inputTarget;
        let newValue = parseInt(input.value + event.key);
        if (isNaN(newValue) || newValue < 1 || newValue > 5) {
            event.preventDefault();
        }
    }
}