document.addEventListener('DOMContentLoaded', function () {
    document.body.addEventListener('click', function (event) {
        const target = event.target.closest('a, .bi');
        if (!target) return;

        const actionButton = target.closest('.action-button');
        if (!actionButton) return;

        const productId = actionButton.getAttribute('data-product-id');
        //console.log("product Id",productId);
        if (!productId) {
            console.error("Product ID not found!");
            return;
        }

        // Quick View button
        if (target.matches('[data-target="#exampleModal"], [data-target="#exampleModal"] *')) {
            event.preventDefault();
            incrementCount('view', productId);
        }

        // Wishlist button
        if (target.matches('[title="wishlist"], [title="wishlist"] *')) {
            event.preventDefault();
            incrementCount('like', productId);
            toggleWishlist(productId, target);
        }
    });
});

function toggleWishlist(productId, btn) {
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];
    const icon = btn.querySelector("i") || btn.closest("a").querySelector("i");

    if (!icon) {
        console.error("Icon not found in wishlist button!");
        return;
    }

    if (favorites.includes(productId)) {
        // Remove from wishlist
        favorites = favorites.filter(id => id !== productId);
        icon.classList.remove("bi-heart-fill");
        icon.classList.add("bi-heart");
    } else {
        // Add to wishlist
        favorites.push(productId);
        icon.classList.remove("bi-heart");
        icon.classList.add("bi-heart-fill");
    }

    // Save updated wishlist
    localStorage.setItem("favorites", JSON.stringify(favorites));

    // Update count in header
    updateWishlistCount();
}


//Update Wishlist Count in Header
function updateWishlistCount() {
    const favoriteIcon = document.getElementById("favorite-count");
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];
    //console.log('favorites:::', localStorage.getItem("favorites"));
    if (favoriteIcon) {
        favoriteIcon.textContent = favorites.length;
    } else {
        console.error("Favorite count element not found!");
    }
}

// Update UI for products that are already in the wishlist
function updateWishlistUI() {
    //console.log('updateWishlistUI.............refreshing');
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];
    //console.log("Favorites from localStorage:", favorites);
    //console.log("action-button",document.querySelectorAll('.action-button'));
    document.querySelectorAll('.action-button').forEach(btn => {
        const productId = btn.getAttribute("data-product-id");
        //console.log("Processing button with product ID:", productId); 

        const wishlistBtn = btn.querySelector('[title="wishlist"]');
        const icon = wishlistBtn.querySelector("i") || wishlistBtn.closest("a").querySelector("i");

        if (!wishlistBtn) {
            console.error("Wishlist button not found inside action-button:", btn);
            return; 
        }
        if (!icon) {
            console.error("Icon not found inside wishlist button:", wishlistBtn);
            return; 
        }

        if (productId && favorites.includes(productId)) {
            console.log(`Product ID ${productId} is in favorites.`); 
            wishlistBtn.classList.add("liked");
            icon.classList.remove("bi-heart");
            icon.classList.add("bi-heart-fill");
        } else {
            console.log(`Product ID ${productId} is NOT in favorites.`); 
            wishlistBtn.classList.remove("liked");
            icon.classList.remove("bi-heart-fill");
            icon.classList.add("bi-heart");
        }
    });

    updateWishlistCount();
}

function incrementCount(endpoint, productId) {
    const url = `/users/products/` + productId + '/' + endpoint;
    console.log(url);
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to increment count');
            }
            console.log(`${endpoint} count incremented successfully`);
        })
        .catch(error => {
            console.error('Error:', error);
        });
}
