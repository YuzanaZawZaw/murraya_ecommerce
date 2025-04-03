/**
 * Retrieve the token from local storage.
 * If no token is stored, returns null.
 */
function getToken() {
    return localStorage.getItem('adminToken');
}

/**
 * Save the token in local storage.
 * @param {string} token - The JWT token.
 */
function saveToken(token) {
    if (token) {
        localStorage.setItem('adminToken', token);
    }
}

/**
 * Clear the token from local storage.
 */
function clearToken() {
    localStorage.removeItem('adminToken');
}

/**
 * Decode the JWT token to get its payload.
 * @param {string} token - The JWT token to decode.
 * @returns {object} - Decoded token payload.
 */
function decodeJwt(token) {
    try {
        const base64Url = token.split('.')[1];  // JWT payload is in the second part of the token
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/'); // Correct base64 format
        const jsonPayload = decodeURIComponent(
            atob(base64)
                .split('')
                .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
                .join('')
        );
        return JSON.parse(jsonPayload);  // Return the decoded payload as a JSON object
    } catch (error) {
        console.error('Failed to decode JWT:', error);
        return null;
    }
}

/**
 * Check if the token is expired.
 * @param {string} token - The JWT token.
 * @returns {boolean} - True if expired, false if valid.
 */
function isTokenExpired(token) {
    const decoded = decodeJwt(token);
    if (!decoded || !decoded.exp) {
        console.error('Invalid token or missing expiration field.');
        return true; // Treat as expired if invalid
    }
    const currentTime = Math.floor(Date.now() / 1000); // Current time in seconds
    return decoded.exp < currentTime; // True if expired, false if valid
}

/**
 * Get the module and role from the decoded token.
 * @param {string} token - The JWT token.
 * @returns {object} - Contains the module and role from the token.
 */
function getModuleAndRoleFromToken(token) {
    const decoded = decodeJwt(token);
    if (!decoded) {
        console.error('Failed to decode token for module and role.');
        return { module: null, role: null };
    }
    return { module: decoded.module, role: decoded.role };
}

/**
 * Redirect the user to the login page based on the module.
 * @param {string} module - The module extracted from the token.
 */
function redirectToLoginBasedOnModule(module) {
    if (module === 'ADMIN_MODULE') {
        console.log('Redirecting to admin login');
        window.location.href = '/adminAuth/adminLoginForm';
    } else if (module === 'USER_MODULE') {
        console.log('Redirecting to user login');
        window.location.href = '/users/userLoginForm';
    } else {
        console.log('Redirecting to default login');
        window.location.href = '/users/userLoginForm';
    }
}

/**
 * Override the global fetch to intercept any 401 or 403 responses for token expiration.
 */
(function () {
    const originalFetch = window.fetch;
    window.fetch = async function (resource, config = {}) {
        const token = getToken();
        let module = null;

        if (token) {
            // Extract the module and role from the token
            const { module: extractedModule } = getModuleAndRoleFromToken(token);
            module = extractedModule;

            // Check if the token is expired
            if (isTokenExpired(token)) {
                console.warn('Token is expired. Clearing token and redirecting to login.');
                clearToken();
                redirectToLoginBasedOnModule(module);
                return Promise.reject(new Error('Unauthorized - token expired'));
            }

            // Add Authorization header
            config.headers = config.headers || {};
            config.headers['Authorization'] = 'Bearer ' + token;
        }

        try {
            const response = await originalFetch(resource, config);

            // Handle 401 or 403 responses
            if (response.status === 401 || response.status === 403) {
                console.warn('Unauthorized response. Clearing token and redirecting to login.');
                clearToken();
                redirectToLoginBasedOnModule(module);
                return Promise.reject(new Error('Unauthorized - token expired or invalid'));
            }

            return response;
        } catch (error) {
            console.error('Fetch error:', error);
            throw error;
        }
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