import {Controller} from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["nameInput", "yearInput", "name", "year", "checkbox"];

  connect() {
	console.log("Form controller connected.");
  }

  emptyFields() {
	this.nameInputTarget.value = "";
	this.yearInputTarget.value = "";
	this.checkboxTarget.checked = false;
  }

  selectBrewery(event) {
	const selectedOption = event.target.options[event.target.selectedIndex];
	const name = selectedOption.dataset.name;
	const year = selectedOption.dataset.year;
	this.nameInputTarget.value =  name;
	year ? this.yearInputTarget.value = parseInt(year) : this.yearInputTarget.value = "";
  }
};