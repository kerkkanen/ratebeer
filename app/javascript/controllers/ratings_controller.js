import {Controller} from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
	console.log("Ratings controller connected.");
  }

  destroy() {
	const confirmDelete = confirm(
	  "Are you sure you want to delete these selected ratings?"
	);
	if (!confirmDelete) {
	  return;
	}

	const selectedRatingsIDs = Array.from(
	  document.querySelectorAll('input[name="ratings[]"]:checked'),
	  (checkbox) => checkbox.value
	);

	const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
	const headers = { "X-CSRF-Token": csrfToken };

	fetch("/ratings", {
	  method: "DELETE",
	  headers: headers,
	  body: selectedRatingsIDs.join(","),
	})
	.then((response) => {
	  if (response.ok) {
		response.text().then((html) => {
		  document.querySelector("div.ratings").innerHTML = html;
		});
	  } else {
		throw new Error("Something went wrong");
	  }
	})
	.catch((error) => {
	  console.log(error);
	});
  }

  toggleAll(event) {
	const isChecked = event.target.checked;
	const checkboxes = document.querySelectorAll('input[name="ratings[]"]');
	checkboxes.forEach((checkbox) => {
		checkbox.checked ? checkbox.checked = false : checkbox.checked = true;
	  }
	);
  }
};