import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["amount", "abv", "price", "customAmount"];
  static values = { vat: Number };

  connect() {
	console.log("Calculator controller connected.");
  }

  calculate(event) {
	event.preventDefault();
	let amount = this.amountTarget.value;
	amount = amount === "Custom" ? parseFloat(this.customAmountTarget.value) : parseFloat(amount);
	const abv = parseFloat(this.abvTarget.value);
	const price = parseFloat(this.priceTarget.value);
	// Amounts of alcohol tax per liter of pure alcohol for beers.
	let alcoholTax = 0;
	switch (true) {
	  case (abv < 0.5):
		alcoholTax = 0;
	  case (abv <= 3.5):
		alcoholTax = 0.2835;
	  case (abv > 3.5):
		alcoholTax = 0.3805;
	}
	const beerTax = (amount * abv * alcoholTax);
	const vatAmount = (price - price / (1.0 + this.vatValue));
	const taxPercentage = ((beerTax + vatAmount) / price * 100);

	// search for the element where the result is shown
	const result = document.getElementById("result")
	result.innerHTML = `
        <p>Beer has ${beerTax.toFixed(2)} € of alcohol tax and ${vatAmount.toFixed(2)} € of value added tax.</p>
        <p> ${taxPercentage.toFixed(1)} % of the price is taxes.</p>`
  }

  reset(event) {
	event.preventDefault();
	this.amountTarget.value = "0";
	this.abvTarget.value = "0";
	this.priceTarget.value = "0";
  }

  change(event) {
	const customInput = document.getElementById("customInput")
	if (event.target.value === "Custom") {
	  customInput.innerHTML = `
              <label>Custom amount</label>
      			<input type="number" min="0" step="0.01" value="0.00" data-calculator-target="customAmount"/>
      		  <label>liters</label>`
	} else {
	  customInput.innerHTML = ""
	}
  }
}