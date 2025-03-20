document.addEventListener('DOMContentLoaded', function () {
    updateShoppingCount();
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
            toggleViewProduct(productId, target);
        }

        // Wishlist button
        if (target.matches('[title="wishlist"], [title="wishlist"] *')) {
            event.preventDefault();
            toggleWishlist(productId, target);
        }

        if (target.closest('[title="shopping"], [title="shopping"] *')) {
            event.preventDefault();
            toggleShopping(productId, target);
        }
    });
});



function toggleShopping(productId, btn) {
    let shopping = JSON.parse(localStorage.getItem("shopping")) || [];
    const icon = btn.querySelector("i") || btn.closest("a").querySelector("i");

    if (!icon) {
        console.error("Icon not found in shopping button!");
        return;
    }

    if (shopping.includes(productId)) {
        shopping = shopping.filter(id => id !== productId);
        decrementCount('purchase', productId);
    } else {
        shopping.push(productId);
        incrementCount('purchase', productId);
    }

    localStorage.setItem("shopping", JSON.stringify(shopping));

    updateShoppingCount();
}

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
        //decrementCount('unLike', productId);
    } else {
        // Add to wishlist
        favorites.push(productId);
        icon.classList.remove("bi-heart");
        icon.classList.add("bi-heart-fill");

        incrementCount('like', productId);//increase the like count
    }

    localStorage.setItem("favorites", JSON.stringify(favorites));

    updateWishlistCount();
}

function toggleViewProduct(productId, btn) {
    const icon = btn.querySelector("i") || btn.closest("a").querySelector("i");

    window.location.href="/users/productDetails?productId="+productId;
    incrementCount('view', productId);
}


//Update Wishlist Count in Header
function updateWishlistCount() {
    const favoriteIcon = document.getElementById("favorite-count");
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];
    if (favoriteIcon) {
        if (favorites.length > 0) {
            favoriteIcon.textContent = favorites.length;
            favoriteIcon.style.display = "inline-block";

            favoriteIcon.classList.add("animate");
            setTimeout(() => {
                favoriteIcon.classList.remove("animate");
            }, 300);
        } else {
            favoriteIcon.style.display = "none";
        }
    }
}

function updateShoppingCount() {
    const shoppingIcon = document.getElementById("shopping-count");
    let shopping = JSON.parse(localStorage.getItem("shopping")) || [];
    console.log('shopping',shopping);
    

    if (shoppingIcon) {
        if (shopping.length > 0) {
            shoppingIcon.textContent = shopping.length;
            shoppingIcon.style.display = "inline-block";

            shoppingIcon.classList.add("animate");
            setTimeout(() => {
                shoppingIcon.classList.remove("animate");
            }, 300);
        } else {
            shoppingIcon.style.display = "none";
        }
    }
}

// Update UI for products that are already in the wishlist
function updateWishlistUI() {
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];
    document.querySelectorAll('.action-button').forEach(btn => {
        const productId = btn.getAttribute("data-product-id");

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

function decrementCount(endpoint, productId) {
    const url = `/users/products/decrement/` + productId + '/' + endpoint;
    console.log(url);
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to decrement count');
            }
            console.log(`${endpoint} count decremented successfully`);
        })
        .catch(error => {
            console.error('Error:', error);
        });
}
