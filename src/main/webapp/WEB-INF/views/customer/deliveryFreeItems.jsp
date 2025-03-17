<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
            <!--FOR CATEGORIES DROP DOWN-->
            <%@ include file="/WEB-INF/views/inc/categoryDropDown.jsp" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                    <title>Delivery free items</title>
                    <!--Main CSS-->
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                </head>

                <body>
                    <!--Navbar-->
                    <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                    <!--End of Navbar-->

                    <!-- Discounted Products Section -->
                    <div class="container mt-5">
                        <h2 class="text-center mb-4">Delivery free items</h2>
                        <div class="row">
                            <c:forEach var="product" items="${freeDeliveryProducts}">
                                <div class="col-md-4 mb-4">
                                    <div class="single-product">
                                        <div class="product-img">
                                            <img src="/admin/productImage/${product.imageId}" class="card-img-top"
                                                alt="${product.name}" style="height: 200px; object-fit: cover;">
                                            <div class="button-head">
                                                <div class="action-button">
                                                    <a data-toggle="modal" data-target="#exampleModal"
                                                        title="Quick view" href="#"><i class="bi bi-eye"></i>
                                                        <span>Quick View</span>
                                                    </a>
                                                    <a title="wishlist" href="#">
                                                        <i class="bi bi-heart"></i><span>Add to wish
                                                            list</span>
                                                    </a>
                                                    <a title="shopping" href="#">
                                                        <i class="bi bi-cart"></i><span>Buy
                                                            Now</span>
                                                    </a>
                                                </div>
                                                <div class="button-low">
                                                    <a title="Add to cart" href="#">Add to cart</a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="product-title">
                                            <h5 class="card-title">${product.name}</h5>
                                            <!-- Product Price -->
                                            <p class="card-text">
                                                <strong>Price:</strong> ${product.price}MMK
                                                <!-- Discounted Price -->
                                                <br>
                                                <strong>Discounted Price:</strong> ${product.discountedPrice}
                                                <span class="text-danger">(${product.discountPercentage}% off)</span>
                                            </p>
                                            <!-- Product Description -->
                                            <p class="card-text">${product.description}</p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- ======= Footer ======= -->
                    <jsp:include page="/WEB-INF/views/inc/userHomeFooter.jsp"></jsp:include>
                    <!-- End Footer -->

                    <!-- Bootstrap JS and Dependencies -->
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>