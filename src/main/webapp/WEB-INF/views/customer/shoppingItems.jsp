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
                            <h2 class="text-center mb-4">My cart</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/users/userHome">Home</a></li>
                                    <li class="breadcrumb-item"><a href="/users/wishlist">Favorite items</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Shopping cart</li>
                                </ol>
                            </nav>
                            <div class="row" id="shopping-items-container"></div>
                            <!-- Place Order Button -->
                            <div class="text-center mt-4">
                                <button id="placeOrderButton" class="btn btn-success">Place Order</button>
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

                                let shopping = JSON.parse(localStorage.getItem("shopping")) || [];
                                const productContainer = document.getElementById("shopping-items-container");
                                productContainer.innerHTML = "";

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
                                    shopping.forEach(product => {
                                        shoppingItemsDisplayProductDetails(product, productContainer);
                                    });
                                }

                                // Add event listener for the "Place Order" button
                                const placeOrderButton = document.getElementById("placeOrderButton");
                                placeOrderButton.addEventListener("click", function () {
                                    placeOrder(shopping);
                                });
                            });

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

                                const description = document.createElement("p");
                                description.classList.add("card-text");
                                description.textContent = product.description;

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
                                        Total Price: <del>`+product.price * product.stockQuantity+`MMK </del><br>`+
                                        `Discounted Total Price: `+calculatedTotal+` MMK`
                                    ;
                                } else {
                                    calculatedTotal = product.price * product.stockQuantity;
                                    totalPrice.textContent = `Total Price: `+calculatedTotal+` MMK`;
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
                                cardBody.appendChild(description);
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
                                let shopping = JSON.parse(localStorage.getItem("shopping")) || [];
                                shopping = shopping.filter(product => product.productId !== productId);
                                localStorage.setItem("shopping", JSON.stringify(shopping));
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Removed from Cart',
                                    text: productId + ` has been removed from your cart.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                }).then(() => {
                                    location.reload();
                                });
                            }

                            function placeOrder(shopping) {
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

                                // Simulate order placement
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order Placed',
                                    text: 'Your order has been placed successfully!',
                                    timer: 3000,
                                    showConfirmButton: false
                                }).then(() => {
                                    // Clear the cart after placing the order
                                    localStorage.removeItem("shopping");
                                    location.reload();
                                });
                            }
                        </script>

                    </body>

                    </html>