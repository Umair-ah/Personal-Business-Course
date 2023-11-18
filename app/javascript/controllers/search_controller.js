import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  searchNow() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.closest("form").requestSubmit();
    }, 200);
  }
}
