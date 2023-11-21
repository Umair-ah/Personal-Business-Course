import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="edit-filename"
export default class extends Controller {
  connect() {}

  initialize() {
    this.element.setAttribute("data-action", "edit-filename#showEdit");
  }

  showEdit(event) {
    event.preventDefault();
    this.url = this.element.getAttribute("href");
    fetch(this.url, {
      Accept: {
        headers: "text/vnd-turbo-stream.html",
      },
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }
}
