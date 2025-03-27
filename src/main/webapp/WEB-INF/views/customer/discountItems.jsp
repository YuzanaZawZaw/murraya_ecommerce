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
                        <title>Discount Items</title>
                        <!--Main CSS-->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                    </head>

                    <body>
                        <!--Navbar-->
                        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                        <!--End of Navbar-->

                        <!--Start Discounted Products Section -->
                        <div class="container mt-5">
                            <h2 class="text-center mb-4">Discount items (%)</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/users/userHome">Home</a></li>
                                    <li class="breadcrumb-item"><a href="/users/deliveryFreeItems">Delivery free Items</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Discounted Products</li>
                                </ol>
                            </nav>
                            <div class="row" id="discount-product-container">

                            </div>
                        </div>
                        <!-- End Discounted Products Section -->

                        <!-- Start showing product searching results-->
                        <jsp:include page="/WEB-INF/views/inc/searchProductResultContainer.jsp"></jsp:include>
                        <!-- End showing product searching results-->

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

                                const discountContainer = document.querySelector(".row");
                                const productContainer = document.getElementById("discount-product-container");
                                discountContainer.innerHTML = "";

                                fetch("/users/products/discountProducts", {
                                    method: "GET",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        data.forEach(product => {
                                            displayProductElement(product, productContainer);
                                        });
                                        updateWishlistUI();
                                    })
                                    .catch(error => {
                                        console.error("Error fetching discount products :", error);
                                    });
                            });
                        </script>

                    </body>

                    </html>