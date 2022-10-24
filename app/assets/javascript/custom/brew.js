const BREWERIES = {};

const handleResponse = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  const name = tr.appendChild(document.createElement("td"));
  name.innerHTML = brewery.name;
  const year= tr.appendChild(document.createElement("td"));
  year.innerHTML = brewery.year;
  const beers= tr.appendChild(document.createElement("td"));
  beers.innerHTML = brewery.beers.length;
  const active = tr.appendChild(document.createElement("td"));
  active.innerHTML = brewery.active;

  return tr;
};

BREWERIES.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach((brewery) => {
    const tr = createTableRow(brewery);
    table.appendChild(tr);
  });
};

BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BREWERIES.sortByYear = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year > b.year;
  });
};


BREWERIES.sortByBeers = () => {
  BREWERIES.list.sort((a, b) => {
    return a.beers.length > b.beers.length;
  });
};

const breweries = () => {
  if (document.querySelectorAll("#brewerytable").length < 1) return;
  
  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByName();
    BREWERIES.show();
  });

  document.getElementById("year").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByYear();
    BREWERIES.show();
  });

  document.getElementById("beers").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByBeers();
    BREWERIES.show();
  });



  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleResponse);

};

export { breweries };