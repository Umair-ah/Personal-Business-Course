import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="course"
export default class extends Controller {
  static targets = ["form", "button"];
  connect() {}

  loadBtn() {
    this.buttonTarget.disabled = true;
    this.buttonTarget.value = "Please Wait... ";
    const spinner = document.getElementById("spinner");
    spinner.classList.remove("d-none");

    const text = document.getElementById("course-btn-text");
    text.innerHTML = "Please Wait...";
    this.formTarget.submit();
  }
}
