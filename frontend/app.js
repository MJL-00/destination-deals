const locationSelect =
    document.getElementById('locationSelect');

const categorySelect =
    document.getElementById('categorySelect');

const daySelect =
    document.getElementById('daySelect');

const searchBtn =
    document.getElementById('searchBtn');

const results =
    document.getElementById('results');




// LOAD FUNCTIONS

async function loadLocations() {

    const response =
        await fetch(
            'http://localhost:3000/locations'
        );

    const locations =
        await response.json();

    locations.forEach(location => {

        const option =
            document.createElement('option');

        option.value =
            location.city;

        option.textContent =
            location.city;

        locationSelect.appendChild(option);

    });

}





async function loadCategories() {

    const response =
        await fetch(
            'http://localhost:3000/categories'
        );

    const categories =
        await response.json();

    categories.forEach(category => {

        const option =
            document.createElement('option');

        option.value =
            category.categoryname;

        option.textContent =
            category.categoryname;

        categorySelect.appendChild(option);

    });

}



loadLocations();
loadCategories();
// END OF LOAD FUNCTIONS





//SEARCH FUNCTIONS
async function searchDeals() {

    const city = locationSelect.value;
    const category = categorySelect.value;
    const day = daySelect.value;


    let url = '';

        if (category && day) {

                url = `http://localhost:3000/deals/location/${city}/category/${category}/day/${day}`;

        } else if (category) {

                url = `http://localhost:3000/deals/location/${city}/category/${category}`;

        } else if (day) {

              url = `http://localhost:3000/deals/location/${city}/day/${day}`;

        } else {

                url = `http://localhost:3000/deals/location/${city}`;
        }   





    const response =
        await fetch(url);

    const deals =
        await response.json();

    displayDeals(deals);

}



function formatTime(timeString) {

    const date =
        new Date(
            `1970-01-01T${timeString}`
        );

    return date.toLocaleTimeString(
        [],
        {
            hour: 'numeric',
            minute: '2-digit'
        }
    );

}



function displayDeals(deals) {

    results.innerHTML = '';

    if (deals.length === 0) {

        results.innerHTML = `
            <div class="deal-card">
                No deals found for the selected filters.
            </div>
        `;

        return;
    }

    deals.forEach(deal => {

        const card = document.createElement('div');

        card.classList.add('deal-card');

        card.innerHTML = `

            <div class="deal-header">

                <h3>${deal.title}</h3>

                <span class="business-name">
                    ${deal.name}
                </span>

            </div>

            <p class="description">
                ${deal.description}
            </p>

            <div class="deal-details">

                <p>
                    <strong>Days:</strong>
                    ${deal.dayofweek}
                </p>

                <p>
                    <strong>Time:</strong>
                    ${formatTime(deal.starttime)}
                    -
                    ${formatTime(deal.endtime)}
                </p>

            </div>

            ${deal.website ? `

                <div class="card-footer">

                    <a
                        href="https://${deal.website}"
                        target="_blank"
                        class="website-btn">

                        Visit Website

                    </a>

                </div>

            ` : ''}

        `;

        results.appendChild(card);

    });

}






searchBtn.addEventListener(
    'click',
    searchDeals
);






window.onload = () => {

    setTimeout(() => {

        searchDeals();

    }, 500);

};