import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener("modal:open", this.open.bind(this))
    document.querySelectorAll('.modal-button').forEach(button => {
      button.addEventListener('click', this.open.bind(this));
    });
  }

  disconnect() {
    document.removeEventListener("modal:open", this.open.bind(this))
  }

  open() {
    event.preventDefault();
    this.element.classList.remove('hidden');
  }

  close() {
    event.preventDefault();
    this.element.classList.add('hidden');
  }
}
