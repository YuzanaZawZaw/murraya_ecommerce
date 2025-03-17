document.addEventListener('DOMContentLoaded', function () {
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
            //alert(`Quick View Clicked for Product ID: `+productId);
            incrementCount('view', productId);
        }

        // Wishlist button
        if (target.matches('[title="wishlist"], [title="wishlist"] *')) {
            event.preventDefault();
            //alert(`Wishlist Clicked for Product ID: `+productId);
            incrementCount('like', productId);
            // window.location.href = `/users/wishlist`;
        }
    });
});


function incrementCount(endpoint, productId) {
    const url =`/users/products/`+productId+'/'+endpoint;
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