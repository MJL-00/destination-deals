const locationSelect = document.getElementById('locationSelect');
const categorySelect = document.getElementById('categorySelect');
const daySelect = document.getElementById('daySelect');
const searchBtn = document.getElementById('searchBtn');
const results = document.getElementById('results');

// SEARCH BUTTON DISABLED UNTIL LOCATION IS SELECTED
locationSelect.addEventListener('change', () => {
    if (locationSelect.value) {
        searchBtn.disabled = false;
    } else {
        searchBtn.disabled = true;
    }
});

// LOAD FUNCTIONS
async function loadLocations() {
    const response = await fetch(`${API_URL}/locations`);
    const locations = await response.json();

    locations.forEach(location => {
        const option = document.createElement('option');
        option.value = location.city;
        option.textContent = location.city;
        locationSelect.appendChild(option);
    });
}

async function loadCategories() {
    const response = await fetch(`${API_URL}/categories`);
    const categories = await response.json();

    categories.forEach(category => {
        const option = document.createElement('option');
        option.value = category.categoryname;
        option.textContent = category.categoryname;
        categorySelect.appendChild(option);
    });
}

loadLocations();
loadCategories();
// END OF LOAD FUNCTIONS

// SEARCH FUNCTIONS
async function searchDeals() {
    const city = locationSelect.value;
    const category = categorySelect.value;
    const day = daySelect.value;

    if (!city) {
        alert('Please select a location.');
        return;
    }

    let url = '';

    if (category && day) {
        url = `${API_URL}/deals/location/${city}/category/${category}/day/${day}`;
    } else if (category) {
        url = `${API_URL}/deals/location/${city}/category/${category}`;
    } else if (day) {
        url = `${API_URL}/deals/location/${city}/day/${day}`;
    } else {
        url = `${API_URL}/deals/location/${city}`;
    }   

    results.innerHTML = '<div class="loading">Loading deals...</div>';

    const response = await fetch(url);
    const deals = await response.json();
    displayDeals(deals);
}

function formatTime(timeString) {
    const date = new Date(`1970-01-01T${timeString}`);
    return date.toLocaleTimeString([], {
        hour: 'numeric',
        minute: '2-digit'
    });
}

function displayDeals(deals) {
    results.innerHTML = `
        <div class="deal-count">
            Showing ${deals.length} deal${deals.length !== 1 ? 's' : ''} in ${locationSelect.value}
        </div>
    `;

    if (deals.length === 0) {
        results.innerHTML += `
            <div class="deal-card">
                No deals found for the selected filters.
            </div>
        `;
        return;
    }

    deals.forEach(deal => {
        const card = document.createElement('div');
        card.classList.add('deal-card');

        // Compile Option A layout elements safely for local search targeting
        const street = deal.address || '';
        const city = deal.city || '';
        const state = deal.state || '';
        const fullSearchAddress = `${street}, ${city}, ${state}`;

        card.innerHTML = `
            <div class="deal-header">
                <h3 class="business-header">${deal.name}</h3>
                <div class="deal-title">${deal.title}</div>
            </div>

            <p class="description">${deal.description}</p>
            <p class="address"><strong>Address: </strong>${street}, ${city}, ${state}</p>
            <div class="deal-details">
                <p><strong>Days:</strong> ${deal.dayofweek}</p>
                <p><strong>Time:</strong> ${formatTime(deal.starttime)} - ${formatTime(deal.endtime)}</p>
            </div>
            <div class="card-footer">

                ${deal.website ? `
                    <a
                        href="${deal.website}"
                        target="_blank"
                        class="website-btn">
                        Visit Website
                    </a>
                ` : ''}

                <a
                    href="https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(fullSearchAddress)}"
                    target="_blank"
                    class="directions-btn">
                    Get Directions
                </a>

            </div>
        `;
        results.appendChild(card);
    });
}

searchBtn.addEventListener('click', searchDeals);