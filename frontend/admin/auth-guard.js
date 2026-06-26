// ============================================================
// Destination Deals — Admin Auth Guard
// Include this script at the TOP of every admin page <head>.
// Redirects to login.html if no valid session token found.
// ============================================================
(function() {
    const token = sessionStorage.getItem('dd_admin_token');
    if (!token) {
        window.location.replace('login.html');
    }
})();

// ── Logout helper — call from any admin page ──────────────────
function adminLogout() {
    sessionStorage.removeItem('dd_admin_token');
    window.location.href = 'login.html';
}