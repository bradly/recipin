import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="planner"
export default class extends Controller {
  static targets = ["plannedList", "availableList"];

  moveItem() {
    const item = event.target.closest('.planner-item');
    const isPlanned = this.plannedListTarget.contains(item);
    const targetList = isPlanned ? this.availableListTarget : this.plannedListTarget;

    targetList.appendChild(item);
  }
}
