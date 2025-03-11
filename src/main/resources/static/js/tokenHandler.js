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
    if (token) {
        localStorage.setItem('token', token);
    }
}

/**
 * Clear the token from local storage.
 */
function clearToken() {
    localStorage.removeItem('token');
}

/**
 * Decode the JWT token to get its payload.
 * @param {string} token - The JWT token to decode.
 * @returns {object} - Decoded token payload.
 */
function decodeJwt(token) {
    const base64Url = token.split('.')[1];  // JWT payload is in the second part of the token
    const base64 = base64Url.replace('-', '+').replace('_', '/');  // Correct base64 format
    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    
    return JSON.parse(jsonPayload);  // Return the decoded payload as a JSON object
}

/**
 * Get the module and role from the decoded token.
 * @param {string} token - The JWT token.
 * @returns {object} - Contains the module and role from the token.
 */
function getModuleAndRoleFromToken(token) {
    const decoded = decodeJwt(token);
    return { module: decoded.module, role: decoded.role };
}

/**
 * Redirect the user to the login page based on the module.
 */
function redirectToLoginBasedOnModule(module) {
    if (module === 'admin') {
        window.location.href = '/adminAuth/adminLoginForm'; // Admin login
    } else if (module === 'user') {
        window.location.href = '/users/userLoginForm'; // User login
    } else {
        window.location.href = '/users/userLoginForm'; // Default login page
    }
}

/**
 * Show a session expired modal and redirect based on the module.
 */
function showSessionExpiredModal(module) {
    Swal.fire({
        title: 'Session Expired',
        text: 'Your session has expired. Please log in again.',
        icon: 'warning',
        confirmButtonText: 'Log In',
        allowOutsideClick: false,
        allowEscapeKey: false
    }).then((result) => {
        if (result.isConfirmed) {
            clearToken();
            redirectToLoginBasedOnModule(module); // Redirect to the login page based on module
        }
    });
}

/**
 * Override the global fetch to intercept any 401 responses for token expiration.
 */
(function () {
    const originalFetch = window.fetch;
    window.fetch = function (resource, config = {}) {
        // Get the token and set the Authorization header if available
        const token = getToken();
        let module = null;

        if (token) {
            // Extract the module and role from the token
            const { module: extractedModule } = getModuleAndRoleFromToken(token);
            module = extractedModule;

            config.headers = config.headers || {};
            config.headers['Authorization'] = 'Bearer ' + token;
        }

        return originalFetch(resource, config).then(response => {
            if (response.status === 401 || response.status === 403) {
                showSessionExpiredModal(module); // Pass the module value to the modal
                return Promise.reject(new Error('Unauthorized - token expired'));
            }
            return response;
        }).catch(error => {
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
    if (typeof serverToken !== 'undefined' && serverToken && serverToken.trim() !== '') {
        saveToken(serverToken);
    }
});


