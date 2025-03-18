<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
            <!--FOR CATEGORIES DROP DOWN-->
            <%@ include file="/WEB-INF/views/inc/categoryDropDown.jsp" %>
                <!doctype html>
                <html>

                <head>
                    <title>e-commerce</title>
                    <!-- Required meta tags -->
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                    <!--Main CSS-->
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                </head>

                <body>
                    <!--Navbar-->
                    <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                    <!--End of Navbar-->

                    <!--Banner-->
                    <section>
                        <div class="banner">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-6 ml-auto order-md-2 align-self-start">
                                        <div class="banner-content">
                                            <h2 class="first-title">Murraya Online Boutique</h2>
                                            <h1>Welcome</h1>
                                            <p>Let's shopping with us</p>

                                        </div>
                                    </div>
                                    <div class="col-md-6 order-1 align-self-end">
                                        <section class="new-arrivals">
                                            <h2>New Arrivals</h2>
                                            <div id="carouselExampleControls" class="carousel slide"
                                                data-ride="carousel">
                                                <div class="carousel-inner" id="carousel-inner">
                                                    <!-- Products will be dynamically inserted here -->
                                                </div>
                                                <a class="carousel-control-prev" href="#carouselExampleControls"
                                                    role="button" data-slide="prev">
                                                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                                    <span class="sr-only">Previous</span>
                                                </a>
                                                <a class="carousel-control-next" href="#carouselExampleControls"
                                                    role="button" data-slide="next">
                                                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                                    <span class="sr-only">Next</span>
                                                </a>
                                            </div>
                                        </section>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!--End of Banner-->
                    <!--Categories-->
                    <section>
                        <div class="category-section">
                            <div class="container-fluid">
                                <div class="row">
                                    <!---->
                                    <div class="col-lg-4">
                                        <div class="category-alone">
                                            <img src="${pageContext.request.contextPath}/images/NADESHIKO_Rice_Mask.jpg"
                                                class="img-fluid" alt="#">
                                            <div class="inner">
                                                <h4>Beauty</h4>
                                            </div>
                                        </div>
                                    </div>
                                    <!---->
                                    <div class="col-lg-4">
                                        <div class="category-alone">
                                            <img src="${pageContext.request.contextPath}/images/Shirts_cover.jpg"
                                                class="img-fluid" alt="#">
                                            <div class="inner">
                                                <h4>Clothing</h4>
                                            </div>
                                        </div>
                                    </div>
                                    <!---->
                                    <div class="col-lg-4">
                                        <div class="category-alone">
                                            <img src="${pageContext.request.contextPath}/images/Sweat_Shirt_Girl1.jpg"
                                                class="img-fluid" alt="#">
                                            <div class="inner">
                                                <h4>Sweatshirts</h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!--End of Categories-->
                    <!-- Start showing product results-->
                    <jsp:include page="/WEB-INF/views/inc/searchProductResultContainer.jsp"></jsp:include>
                    <!-- End showing product results-->
                    <!--Products-->
                    <section>
                        <div class="product-panel">
                            <div class="container">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="section-title">
                                            <h2 class="text-center">Trending-item</h2>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12">
                                        <div class="product-detail">
                                            <div class="nav-main">
                                                <!---Tab Sec-->
                                                <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                    <li class="nav-item">
                                                        <a class="nav-link active" data-toggle="tab" href="#accessories"
                                                            role="tab">Accessories</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#beauty"
                                                            role="tab">Beauty</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#clothing"
                                                            role="tab">Clothing</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#apple"
                                                            role="tab">Apple</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#shoes"
                                                            role="tab">Shoes</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <!--End of Tabs-->
                                            <div class="tab-content" id="myTabContent">
                                                <!--Single Tab-->
                                                <div class="tab-pane fade show active" id="accessories" role="tabpanel">
                                                    <div class="tab-single">
                                                        <div class="row" id="accessories-product-container">

                                                        </div>
                                                    </div>
                                                </div>
                                                <!--2nd Tab-->
                                                <div class="tab-pane fade" id="beauty" role="tabpanel">
                                                    <div class="tab-single">
                                                        <div class="row" id="beauty-product-container">

                                                        </div>
                                                    </div>
                                                </div>
                                                <!--End of 2nd Tab-->
                                                <!---3rd tab Start-->
                                                <div class="tab-pane fade" id="clothing" role="tab-panel">
                                                    <div class="tab-single">
                                                        <div class="row" id="clothing-product-container">

                                                        </div>
                                                    </div>
                                                </div>
                                                <!--End of 3nd Tab-->
                                                <!---4th tab Start-->
                                                <div class="tab-pane fade" id="apple" role="tab-panel">
                                                    <div class="tab-single">
                                                        <div class="row" id="apple-product-container">

                                                        </div>
                                                    </div>
                                                </div>
                                                <!--End of 4th Tab-->
                                                <!---5th tab Start-->
                                                <div class="tab-pane fade" id="shoes" role="tab-panel">
                                                    <div class="tab-single">
                                                        <div class="row" id="shoes-product-container">

                                                        </div>
                                                    </div>
                                                </div>
                                                <!--End of 5th Tab-->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>



                    <!--Service Section-->
                    <section class="service-intro m-3">
                        <div class="container">
                            <div class="row no-gutters">
                                <div class="col-md-4 d-flex">
                                    <div class="intro d-lg-flex">
                                        <div class="icon">
                                            <i class="fas fa-phone-volume"></i>
                                        </div>
                                        <div class="text">
                                            <h2>Online Support 24/7</h2>
                                            <p>Enjoy your shopping.</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 d-flex">
                                    <div class="intro color-1 d-lg-flex">
                                        <div class="icon">
                                            <i class="fas fa-wallet"></i>
                                        </div>
                                        <div class="text">
                                            <h2>Money Back Guarantee</h2>
                                            <p>Wave,KBZ,CB payment are available.</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 d-flex">
                                    <div class="intro color-2 d-lg-flex">
                                        <div class="icon">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <div class="text">
                                            <h2>Free Shipping &amp; Return</h2>
                                            <p>Shipping within 3 days (office hour)</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!--End of Service Section-->
                    <!--? About  Start-->
                    <section class="m-3">
                        <div class="about-area section-padding 30">
                            <div class="container">
                                <div class="row align-items-center justify-content-between padding-130">
                                    <div class="col-lg-5 col-md-6">
                                        <div class="about-details mb-40">
                                            <h2>Discount items (%)</h2>
                                            <p>Shop Smart, Save Big. Grab amazing discounts (%) on your favorite items,
                                                only for a
                                                limited time.</p>
                                            <a href="/users/discountItems" class="btn btn-about">Click Here</a>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-10">
                                        <div class="about-img mb-40">
                                            <img src="${pageContext.request.contextPath}/images/Coloured sales background.jpg"
                                                class="img-fluid" alt="">
                                        </div>
                                    </div>
                                </div>
                                <div class="row align-items-center justify-content-between">
                                    <div class="col-lg-6 col-md-6 col-sm-10">
                                        <div class="about-img mb-40">
                                            <img src="${pageContext.request.contextPath}/images/Free Delivery man riding a scooter.jpg"
                                                class="img-fluid" alt="">
                                        </div>
                                    </div>
                                    <div class="col-lg-5 col-md-6">
                                        <div class="about-details mb-40">
                                            <h2>Delivery free items</h2>
                                            <p>Fast or Free? Get your order in just 3 days, or wait a little longer (5
                                                days) for
                                                FREE
                                                delivery. The choice is yours.</p>
                                            <a href="/users/deliveryFreeItems" class="btn btn-about">Know More</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!-- About  End-->

                    <!-- ======= Footer ======= -->
                    <jsp:include page="/WEB-INF/views/inc/userHomeFooter.jsp"></jsp:include>
                    <!-- End Footer -->
                    <!-- Bootstrap JS and Dependencies -->
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <!-- SweetAlert Library -->
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                    <!--Product Metric-->
                    <script src="${pageContext.request.contextPath}/js/productMetric.js"></script>

                    <script>
                        //getting trending products
                        function fetchTrendingProducts(categoryId, containerId) {
                            const url = "/users/products/trending/" + categoryId;
                            const productContainer = document.getElementById(containerId);

                            fetch(url)
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error("Network response was not ok");
                                    }
                                    return response.json();
                                })
                                .then(data => {
                                    console.log('data', data);
                                    productContainer.innerHTML = "";
                                    data.forEach(product => displayProductElement(product, productContainer));
                                })
                                .catch(error => {
                                    console.error("Error fetching trending products:", error);
                                });
                        }

                        // getting new arrival product within 30 days
                        function fetchNewArrivalsProducts() {
                            fetch("/users/products/newArrivals")
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error("Error in new arrivals products");
                                    }
                                    return response.json();
                                })
                                .then(data => {
                                    const carouselInner = document.getElementById("carousel-inner");
                                    carouselInner.innerHTML = "";

                                    data.forEach((product, index) => {
                                        const carouselItem = document.createElement("div");
                                        carouselItem.classList.add("carousel-item");
                                        if (index === 0) {
                                            carouselItem.classList.add("active");
                                        }
                                        const productImage = document.createElement('img');
                                        const imageUrl = `/admin/productImage/` + product.imageId;
                                        productImage.src = imageUrl;
                                        productImage.classList.add('d-block', 'w-100');
                                        productImage.alt = product.name;

                                        productImage.style.height = "300px";
                                        productImage.style.objectFit = "cover";

                                        const productName = document.createElement('h3');
                                        productName.textContent = product.name;

                                        const productPrice = document.createElement('p');
                                        productPrice.textContent = product.price.toFixed(2);

                                        const shopNowButton = document.createElement('a');
                                        shopNowButton.href = "/users/userLoginForm";
                                        shopNowButton.classList.add('btn', 'btn-hero');
                                        shopNowButton.textContent = 'Shop Now';

                                        carouselItem.appendChild(productImage);
                                        carouselItem.appendChild(productName);
                                        carouselItem.appendChild(productPrice);
                                        carouselItem.appendChild(shopNowButton);

                                        carouselInner.appendChild(carouselItem);

                                    });
                                })
                                .catch((error) => {
                                    console.error("Error fetching new arrivals:", error);
                                });
                        }

                        document.addEventListener("DOMContentLoaded", function () {
                            $('#carouselExampleControls').carousel();
                            fetchTrendingProducts("ACCESSORIES", "accessories-product-container");
                            fetchTrendingProducts("BEAUTY", "beauty-product-container");
                            fetchTrendingProducts("CLOTHING", "clothing-product-container");
                            fetchTrendingProducts("APPLE", "apple-product-container");
                            fetchTrendingProducts("SHOES", "shoes-product-container");
                            fetchNewArrivalsProducts();
                        });

                    </script>
                </body>

                </html>