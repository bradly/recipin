import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel"];

  connect() {
    this.close();

    document.addEventListener("modal:open", this.open.bind(this))
    document.querySelectorAll('.modal-button').forEach(button => {
      button.addEventListener('click', this.open.bind(this));
    });
  }

  disconnect() {
    document.removeEventListener("modal:open", this.open.bind(this))
  }

  open(event) {
    if (event) event.preventDefault();

    // Apply the 'entering' transition classes for the backdrop
    this.backdropTarget.classList.remove("opacity-0");
    this.backdropTarget.classList.add("opacity-100", "ease-out", "duration-300", "transition-opacity");

    // Apply the 'entering' transition classes for the panel
    this.panelTarget.classList.remove("opacity-0", "translate-y-4", "sm:translate-y-0", "sm:scale-95");
    this.panelTarget.classList.add("opacity-100", "translate-y-0", "sm:scale-100", "ease-out", "duration-300", "transition-opacity");

    // Make the modal visible
    this.element.classList.remove('hidden');
  }

  close(event) {
    if (event) event.preventDefault();

    // Apply the 'leaving' transition classes for the backdrop
    this.backdropTarget.classList.remove("opacity-100", "ease-out", "duration-300");
    this.backdropTarget.classList.add("opacity-0", "ease-in", "duration-200", "transition-opacity");

    // Apply the 'leaving' transition classes for the panel
    this.panelTarget.classList.remove("opacity-100", "translate-y-0", "sm:scale-100", "ease-out", "duration-300");
    this.panelTarget.classList.add("opacity-0", "translate-y-4", "sm:translate-y-0", "sm:scale-95", "ease-in", "duration-200", "transition-opacity");

    // Optionally, add a delay before hiding the modal to allow the transition to complete
    setTimeout(() => {
      this.element.classList.add('hidden');
    }, 200); // Match the duration of the longest leaving transition
  }
}
