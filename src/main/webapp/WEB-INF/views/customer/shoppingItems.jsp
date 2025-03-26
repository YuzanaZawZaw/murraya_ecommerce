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
                                <div id="shopping-items-container">
                                </div>
                                <div class="col-md-6 offset-md-3 mt-4 mb-4">
                                    <button id="checkOutButton" class="btn btn-success w-100">Checkout</button>
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
                                productContainer.innerHTML = "";

                                // Fetch shopping items
                                shopping = await fetchShoppingItems(userToken,productContainer);
                                
                                if(shopping.length ===0){
                                    displayEmptyCartMessage(productContainer);
                                }else{
                                    // Display a message if the cart is empty
                                    shopping.forEach(product => {
                                        shoppingItemsDisplayProductDetails(product, productContainer);
                                    });
                                } 
                                const checkOutButton = document.getElementById("checkOutButton");
                                checkOutButton.addEventListener("click", function () {
                                    window.location.href = "/users/checkOutForm";
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
                            });

                        </script>

                    </body>

                    </html>