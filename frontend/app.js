// ============================================================
// Destination Deals — app.js
// ============================================================

// ── State ────────────────────────────────────────────────────
let allDeals        = [];

let dealsLoaded     = false;

// ── Device ID (persistent per browser for page view tracking) ─
function getDeviceId() {
    let id = localStorage.getItem('dd_device_id');
    if (!id) {
        id = 'dev_' + Math.random().toString(36).slice(2) +
             Math.random().toString(36).slice(2);
        localStorage.setItem('dd_device_id', id);
    }
    return id;
}

// ── DOM refs ─────────────────────────────────────────────────
const locationSelect = document.getElementById('locationSelect');
const categorySelect = document.getElementById('categorySelect');
const daySelect      = document.getElementById('daySelect');
const searchInput    = document.getElementById('searchInput');
const sortSelect     = document.getElementById('sortSelect') || { value: 'default', addEventListener: () => {} };
const results        = document.getElementById('results');
const resultsHeader  = document.getElementById('resultsHeader');
const dealCount      = document.getElementById('dealCount');
const filterTags     = document.getElementById('filterTags');
const autocomplete   = document.getElementById('autocompleteDropdown');
const locationBanner = document.getElementById('locationBanner') || { style: {} };

// ── Location permission flow ──────────────────────────────────




// ── Load dropdowns ────────────────────────────────────────────
// city name (lowercase) -> state code, built from locations API
const cityStateMap = {};

async function loadLocations() {
    const res = await fetch(`${API_URL}/locations`);
    const locations = await res.json();
    locations.forEach(loc => {
        // Build lookup so we know the state before deals load
        cityStateMap[loc.city.toLowerCase()] = loc.state;
        const opt = document.createElement('option');
        opt.value = loc.city;
        opt.textContent = `${loc.city}, ${loc.state}`;
        locationSelect.appendChild(opt);
    });
}

async function loadCategories() {
    const res = await fetch(`${API_URL}/categories`);
    const categories = await res.json();
    categories.forEach(cat => {
        const opt = document.createElement('option');
        opt.value = cat.categoryname;
        opt.textContent = cat.categoryname;
        categorySelect.appendChild(opt);
    });
}

// ── Load deals for a specific city only ───────────────────────
// ── Background swap by state ────────────────────────────────────────────
const STATE_BACKGROUNDS = {
    'CT': 'images/backgrounds/ct.png',
    'MA': 'images/backgrounds/ma.png',
    'NY': 'images/backgrounds/ny.png',
    'RI': 'images/backgrounds/ri.png',
    'VT': 'images/backgrounds/vt.png',
};
const DEFAULT_BACKGROUND = 'images/backgrounds/default_background.png';

function setBackgroundForState(stateCode) {
    const img = STATE_BACKGROUNDS[stateCode?.toUpperCase()] || DEFAULT_BACKGROUND;
    const bg = document.getElementById('bgLayer');
    if (bg) bg.style.backgroundImage = `url('${img}')`;
}

async function loadDealsForCity(city) {
    results.innerHTML = '<div class="loading">Loading deals...</div>';
    try {
        const res   = await fetch(`${API_URL}/deals/location/${encodeURIComponent(city)}`);
        allDeals    = await res.json();
        dealsLoaded = true;

        // Log page view — fire and forget, never blocks UI
        const state = cityStateMap[city.toLowerCase()] || null;
        fetch(`${API_URL}/pageviews/city`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ city, state, device_id: getDeviceId() })
        }).catch(() => {});

        document.getElementById('searchGroup').style.display = '';
        applyFilters();
    } catch (e) {
        results.innerHTML = '<div class="welcome-card"><p>Could not load deals. Please try again.</p></div>';
        console.error(e);
    }
}

// ── Show welcome state (no location selected) ─────────────────
function showWelcomeState() {
    allDeals    = [];
    dealsLoaded = false;
    document.getElementById('searchGroup').style.display = 'none';
    resultsHeader.style.display = 'none';
    results.innerHTML = '';
}

// ── Autocomplete ──────────────────────────────────────────────
searchInput.addEventListener('input', () => {
    const q = searchInput.value.toLowerCase().trim();
    autocomplete.innerHTML = '';

    if (!q || q.length < 2 || !dealsLoaded) {
        autocomplete.style.display = 'none';
        if (dealsLoaded) applyFilters();
        return;
    }

    const suggestions = new Set();
    allDeals.forEach(d => {
        if (d.name  && d.name.toLowerCase().includes(q))  suggestions.add(d.name);
        if (d.title && d.title.toLowerCase().includes(q)) suggestions.add(d.title);
    });

    if (!suggestions.size) {
        autocomplete.style.display = 'none';
        applyFilters();
        return;
    }

    [...suggestions].slice(0, 6).forEach(text => {
        const item = document.createElement('div');
        item.className = 'autocomplete-item';
        item.textContent = text;
        item.addEventListener('click', () => {
            searchInput.value = text;
            autocomplete.style.display = 'none';
            applyFilters();
        });
        autocomplete.appendChild(item);
    });

    autocomplete.style.display = 'block';
    applyFilters();
});

document.addEventListener('click', e => {
    if (!searchInput.contains(e.target) && !autocomplete.contains(e.target)) {
        autocomplete.style.display = 'none';
    }
});

// ── Location dropdown change ──────────────────────────────────
locationSelect.addEventListener('change', () => {
    const city = locationSelect.value;
    if (!city) {
        showWelcomeState();
        // Reset to default background when no city selected
        const bg = document.getElementById('bgLayer');
        if (bg) bg.style.backgroundImage = "url('images/backgrounds/default_background.png')";
        return;
    }
    // Swap background immediately from the city->state map
    const state = cityStateMap[city.toLowerCase()];
    if (state) setBackgroundForState(state);

    // Reset secondary filters AND sort when switching cities
    categorySelect.value = '';
    daySelect.value      = '';
    searchInput.value    = '';
    sortSelect.value     = 'default';
    loadDealsForCity(city);
});

// ── Filter + sort + render ────────────────────────────────────
function applyFilters() {
    if (!dealsLoaded) return;

    const category = categorySelect.value.toLowerCase();
    const day      = daySelect.value.toLowerCase();
    const search   = searchInput.value.toLowerCase().trim();
    const sort     = sortSelect.value;

    let filtered = allDeals.filter(d => {
        const catString = (d.categories || d.categoryname || '').toLowerCase();
        const matchCat  = !category ||
            catString.split(',').map(c => c.trim()).includes(category);

        const matchDay = !day ||
            (d.dayofweek || '').toLowerCase().includes(day);

        const matchSearch = !search ||
            (d.name        || '').toLowerCase().includes(search) ||
            (d.title       || '').toLowerCase().includes(search) ||
            (d.description || '').toLowerCase().includes(search) ||
            (d.address     || '').toLowerCase().includes(search);

        return matchCat && matchDay && matchSearch;
    });
// Sort — Featured is default (tiered random, handled in groupByBusiness)

    const grouped = groupByBusiness(filtered);
    displayDeals(filtered, grouped);
    updateFilterTags();
}

// ── Fisher-Yates shuffle ─────────────────────────────────────
function shuffleArray(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
}

// ── Group deals by business name ──────────────────────────────
function groupByBusiness(deals) {
    const map = new Map();
    deals.forEach(deal => {
        const key = deal.name;
        if (!map.has(key)) {
            map.set(key, {
                name:              deal.name,
                businessid:        deal.businessid,
                subscription_tier: deal.subscription_tier || 'Basic',
                address:           deal.address,
                city:              deal.city,
                state:             deal.state,
                phone:             deal.phone,
                website:           deal.website,
                latitude:          deal.latitude,
                longitude:         deal.longitude,
                outdoor_dining:    deal.outdoor_dining || false,
                live_music:        deal.live_music     || false,
                waterfront:        deal.waterfront     || false,
                pet_friendly:      deal.pet_friendly   || false,
                deals:             []
            });
        }
        map.get(key).deals.push(deal);
    });

    const businesses = [...map.values()];

    // Featured sort: split into tier groups, shuffle each independently, rejoin
    const premium = shuffleArray(businesses.filter(b => b.subscription_tier === 'Premium'));
    const basic   = shuffleArray(businesses.filter(b => b.subscription_tier !== 'Premium'));

    return [...premium, ...basic];
}


// ── Filter tag pills ──────────────────────────────────────────
function updateFilterTags() {
    filterTags.innerHTML = '';
    const active = [];
    if (categorySelect.value) active.push({ label: categorySelect.value,     clear: () => { categorySelect.value = ''; } });
    if (daySelect.value)      active.push({ label: daySelect.value,          clear: () => { daySelect.value = ''; } });
    if (searchInput.value)    active.push({ label: `"${searchInput.value}"`, clear: () => { searchInput.value = ''; } });

    active.forEach(f => {
        const tag = document.createElement('span');
        tag.className = 'filter-tag';
        tag.innerHTML = `${f.label} <button>×</button>`;
        tag.querySelector('button').addEventListener('click', () => {
            f.clear();
            applyFilters();
        });
        filterTags.appendChild(tag);
    });

    resultsHeader.style.display = dealsLoaded ? 'block' : 'none';
}

// ── Helpers ───────────────────────────────────────────────────
function formatTime(t) {
    if (!t) return '';
    const d = new Date(`1970-01-01T${t}`);
    return d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
}

function formatDiscount(deal) {
    const val  = parseFloat(deal.discountvalue);
    const type = deal.discounttype || '';

    if (type === 'Percent' && val > 0) return `${val}% OFF`;
    if (type === 'Flat'    && val > 0) return `$${val} OFF`;
    if (type === 'BOGO')               return 'BOGO';
    // Flat with no value, Custom, or anything else — show nothing
    return '';
}

function formatEndDate(enddate) {
    if (!enddate) return '';
    const d = new Date(enddate);
    // Add one day offset correction for UTC date parsing
    d.setMinutes(d.getMinutes() + d.getTimezoneOffset());
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

function formatDays(dayString) {
    if (!dayString) return '—';
    const order = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
    const present = order.filter(d => dayString.includes(d));
    if (present.length === 7) return 'Everyday';
    if (present.length === 5 &&
        !present.includes('Saturday') &&
        !present.includes('Sunday')) return 'Weekdays';
    if (present.length === 2 &&
        present.includes('Saturday') &&
        present.includes('Sunday')) return 'Weekends';
    return present.join(', ');
}

// ── Display ───────────────────────────────────────────────────
function displayDeals(deals, grouped) {
    if (!grouped) grouped = groupByBusiness(deals);

    dealCount.textContent =
        `Showing ${grouped.length} business${grouped.length !== 1 ? 'es' : ''}` +
        ` · ${deals.length} deal${deals.length !== 1 ? 's' : ''}` +
        (locationSelect.value ? ` in ${locationSelect.value}` : '');

    if (!grouped.length) {
        results.innerHTML = `
            <div class="welcome-card">
                <p>No deals match your current filters. Try adjusting your search.</p>
            </div>`;
        return;
    }

    results.innerHTML = grouped.map((biz, i) => {
        const cardId   = `card-${i}`;
        const fullAddr = `${biz.address || ''}, ${biz.city || ''}, ${biz.state || ''}`;
        const dealWord = biz.deals.length === 1 ? '1 deal' : `${biz.deals.length} deals`;

        const previewLines = biz.deals.map(d => {
            const endLabel = d.enddate
                ? `<span class="enddate-badge">Ends ${formatEndDate(d.enddate)}</span>`
                : '';
            return `<div class="deal-preview-row">
                <span class="deal-preview-title">${d.title} ${endLabel}</span>
                ${d.description
                    ? `<span class="deal-preview-desc">${d.description}</span>`
                    : ''}
            </div>`;
        }).join('');

        const dealRows = biz.deals.map(d => {
            const discount = formatDiscount(d);
            return `
            <div class="deal-row">
                <div class="deal-row-header">
                    <span class="deal-row-title">${d.title}</span>
                    ${discount ? `<span class="discount-badge">${discount}</span>` : ''}
                </div>
                <div class="deal-row-meta">
                    <span><strong>Days:</strong> ${formatDays(d.dayofweek)}</span>
                    <span><strong>Time:</strong> ${formatTime(d.starttime)} – ${formatTime(d.endtime)}</span>
                    ${d.enddate ? `<span class="enddate-meta">Offer ends ${formatEndDate(d.enddate)}</span>` : ''}
                </div>
            </div>`;
        }).join('');

        return `
        <div class="deal-card" id="${cardId}">
            <div class="card-summary" onclick="toggleCard('${cardId}')">
                <div class="card-summary-left">
                    <div class="card-summary-top">
                        <span class="business-name-sm">${biz.name}</span>
                        <span class="deal-count-pill">${dealWord}</span>
                    </div>
                    <div class="card-preview-block">${previewLines}</div>
                </div>
                <div class="card-summary-right">

                    <button class="expand-btn" id="icon-${cardId}" aria-label="Expand">▾</button>
                </div>
            </div>
            ${(biz.outdoor_dining || biz.live_music || biz.waterfront || biz.pet_friendly) ? `
            <div class="amenity-icons">
                ${biz.outdoor_dining ? `<span class="amenity-icon" data-tooltip="Outdoor Dining Available" onclick="showAmenityLegend(event, 'Outdoor Dining Available')">🌿</span>` : ''}
                ${biz.live_music     ? `<span class="amenity-icon" data-tooltip="Frequently Hosts Live Music" onclick="showAmenityLegend(event, 'Frequently Hosts Live Music')">🎵</span>` : ''}
                ${biz.waterfront     ? `<span class="amenity-icon" data-tooltip="Waterfront" onclick="showAmenityLegend(event, 'Waterfront')">⚓</span>` : ''}
                ${biz.pet_friendly   ? `<span class="amenity-icon" data-tooltip="Pet-Friendly" onclick="showAmenityLegend(event, 'Pet-Friendly')">🐾</span>` : ''}
            </div>` : ''}
            <div class="card-detail" id="detail-${cardId}">
                <p class="address"><strong>Address:</strong> ${fullAddr}</p>
                <div class="deal-rows-list">${dealRows}</div>
                <div class="card-footer">
                    ${biz.website ? `
                        <a href="${biz.website}" target="_blank" rel="noopener"
                           class="website-btn"
                           onclick="trackWebsiteClick(event, ${biz.businessid || 0})">
                            Visit Website
                        </a>` : ''}
                    <a href="https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(fullAddr)}"
                       target="_blank" rel="noopener"
                       class="directions-btn"
                       onclick="trackDirectionsClick(event, ${biz.businessid || 0})">
                        Get Directions
                    </a>
                </div>
            </div>
        </div>`;
    }).join('');
}

// ── Click tracking (fire and forget) ─────────────────────────
function trackWebsiteClick(e, businessId) {
    if (!businessId) return;
    fetch(`${API_URL}/businesses/${businessId}/website-click`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ device_id: getDeviceId() })
    }).catch(() => {});
}

function trackDirectionsClick(e, businessId) {
    if (!businessId) return;
    fetch(`${API_URL}/businesses/${businessId}/directions-click`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ device_id: getDeviceId() })
    }).catch(() => {});
}

// ── Amenity legend popup (mobile tap) ────────────────────────
let amenityLegendTimer = null;

function showAmenityLegend(e, label) {
    e.stopPropagation(); // prevent card toggle

    // Remove any existing legend
    const existing = document.getElementById('amenityLegend');
    if (existing) existing.remove();
    if (amenityLegendTimer) clearTimeout(amenityLegendTimer);

    // Create legend element positioned near the icon
    const legend = document.createElement('div');
    legend.id = 'amenityLegend';
    legend.className = 'amenity-legend';
    legend.textContent = label;

    // Position near the tapped icon
    const rect = e.target.getBoundingClientRect();
    legend.style.left = Math.max(8, rect.left) + 'px';
    legend.style.top  = (rect.top + window.scrollY - 36) + 'px';

    document.body.appendChild(legend);

    // Fade in
    requestAnimationFrame(() => legend.classList.add('visible'));

    // Auto-remove after 2.5 seconds
    amenityLegendTimer = setTimeout(() => {
        legend.classList.remove('visible');
        setTimeout(() => legend.remove(), 200);
    }, 2500);
}

// ── Card toggle ───────────────────────────────────────────────
function toggleCard(cardId) {
    const detail = document.getElementById(`detail-${cardId}`);
    const icon   = document.getElementById(`icon-${cardId}`);
    const card   = document.getElementById(cardId);
    const isOpen = detail.classList.contains('open');
    detail.classList.toggle('open', !isOpen);
    icon.textContent = isOpen ? '▾' : '▴';
    card.classList.toggle('expanded', !isOpen);
}

// ── QR code / URL param handling ──────────────────────────────
function checkUrlParams() {
    const params = new URLSearchParams(window.location.search);
    const city   = params.get('city');
    if (!city) return false;

    // Try to match the city param to a loaded option
    const options = [...locationSelect.options];
    const match   = options.find(o => o.value.toLowerCase() === city.toLowerCase());
    if (match) {
        locationSelect.value = match.value;
        // Swap background immediately for QR code loads
        const cityState = cityStateMap[match.value.toLowerCase()];
        if (cityState) setBackgroundForState(cityState);
        loadDealsForCity(match.value);
        // QR code load — no location banner shown automatically
        return true;
    }
    return false;
}

// ── Secondary filter listeners ────────────────────────────────
categorySelect.addEventListener('change', applyFilters);
daySelect.addEventListener('change', applyFilters);
sortSelect.addEventListener('change', applyFilters);

// ── Init ──────────────────────────────────────────────────────
Promise.all([loadLocations(), loadCategories()])
    .then(() => {
        // Check for QR code / URL param first
        const loadedFromUrl = checkUrlParams();
        // Otherwise show welcome state
        if (!loadedFromUrl) {
            showWelcomeState();
            // Location banner only shown when user selects Closest to Me
        }
    });