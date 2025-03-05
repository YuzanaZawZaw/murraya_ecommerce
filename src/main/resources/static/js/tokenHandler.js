// tokenHandler.js

/**
 * Retrieve the token from local storage.
 * If no token is stored, returns null.
 */
function getToken() {
    return localStorage.getItem('token');
}

/**
 * Save the token in local storage.
 * @param {string} token - The JWT token.
 */
function saveToken(token) {
    localStorage.setItem('token', token);
}

/**
 * Clear the token from local storage.
 */
function clearToken() {
    localStorage.removeItem('token');
}

/**
 * Redirect the user to the login page.
 */
function redirectToLogin() {
    window.location.href = '/adminAuth/adminLoginForm'; // Adjust the URL as necessary.
}

/**
 * Override the global fetch to include the Authorization header,
 * and to intercept any 401 responses for token expiration.
 */
(function () {
    const originalFetch = window.fetch;
    window.fetch = function (resource, config = {}) {
        // Get the token and set the Authorization header if available
        const token = getToken();
        console.log('admin token:::',token);
        if (token) {
            config.headers = config.headers || {};
            config.headers['Authorization'] = 'Bearer ' + token;
        }

        // Call the original fetch function
        return originalFetch(resource, config).then(response => {
            // If the response status is 401, clear the token and redirect
            if (response.status === 401) {
                alert('Session expired. Please log in again.');
                clearToken();
                redirectToLogin();
                // Optionally, you can reject the promise to stop further processing
                return Promise.reject(new Error('Unauthorized - token expired'));
            }
            return response;
        }).catch(error => {
            // Optionally, handle network errors here
            console.error('Fetch error:', error);
            throw error;
        });
    };
})();

/**
 * On page load, if the server has provided a token (for example, injected in a JSP variable),
 * then store it. Assume the server renders a global JS variable `serverToken` if a token is present.
 */
document.addEventListener('DOMContentLoaded', function () {
    // If the token is provided by the server in a global variable, store it.
    if (typeof serverToken !== 'undefined' && serverToken) {
        saveToken(serverToken);
    }
});
