import {Controller} from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["input", "checkbox"];

  connect() {
	console.log("Form controller connected.");
  }

  emptyFields() {
	this.inputTargets.forEach((input) => {
		input.value = "";
	  }
	);
	this.checkboxTarget.checked = false;
  }
};