import * as FilePond from "filepond";

document.addEventListener("turbo:load", loadFilePond);

function loadFilePond() {
  // Get a reference to the file input element
  const inputElement = document.querySelector("#files-upload");

  // Create a FilePond instance
  const pond = FilePond.create(inputElement, {
    credits: {},
    storeAsFile: true,
    allowMultiple: true,
    allowReorder: true,
  });
}
