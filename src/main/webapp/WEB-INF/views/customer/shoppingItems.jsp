<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
            <!--FOR CATEGORIES DROP DOWN-->
            <%@ include file="/WEB-INF/views/inc/categoryDropDown.jsp" %>
                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                        <title>Shopping Items</title>
                        <!--Main CSS-->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                    </head>

                    <body>
                        <!--Navbar-->
                        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                        <!--End of Navbar-->

                        <!-- Start product details info-->
                        <div class="container mt-5">
                            <h2 class="text-center mb-4">My Cart</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/users/userHome">Home</a></li>
                                    <li class="breadcrumb-item"><a href="/users/wishlist">Favorite Items</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
                                </ol>
                            </nav>
                            <div class="row">
                                <div id="shopping-items-container"></div>
                                <!-- Left Panel: Shipping Address -->
                                <div class="col-md-6">
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <h5 class="card-title">Shipping Address</h5>
                                            <hr>
                                            <form id="shipping-address-form">
                                                <div class="mb-3">
                                                    <label for="addressLine1" class="form-label">Address Line 1</label>
                                                    <input type="text" id="addressLine1" class="form-control" placeholder="Enter address line 1">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="addressLine2" class="form-label">Address Line 2</label>
                                                    <input type="text" id="addressLine2" class="form-control" placeholder="Enter address line 2">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="city" class="form-label">City</label>
                                                    <input type="text" id="city" class="form-control" placeholder="Enter your city">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="state" class="form-label">State</label>
                                                    <input type="text" id="state" class="form-control" placeholder="Enter your state">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="zipCode" class="form-label">Zip Code</label>
                                                    <input type="text" id="zipCode" class="form-control" placeholder="Enter your zip code">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="country" class="form-label">Country</label>
                                                    <input type="text" id="country" class="form-control" placeholder="Enter your country">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="phoneNumber" class="form-label">Phone Number</label>
                                                    <input type="text" id="phoneNumber" class="form-control" placeholder="Enter your phone number">
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Panel: Order Summary and Order Details -->
                                <div class="col-md-6">
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <h5 class="card-title">Order Details</h5>
                                            <hr>
                                            <div id="order-details-container">
                                                <!-- Order details will be dynamically populated here -->
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card shadow-sm mb-3">
                                        <div class="card-body">
                                            <h5 class="card-title">Order Summary</h5>
                                            <hr>
                                            <p id="total-items" class="card-text">Total Items: 0</p>
                                            <p id="total-amount" class="card-text">Total Amount: MMK 0</p>
                                            <p id="total-amount-tax" class="card-text">Total Amount (including tax): MMK 0</p>
                                            <hr>
                                            <h6>Payment Method</h6>
                                            <select id="payment-method" class="form-select mb-3">
                                                <c:forEach var="method" items="${paymentMethods}">
                                                    <option value="${method}">${method}</option>
                                                </c:forEach>
                                            </select>
                                            <button id="placeOrderButton" class="btn btn-success w-100">Place Order</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- End product details info-->

                        <!-- Start showing product results-->
                        <jsp:include page="/WEB-INF/views/inc/searchProductResultContainer.jsp"></jsp:include>
                        <!-- End showing product results-->

                        <!-- ======= Footer ======= -->
                        <jsp:include page="/WEB-INF/views/inc/userHomeFooter.jsp"></jsp:include>
                        <!-- End Footer -->

                        <!-- Bootstrap JS and Dependencies -->
                        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                        <!--Product Metric-->
                        <script src="${pageContext.request.contextPath}/js/productMetric.js"></script>

                        <script>
                            document.addEventListener("DOMContentLoaded", async function () {
                                updateWishlistUI();

                                let shopping = [];
                                const userToken = localStorage.getItem('userToken');

                                const productContainer = document.getElementById("shopping-items-container");
                                const totalItemsElement = document.getElementById("total-items");
                                const totalAmountElement = document.getElementById("total-amount");
                                const totalAmountTaxElement = document.getElementById("total-amount-tax");
                                
                                const orderDetailsContainer = document.getElementById("order-details-container");
                                const placeOrderButton = document.getElementById("placeOrderButton");

                                productContainer.innerHTML = "";
                                orderDetailsContainer.innerHTML = "";

                                try {
                                    // Fetch and populate the shipping address
                                    await populateShippingAddress(userToken);

                                    // Fetch shopping items
                                    shopping = await fetchShoppingItems(userToken);
                                } catch (error) {
                                    const emptyMessage = document.createElement("div");
                                    emptyMessage.classList.add("text-center", "mt-5");
                                    emptyMessage.innerHTML = `
                                        <h4>No items in your cart</h4>
                                        <p>Browse products and add them to your cart!</p>
                                    `;
                                    productContainer.appendChild(emptyMessage);
                                    return;
                                }

                                if (shopping.length === 0) {
                                    // Display a message if the cart is empty
                                    const emptyMessage = document.createElement("div");
                                    emptyMessage.classList.add("text-center", "mt-5");
                                    emptyMessage.innerHTML = `
                                        <h4>No items in your cart</h4>
                                        <p>Browse products and add them to your cart!</p>
                                    `;
                                    productContainer.appendChild(emptyMessage);
                                } else {
                                    // Display products if the cart is not empty
                                    let totalAmount = 0;
                                    shopping.forEach(product => {
                                        shoppingItemsDisplayProductDetails(product, productContainer);

                                        const productTotal = product.discountedPrice
                                            ? product.discountedPrice * product.stockQuantity
                                            : product.price * product.stockQuantity;
                                        totalAmount += productTotal;

                                        // Add product details to the order details card
                                        const orderItem = document.createElement("div");
                                        orderItem.classList.add("mb-3");
                                        orderItem.innerHTML = `
                                            <p><strong>Product Name:</strong> `+product.name+`</p>`+
                                            `<p><strong>Quantity:</strong> `+product.stockQuantity+`</p>`+
                                            `<p><strong>Total Price:</strong> MMK `+productTotal+`</p>`+
                                            `<hr>`
                                        ;
                                        orderDetailsContainer.appendChild(orderItem);
                                    });

                                    // Update the order summary
                                    totalItemsElement.textContent = `Total Items: ` + shopping.length;
                                    totalAmountElement.textContent = `Total Amount : MMK ` + totalAmount ;
                                    totalAmountTaxElement.textContent = `Total Amount (including tax): MMK ` + (totalAmount + calculateTax(totalAmount));
                                }

                                // Add event listener for the "Place Order" button
                                placeOrderButton.addEventListener("click", function () {
                                    const shippingAddress = {
                                        addressLine1: document.getElementById("addressLine1").value,
                                        addressLine2: document.getElementById("addressLine2").value,
                                        city: document.getElementById("city").value,
                                        state: document.getElementById("state").value,
                                        zipCode: document.getElementById("zipCode").value,
                                        country: document.getElementById("country").value,
                                        phoneNumber: document.getElementById("phoneNumber").value
                                    };
                                    const paymentMethod = document.getElementById("payment-method").value;

                                    if (!shippingAddress.addressLine1 || !shippingAddress.city || !shippingAddress.state || !shippingAddress.zipCode || !shippingAddress.country || !shippingAddress.phoneNumber) {
                                        Swal.fire({
                                            icon: 'warning',
                                            title: 'Shipping Address Required',
                                            text: 'Please fill in all required shipping address fields before placing the order.',
                                            timer: 2000,
                                            showConfirmButton: false
                                        });
                                        return;
                                    }

                                    placeOrder(shopping, shippingAddress, paymentMethod);
                                });
                            });

                            // Function to fetch and populate the shipping address
                            async function populateShippingAddress(userToken) {
                                try {
                                    const response = await fetch("/users/shippingAddress/getShippingAddress", {
                                        method: "GET",
                                        headers: {
                                            "Content-Type": "application/json",
                                            "Authorization": `Bearer `+userToken
                                        }
                                    });

                                    if (response.ok) {
                                        const shippingAddress = await response.json();
                                        if (shippingAddress) {
                                            document.getElementById("addressLine1").value = shippingAddress.addressLine1 || "";
                                            document.getElementById("addressLine2").value = shippingAddress.addressLine2 || "";
                                            document.getElementById("city").value = shippingAddress.city || "";
                                            document.getElementById("state").value = shippingAddress.state || "";
                                            document.getElementById("zipCode").value = shippingAddress.zipCode || "";
                                            document.getElementById("country").value = shippingAddress.country || "";
                                            document.getElementById("phoneNumber").value = shippingAddress.phoneNumber || "";
                                        }
                                    } else {
                                        document.getElementById("addressLine1").value = "";
                                        document.getElementById("addressLine2").value = "";
                                        document.getElementById("city").value = "";
                                        document.getElementById("state").value = "";
                                        document.getElementById("zipCode").value = "";
                                        document.getElementById("country").value = "";
                                        document.getElementById("phoneNumber").value = "";
                                    }
                                } catch (error) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error',
                                        text: 'Error fetching shipping address. Please try again later.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    });
                                }
                            }

                            function calculateTax(amount) {
                                const taxRate = 0.05; // 5% tax
                                return amount * taxRate;
                            }

                            function placeOrder(shopping, shippingAddress, paymentMethod) {
                                if (shopping.length === 0) {
                                    Swal.fire({
                                        icon: 'warning',
                                        title: 'Cart is Empty',
                                        text: 'Please add items to your cart before placing an order.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    });
                                    return;
                                }

                                const userToken = localStorage.getItem('userToken');
                                if (!userToken) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Unauthorized Access',
                                        text: 'Please login to place an order.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    }).then(() => {
                                        window.location.href = "/users/userLoginForm";
                                    });
                                    return;
                                }

                                // Prepare the order request payload
                                const orderRequest = {
                                    totalAmount: shopping.reduce((total, product) => {
                                        const productTotal = product.discountedPrice
                                            ? product.discountedPrice * product.stockQuantity
                                            : product.price * product.stockQuantity;
                                        return total + productTotal;
                                    }, 0) + calculateTax(shopping.reduce((total, product) => {
                                        const productTotal = product.discountedPrice
                                            ? product.discountedPrice * product.stockQuantity
                                            : product.price * product.stockQuantity;
                                        return total + productTotal;
                                    }, 0)), 
                                    status: { statusId: 5 }, // Assuming 5 is the default status for "Pending"
                                    shippingAddress: shippingAddress,
                                    paymentMethod: paymentMethod,
                                    tax: calculateTax(shopping.reduce((total, product) => {
                                        const productTotal = product.discountedPrice
                                            ? product.discountedPrice * product.stockQuantity
                                            : product.price * product.stockQuantity;
                                        return total + productTotal;
                                    }, 0)),
                                    orderItems: shopping.map(product => ({
                                        productId: product.productId,
                                        quantity: product.stockQuantity,
                                        price: product.discountedPrice || product.price ,
                                        totalPrice:product.discountedPrice ? product.discountedPrice * product.stockQuantity : product.price * product.stockQuantity
                                    }))
                                };

                                // Send the order request to the backend
                                fetch('/users/orders/placeOrder', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization': `Bearer `+userToken
                                    },
                                    body: JSON.stringify(orderRequest)
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Failed to place the order');
                                        }
                                        return response.text();
                                    })
                                    .then(message => {
                                        Swal.fire({
                                            icon: 'success',
                                            title: 'Order Placed',
                                            text: message,
                                            timer: 3000,
                                            showConfirmButton: false
                                        }).then(() => {
                                            // Clear the cart after placing the order
                                            removeAllProductFromCart(userToken);
                                            location.reload();
                                        });
                                    })
                                    .catch(error => {
                                        console.error('Error placing the order:', error);
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error',
                                            text: 'Failed to place the order. Please try again later.',
                                            timer: 2000,
                                            showConfirmButton: false
                                        });
                                    });
                            }

                            async function removeAllProductFromCart(userToken){
                                const response = await fetch("/users/carts/removeAllFromCart", {
                                    method: "DELETE",
                                    headers: {
                                        "Content-Type": "application/json",
                                        'Authorization': `Bearer ` + userToken
                                    }
                                });
                                if (!response.ok) {
                                    throw new Error("Failed to remove all products from cart");
                                }
                                return response.text();
                            }

                            async function fetchShoppingItems(userToken) {
                                const response = await fetch("/users/carts/shoppingItems", {
                                    method: "GET",
                                    headers: {
                                        "Content-Type": "application/json",
                                        'Authorization': `Bearer ` + userToken
                                    }
                                });
                                if (!response.ok) {
                                    throw new Error("Failed to fetch shopping items");
                                }
                                return response.json();
                            }

                            function shoppingItemsDisplayProductDetails(product, container) {
                                const productRow = document.createElement("div");
                                productRow.classList.add("row", "mb-4", "shadow-sm");

                                // Left Column: Product Image Carousel
                                const imageCol = document.createElement("div");
                                imageCol.classList.add("col-md-6");

                                const carousel = document.createElement("div");
                                carousel.classList.add("carousel", "slide");
                                carousel.id = `carousel-` + product.productId;
                                carousel.setAttribute("data-bs-ride", "carousel");

                                const carouselInner = document.createElement("div");
                                carouselInner.classList.add("carousel-inner");

                                product.images.forEach((image, index) => {
                                    const carouselItem = document.createElement("div");
                                    carouselItem.classList.add("carousel-item");
                                    if (index === 0) carouselItem.classList.add("active");

                                    const img = document.createElement("img");
                                    img.src = `/admin/productImage/` + image.imageId;
                                    img.classList.add("d-block", "w-100");
                                    img.style.height = "400px";
                                    img.style.objectFit = "cover";

                                    carouselItem.appendChild(img);
                                    carouselInner.appendChild(carouselItem);
                                });

                                carousel.appendChild(carouselInner);
                                imageCol.appendChild(carousel);

                                // Right Column: Product Info
                                const infoCol = document.createElement("div");
                                infoCol.classList.add("col-md-6");

                                const cardBody = document.createElement("div");
                                cardBody.classList.add("card-body");

                                const title = document.createElement("h5");
                                title.classList.add("card-title");
                                title.textContent = product.name;

                                // const description = document.createElement("p");
                                // description.classList.add("card-text");
                                // description.textContent = product.description;

                                const quantity = document.createElement("p");
                                quantity.classList.add("card-text");
                                quantity.textContent = `Quantity: ` + product.stockQuantity;

                                const pricePerItem = document.createElement("p");
                                pricePerItem.classList.add("card-text");
                                pricePerItem.textContent = `Price for each: MMK ` + product.price;

                                const totalPrice = document.createElement("p");
                                totalPrice.classList.add("card-text", "fw-bold");

                                // Calculate total price based on discounted price if it exists
                                let calculatedTotal;
                                if (product.discountedPrice) {
                                    calculatedTotal = product.discountedPrice * product.stockQuantity;
                                    totalPrice.innerHTML = `
                                        Total Price: <del>`+ product.price * product.stockQuantity + `MMK </del><br>` +
                                        `Discounted Total Price: ` + calculatedTotal + ` MMK`
                                        ;
                                } else {
                                    calculatedTotal = product.price * product.stockQuantity;
                                    totalPrice.textContent = `Total Price: ` + calculatedTotal + ` MMK`;
                                }

                                const discountPercentage = document.createElement("p");
                                discountPercentage.classList.add("card-text");
                                discountPercentage.innerHTML = `Discount Percentage: <span class="text-danger">` +
                                    (product.discountPercentage ? product.discountPercentage + `% off</span>` : `N/A</span>`);

                                const freeDelivery = document.createElement("p");
                                freeDelivery.classList.add("card-text");
                                freeDelivery.textContent = `Free Delivery: ` + (product.freeDelivery ? "Yes" : "No");

                                const removeButton = document.createElement("button");
                                removeButton.classList.add("btn", "btn-danger", "remove-item");
                                removeButton.textContent = "Remove";
                                removeButton.dataset.id = product.productId;

                                // Add event listener for the "Remove" button
                                removeButton.addEventListener("click", function () {
                                    removeProductFromCart(product.productId);
                                });

                                // Append elements to card body
                                cardBody.appendChild(title);
                                //cardBody.appendChild(description);
                                cardBody.appendChild(quantity);
                                cardBody.appendChild(freeDelivery);
                                cardBody.appendChild(pricePerItem);
                                cardBody.appendChild(discountPercentage);
                                cardBody.appendChild(totalPrice);

                                cardBody.appendChild(removeButton);

                                infoCol.appendChild(cardBody);

                                // Append columns to the row
                                productRow.appendChild(imageCol);
                                productRow.appendChild(infoCol);

                                // Append the row to the main container
                                container.appendChild(productRow);
                            }

                            function removeProductFromCart(productId) {
                                const userToken = localStorage.getItem("userToken");

                                if (!userToken) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Unauthorized Access',
                                        text: 'Please login to remove items from your cart.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    }).then(() => {
                                        window.location.href = "/users/userLoginForm";
                                    });
                                    return;
                                }

                                // Send a DELETE request to the backend to remove the product from the cart
                                fetch(`/users/carts/removeFromCart?productId=` + productId, {
                                    method: "DELETE",
                                    headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": `Bearer ` + userToken
                                    }
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("Failed to remove product from cart");
                                        }
                                        return response.text();
                                    })
                                    .then(message => {
                                        Swal.fire({
                                            icon: 'success',
                                            title: 'Removed from Cart',
                                            text: `Product with ID ` + productId + `has been removed from your cart.`,
                                            timer: 2000,
                                            showConfirmButton: false
                                        }).then(() => {
                                            location.reload();
                                        });
                                    })
                                    .catch(error => {
                                        console.error("Error removing product from cart:", error);
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error',
                                            text: 'Failed to remove product from cart. Please try again later.',
                                            timer: 2000,
                                            showConfirmButton: false
                                        });
                                    });
                            }

                        </script>

                    </body>

                    </html>