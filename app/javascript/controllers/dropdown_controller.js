import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "trigger", "menu" ]

    connect() {
        this.timeoutId = null;
    }

    showMenu() {
        clearTimeout(this.timeoutId);
        this.menuTarget.classList.remove('hidden');
    }

    hideMenu() {
        this.timeoutId = setTimeout(() => {
            this.menuTarget.classList.add('hidden');
        }, 200);
    }
}