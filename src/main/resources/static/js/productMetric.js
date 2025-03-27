document.addEventListener('DOMContentLoaded', function () {
    updateShoppingCount();
    document.body.addEventListener('click', function (event) {
        const target = event.target.closest('a, .bi');
        if (!target) return;

        const actionButton = target.closest('.action-button');
        if (!actionButton) return;

        const productId = actionButton.getAttribute('data-product-id');
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

        // if (target.closest('[title="shopping"], [title="shopping"] *')) {
        //     event.preventDefault();
        //     toggleShopping(productId, target);
        // }
    });
});



// function toggleShopping(productId, btn) {
//     let shopping = JSON.parse(localStorage.getItem("shopping")) || [];
//     const icon = btn.querySelector("i") || btn.closest("a").querySelector("i");

//     if (!icon) {
//         console.error("Icon not found in shopping button!");
//         return;
//     }

//     if (shopping.includes(productId)) {
//         shopping = shopping.filter(id => id !== productId);
//         decrementCount('purchase', productId);
//     } else {
//         shopping.push(productId);
//         incrementCount('purchase', productId);
//     }

//     localStorage.setItem("shopping", JSON.stringify(shopping));

//     updateShoppingCount();
// }

function toggleWishlist(productId, btn) {
    const userToken = localStorage.getItem("userToken");

    if (!userToken) {
        const loginModal = new bootstrap.Modal(document.getElementById("loginModal"));
        loginModal.show();
        return;
    }

    const icon = btn.querySelector("i") || btn.closest("a").querySelector("i");
    const isInWishlist = icon.classList.contains("bi-heart-fill");

    const url = isInWishlist
        ? `/users/wishlists/remove/` + productId
        : `/users/wishlists/add/` + productId;
    const method = isInWishlist ? "DELETE" : "POST";

    fetch(url, {
        method: method,
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ` + userToken
        }
    })
        .then(response => {
            if (response.status === 409) {
                // Handle conflict (product already in wishlist)
                Swal.fire({
                    icon: 'warning',
                    title: 'Already in Wishlist',
                    text: `This product is already in your wishlist.`,
                    timer: 2000,
                    showConfirmButton: false
                });
                throw new Error("Product is already in the wishlist");
            }
            if (!response.ok) {
                throw new Error("Failed to update wishlist");
            }
            return response.text();
        })
        .then(message => {

            // Update the UI based on the response
            if (isInWishlist) {
                // Remove from wishlist
                icon.classList.remove("bi-heart-fill");
                icon.classList.add("bi-heart");
                
                decrementCount('like', productId);
            } else {
                // Add to wishlist
                icon.classList.remove("bi-heart");
                icon.classList.add("bi-heart-fill");
                
                incrementCount('like', productId);
            }

            // Update the wishlist count
            updateWishlistCount();
        })
        .catch(error => {
            if (error.message === "Product is already in the wishlist") {
                console.warn("Conflict: Product is already in the wishlist.");
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to update wishlist. Please try again later.',
                    timer: 2000,
                    showConfirmButton: false
                });
            }
        });

}

function toggleViewProduct(productId, btn) {
    const icon = btn.querySelector("i") || btn.closest("a").querySelector("i");

    window.location.href = "/users/productDetails?productId=" + productId;
    incrementCount('view', productId);
}

//Update Wishlist Count in Header
function updateWishlistCount() {
    const favoriteIcon = document.getElementById("favorite-count");
    const userToken = localStorage.getItem("userToken");

    if (!userToken) {
        console.error("User is not logged in. Cannot fetch wishlist count.");
        if (favoriteIcon) {
            favoriteIcon.style.display = "none";
        }
        return;
    }

    // Fetch the wishlist items from the backend
    fetch("/users/wishlists/items", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ` + userToken
        }
    })
        .then(response => {
            return response.json();
        })
        .then(wishlistItems => {
            if (favoriteIcon) {
                if (wishlistItems.length > 0) {
                    favoriteIcon.textContent = wishlistItems.length;
                    favoriteIcon.style.display = "inline-block";

                    favoriteIcon.classList.add("animate");
                    setTimeout(() => {
                        favoriteIcon.classList.remove("animate");
                    }, 300);
                } else {
                    favoriteIcon.style.display = "none";
                }
            }
        })
        .catch(error => {
            console.error("Error fetching wishlist items:", error);
            if (favoriteIcon) {
                favoriteIcon.style.display = "none";
            }
        });
}



function updateShoppingCount() {
    const shoppingIcon = document.getElementById("shopping-count");
    const userToken = localStorage.getItem("userToken");

    if (!userToken) {
        if (shoppingIcon) {
            shoppingIcon.style.display = "none";
        }
        return;
    }

    // Fetch the shopping cart count from the backend
    fetch("/users/carts/shoppingItems", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${userToken}`
        }
    })
        .then(response => {
            return response.json();
        })
        .then(cartItems => {
            if (shoppingIcon) {
                if (cartItems.length > 0) {
                    shoppingIcon.textContent = cartItems.length;
                    shoppingIcon.style.display = "inline-block";

                    shoppingIcon.classList.add("animate");
                    setTimeout(() => {
                        shoppingIcon.classList.remove("animate");
                    }, 300);
                } else {
                    shoppingIcon.style.display = "none";
                }
            }
        })
        .catch(error => {
            console.error("Error fetching shopping cart count:", error);
            if (shoppingIcon) {
                shoppingIcon.style.display = "none";
            }
        });
}

// Update UI for products that are already in the wishlist
function updateWishlistUI() {
    const userToken = localStorage.getItem("userToken");

    // Fetch the wishlist items from the backend
    fetch("/users/wishlists/items", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ` + userToken
        }
    })
        .then(response => {
            return response.json();
        })
        .then(wishlistItems => {
            // Update the UI for products that are in the wishlist
            document.querySelectorAll('.action-button').forEach(btn => {
                const productId = btn.getAttribute("data-product-id");

                const wishlistBtn = btn.querySelector('[title="wishlist"]');
                const icon = wishlistBtn?.querySelector("i") || wishlistBtn?.closest("a")?.querySelector("i");

                // Check if the product is in the wishlist
                const isInWishlist = wishlistItems.some(item => item.productId === parseInt(productId, 10));

                if (isInWishlist) {
                    wishlistBtn.classList.add("liked");
                    icon.classList.remove("bi-heart");
                    icon.classList.add("bi-heart-fill");
                } else {
                    wishlistBtn.classList.remove("liked");
                    icon.classList.remove("bi-heart-fill");
                    icon.classList.add("bi-heart");
                }
            });

            // Update the wishlist count
            updateWishlistCount();
        })
}

function incrementCount(endpoint, productId) {
    const url = `/users/products/` + productId + '/' + endpoint;
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
    })
}

function decrementCount(endpoint, productId) {
    const url = `/users/products/decrement/` + productId + '/' + endpoint;
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
    })
}
