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
                        <title>Your Favorite Products</title>
                        <!--Main CSS-->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                    </head>

                    <body>
                        <!--Navbar-->
                        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                        <!--End of Navbar-->

                        <!--Start Favorite Items Section -->
                        <div class="container mt-5">
                            <h2 class="text-center mb-4">My Favorites</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/users/userHome">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Favorite Items</li>
                                </ol>
                            </nav>
                            <div class="row" id="favorite-product-container">

                            </div>
                        </div>
                        <!-- End Favorite Items Section -->

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

                                const userToken = localStorage.getItem("userToken");
                                const favoritesContainer = document.querySelector(".row");
                                const productContainer = document.getElementById("favorite-product-container");
                                favoritesContainer.innerHTML = "";

                                fetch("/users/wishlists/items", {
                                    method: "GET",
                                    headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": `Bearer ` + userToken
                                    }
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("Failed to fetch favorite items");
                                        }
                                        return response.json();
                                    })
                                    .then(favorites => {
                                        console.log("Favorite items:", favorites);
                                        if (favorites.length === 0) {
                                            // Display a message if no favorite items are found
                                            const emptyMessage = document.createElement("div");
                                            emptyMessage.classList.add("text-center", "mt-5");
                                            emptyMessage.innerHTML = `
                                                <h4>No favorite items found</h4>
                                                <p>Browse products and add them to your favorites!</p>
                                            `;
                                            favoritesContainer.appendChild(emptyMessage);
                                        } else {
                                            console.log("Favorite items:", favorites);
                                            // Display each favorite product
                                            favorites.forEach(product => {
                                                displayProductElement(product, productContainer);
                                                updateWishlistUI();
                                            });
                                        }
                                    })
                                    .catch(error => {
                                        const emptyMessage = document.createElement("div");
                                        emptyMessage.classList.add("text-center", "mt-5");
                                        emptyMessage.innerHTML = `
                                                <h4>No favorite items found</h4>
                                                <p>Browse products and add them to your favorites!</p>
                                            `;
                                        favoritesContainer.appendChild(emptyMessage);
                                    });

                            });


                        </script>

                    </body>

                    </html>