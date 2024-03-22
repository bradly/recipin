import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="planner"
export default class extends Controller {
  static targets = ["plannedList", "availableList"];
  static values = { plannedListUrl: String }

  moveItem() {
    const item = event.target.closest('.planner-item');
    const isPlanned = this.plannedListTarget.contains(item);
    const targetList = isPlanned ? this.availableListTarget : this.plannedListTarget;

    targetList.appendChild(item);

    this.saveList();
  }

  saveList() {
    const headers = {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
    }

    const recipeIds = Array
      .from(this.plannedListTarget.querySelectorAll('.planner-item'))
      .map(item => item.dataset.recipeId);

    const body = JSON.stringify({ plan: { recipe_ids: recipeIds } });

    fetch(this.plannedListUrlValue, {
      method: 'PUT',
      headers: headers,
      body: body
    })
      .then(response => response.json())
      .then(data     => { console.log('Success:', data);  })
      .catch((error) => { console.error('Error:', error); });
  }
}
