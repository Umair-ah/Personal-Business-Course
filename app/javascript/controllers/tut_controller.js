import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tut"
export default class extends Controller {
  static targets = ["form", "button"];
  connect() {}

  loadBtn() {
    this.buttonTarget.disabled = true;
    this.buttonTarget.value = "Uploading...";
    const spinner = document.getElementById("spinner");
    spinner.classList.remove("d-none");

    const text = document.getElementById("tut-btn-text");
    text.innerHTML = "Uploading...";
    this.formTarget.submit();
  }
}
