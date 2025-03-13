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
 * Check if the token is expired.
 * @param {string} token - The JWT token.
 * @returns {boolean} - True if expired, false if valid.
 */
function isTokenExpired(token) {
    const decoded = decodeJwt(token);
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
    console.log("Decoded token payload:", decoded); // Debugging: Check the decoded token
    return { module: decoded.module, role: decoded.role };
}

/**
 * Redirect the user to the login page based on the module.
 */
function redirectToLoginBasedOnModule(module) {
    if (module === 'ADMIN_MODULE') {
        console.log("Redirecting to admin login"); 
        window.location.href = '/adminAuth/adminLoginForm'; 
    } else if (module === 'USER_MODULE') {
        console.log("Redirecting to user login"); 
        window.location.href = '/users/userLoginForm'; 
    } else {
        console.log("Redirecting to default login"); 
        window.location.href = '/users/userLoginForm'; 
    }
}

/**
 * Override the global fetch to intercept any 401 responses for token expiration.
 */
(function () {
    const originalFetch = window.fetch;
    window.fetch = async function (resource, config = {}) {
        // Get the token and set the Authorization header if available
        const token = getToken();
        let module = null;

        if (token) {
            // Extract the module and role from the token
            const { module: extractedModule } = getModuleAndRoleFromToken(token);
            module = extractedModule;

            // Check if the token is expired
            if (isTokenExpired(token)) {
                console.log("Token is expired. Module:", module); // Debugging
                clearToken(); // Clear the expired token
                redirectToLoginBasedOnModule(module); // Redirect to the login page
                return Promise.reject(new Error('Unauthorized - token expired'));
            }

            config.headers = config.headers || {};
            config.headers['Authorization'] = 'Bearer ' + token;
        }

        try {
            const response = await originalFetch(resource, config);

            if (response.status === 403) {
                console.log("Unauthorized - token expired. Module:", module); // Debugging
                clearToken(); // Clear the expired token
                redirectToLoginBasedOnModule(module); // Redirect to the login page
                return Promise.reject(new Error('Unauthorized - token expired'));
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