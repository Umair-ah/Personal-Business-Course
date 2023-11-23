import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="category"
export default class extends Controller {
  static targets = ["dropdown", "vidsList"];
  connect() {
    // Attach the click event listener to the dropdown element
    this.dropdownTarget.addEventListener("click", () => this.slide());
  }

  initialize() {
    this.element.setAttribute("data-action", "category#slide");
  }

  slide() {
    const vidsList = this.vidsListTarget;

    // Toggle the 'd-none' class in the vidsList element
    vidsList.classList.toggle("d-none");
  }
}
