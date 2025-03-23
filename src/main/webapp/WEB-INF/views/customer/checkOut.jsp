<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
            <!--FOR CATEGORIES DROP DOWN-->
            <%@ include file="/WEB-INF/views/inc/categoryDropDown.jsp" %>
                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                        <title>Checkout</title>
                        <!--Main CSS-->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                    </head>

                    <body>
                        <!--Navbar-->
                        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                        <!--End of Navbar-->

                        <!-- Start product details info-->
                        <div class="container mt-5">
                            <h2 class="text-center mb-4">Checkout Page</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/users/userHome">Home</a></li>
                                    <li class="breadcrumb-item"><a href="/users/wishlist">Favorite Items</a></li>
                                    <li class="breadcrumb-item"><a href="/users/shoppingList">Shopping Cart</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Checkout Page</li>
                                </ol>
                            </nav>
                            <div class="row">
                                <!-- Left Panel: Shipping Address -->
                                <div class="col-md-6">
                                    <div class="card shadow-sm">
                                        <div class="card-body">
                                            <h5 class="card-title">Shipping Address</h5>
                                            <hr>
                                            <form id="shipping-address-form">
                                                <div class="mb-3">
                                                    <label for="addressLine1" class="form-label">Address Line 1</label>
                                                    <input type="text" id="addressLine1" class="form-control"
                                                        placeholder="Enter address line 1">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="addressLine2" class="form-label">Address Line 2</label>
                                                    <input type="text" id="addressLine2" class="form-control"
                                                        placeholder="Enter address line 2">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="city" class="form-label">City</label>
                                                    <input type="text" id="city" class="form-control"
                                                        placeholder="Enter your city">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="state" class="form-label">State</label>
                                                    <input type="text" id="state" class="form-control"
                                                        placeholder="Enter your state">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="zipCode" class="form-label">Zip Code</label>
                                                    <input type="text" id="zipCode" class="form-control"
                                                        placeholder="Enter your zip code">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="country" class="form-label">Country</label>
                                                    <input type="text" id="country" class="form-control"
                                                        placeholder="Enter your country">
                                                </div>
                                                <div class="mb-3">
                                                    <label for="shoppingPhoneNumber" class="form-label">Phone
                                                        Number</label>
                                                    <input type="text" id="shoppingPhoneNumber" class="form-control"
                                                        placeholder="Enter your phone number">
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
                                            <p id="total-amount-tax" class="card-text">Total Amount (including tax): MMK
                                                0</p>
                                            <hr>
                                            <h6>Payment Method</h6>
                                            <select id="payment-method" class="form-select mb-3">
                                                <c:forEach var="method" items="${paymentMethods}">
                                                    <option value="${method}">${method}</option>
                                                </c:forEach>
                                            </select>
                                            <button id="placeOrderButton" class="btn btn-success w-50">Place
                                                Order</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
                                const totalItemsElement = document.getElementById("total-items");
                                const totalAmountElement = document.getElementById("total-amount");
                                const totalAmountTaxElement = document.getElementById("total-amount-tax");
                                const orderDetailsContainer = document.getElementById("order-details-container");
                                orderDetailsContainer.innerHTML = "";
                                const placeOrderButton = document.getElementById("placeOrderButton");

                                let shopping = [];
                                const userToken = localStorage.getItem('userToken');
                                try {
                                    // Fetch and populate the shipping address
                                    await populateShippingAddress(userToken);
                                    // Fetch shopping items
                                    shopping = await fetchShoppingItems(userToken);
                                } catch (error) {
                                    console.error("Error fetching shopping items:", error);
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error',
                                        text: 'Error fetching shopping items. Please try again later.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    });
                                }

                                if (shopping.length === 0) {
                                    console.log("Cart is empty");
                                } else {
                                    // Display products if the cart is not empty
                                    let totalAmount = 0;
                                    shopping.forEach(product => {
                                        const productTotal = product.discountedPrice
                                            ? product.discountedPrice * product.stockQuantity
                                            : product.price * product.stockQuantity;
                                        totalAmount += productTotal;

                                        // Add product details to the order details card
                                        const orderItem = document.createElement("div");
                                        orderItem.classList.add("mb-3");
                                        orderItem.innerHTML = `
                                            <p><strong>Product Name:</strong> `+ product.name + `</p>` +
                                            `<p><strong>Quantity:</strong> ` + product.stockQuantity + `</p>` +
                                            `<p><strong>Total Price:</strong> MMK ` + productTotal + `</p>` +
                                            `<hr>`
                                            ;
                                        orderDetailsContainer.appendChild(orderItem);
                                    });

                                    // Update the order summary
                                    totalItemsElement.textContent = `Total Items: ` + shopping.length;
                                    totalAmountElement.textContent = `Total Amount : MMK ` + totalAmount;
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
                                        phoneNumber: document.getElementById("shoppingPhoneNumber").value
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

                                    Swal.fire({
                                        title: "Confirm Order",
                                        text: "Are you sure you want to place this order?",
                                        icon: "warning",
                                        showCancelButton: true,
                                        confirmButtonText: "Yes, Place Order",
                                        cancelButtonText: "Cancel"
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            placeOrder(shopping, shippingAddress, paymentMethod);
                                        }
                                    });
                                });
                            });

                            // Function to fetch and populate the shipping address
                            async function populateShippingAddress(userToken) {
                                try {
                                    const response = await fetch("/users/shippingAddress/getShippingAddress", {
                                        method: "GET",
                                        headers: {
                                            "Content-Type": "application/json",
                                            "Authorization": `Bearer ` + userToken
                                        }
                                    });

                                    if (response.ok) {
                                        const shippingAddress = await response.json();
                                        console.log("Shipping Address:", shippingAddress);
                                        if (shippingAddress) {
                                            document.getElementById("addressLine1").value = shippingAddress.addressLine1 || "";
                                            document.getElementById("addressLine2").value = shippingAddress.addressLine2 || "";
                                            document.getElementById("city").value = shippingAddress.city || "";
                                            document.getElementById("state").value = shippingAddress.state || "";
                                            document.getElementById("zipCode").value = shippingAddress.zipCode || "";
                                            document.getElementById("country").value = shippingAddress.country || "";
                                            document.getElementById("shoppingPhoneNumber").value = shippingAddress.phoneNumber;
                                        }
                                    } else {
                                        document.getElementById("addressLine1").value = "";
                                        document.getElementById("addressLine2").value = "";
                                        document.getElementById("city").value = "";
                                        document.getElementById("state").value = "";
                                        document.getElementById("zipCode").value = "";
                                        document.getElementById("country").value = "";
                                        document.getElementById("shoppingPhoneNumber").value = "";
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
                                        price: product.discountedPrice || product.price,
                                        totalPrice: product.discountedPrice ? product.discountedPrice * product.stockQuantity : product.price * product.stockQuantity
                                    }))
                                };

                                // Send the order request to the backend
                                fetch('/users/orders/placeOrder', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization': `Bearer ` + userToken
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

                            async function removeAllProductFromCart(userToken) {
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
                        </script>
                    </body>

                    </html>