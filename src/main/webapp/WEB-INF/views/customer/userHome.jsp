<!doctype html>
<html lang="en">

<head>
    <title>e-commerce</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!--Logo-->
    <link rel="shortcut icon" type="image/jpg" href="${pageContext.request.contextPath}/images/murraya_logo.jpg">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
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
                            <a href="/userLogin" class="btn btn-hero">Shop Now</a>
                        </div>
                    </div>
                    <div class="col-md-6 order-1 align-self-end">
                        <img src="${pageContext.request.contextPath}/images/shirt_cover1.jpg" alt="#" class="img-fluid">
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
                            <img src="${pageContext.request.contextPath}/images/NADESHIKO_Rice_Mask.jpg" class="img-fluid" alt="#">
                            <div class="inner">
                                <h4>Skincare</h4>
                            </div>
                        </div>
                    </div>
                    <!---->
                    <div class="col-lg-4">
                        <div class="category-alone">
                            <img src="${pageContext.request.contextPath}/images/Shirts_cover.jpg" class="img-fluid" alt="#">
                            <div class="inner">
                                <h4>Shirts</h4>
                            </div>
                        </div>
                    </div>
                    <!---->
                    <div class="col-lg-4">
                        <div class="category-alone">
                            <img src="${pageContext.request.contextPath}/images/Sweat_Shirt_Girl1.jpg" class="img-fluid" alt="#">
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
                                        <a class="nav-link active" data-toggle="tab" href="#skincare"
                                            role="tab">Skincare</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#shirts" role="tab">Shirts</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#sweatshirts"
                                            role="tab">Sweatshirts</a>
                                    </li>
                                </ul>
                            </div>
                            <!--End of Tabs-->
                            <div class="tab-content" id="myTabContent">
                                <!--Single Tab-->
                                <div class="tab-pane fade show active" id="skincare" role="tabpanel">
                                    <div class="tab-single">
                                        <div class="row">
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/OMI_Menturm_Tulip_pink_lipstick.jpg" class="main-img" alt="Lipstick">
                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/naturie_skin_conditioner.jpg"
                                                                class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/lululun_face_mask.jpg" class="main-img"
                                                                alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3 class="old"><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/shelseido_lip_balm.jpg" class="main-img"
                                                                alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/biore_nose_pore_mask.jpg" class="main-img"
                                                                alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/oxy_deep_wash.jpg" class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/uno_wash_scrub.jpg" class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/biore_men_facial_wash.jpg" class="main-img"
                                                                alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                        </div>
                                    </div>
                                </div>
                                <!--End of Single Tab-->
                                <!---2nd tab Start-->
                                <div class="tab-pane fade" id="shirts" role="tab-panel">
                                    <div class="tab-single">
                                        <div class="row">
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/shirt2.jpg" class="main-img" alt="">
                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                            <!---->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/shirt3.jpg" class="main-img" alt="">
                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                            <!---->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/shirt4.jpg" class="main-img" alt="">
                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                            <!---->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/shirt7.jpg" class="main-img" alt="">
                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                            <!---->
                                        </div>
                                    </div>
                                </div>
                                <!--3rd tab Start-->
                                <!---2nd tab Start-->
                                <div class="tab-pane fade" id="sweatshirts" role="tab-panel">
                                    <div class="tab-single">
                                        <div class="row">
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/sweatshirt1.jpg" class="main-img" alt="">
                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                            <!---->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/sweatshirt2.jpg" class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/sweatshirt3.jpg" class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/sweatshirt4.jpg" class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                            <!--Start-->
                                            <div class="col-xl-3 col-lg-4 col-md-4 col-12">
                                                <div class="single-product">
                                                    <div class="product-img">
                                                        <a href="#">
                                                            <img src="${pageContext.request.contextPath}/tabs/sweatshirt5.jpg" class="main-img" alt="#">

                                                        </a>
                                                        <div class="button-head">
                                                            <div class="action-button">
                                                                <a data-toggle="modal" data-target="#exampleModal"
                                                                    title="Quick view" href="#"><i
                                                                        class="bi bi-eye"></i>
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
                                                        <h3><a href="">Lorem Ipsum</a></h3>
                                                        <div class="product-price">
                                                            <span>$25-00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!----->
                                        </div>
                                    </div>
                                </div>
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
                            <p>Shop Smart, Save Big. Grab amazing discounts (%) on your favorite items, only for a
                                limited time.</p>
                            <a href="#" class="btn btn-about">Click Here</a>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-sm-10">
                        <div class="about-img mb-40">
                            <img src="${pageContext.request.contextPath}/images/discount_item4.jpg" class="img-fluid" alt="">
                        </div>
                    </div>
                </div>
                <div class="row align-items-center justify-content-between">
                    <div class="col-lg-6 col-md-6 col-sm-10">
                        <div class="about-img mb-40">
                            <img src="${pageContext.request.contextPath}/images/discount_item3.jpg" class="img-fluid" alt="">
                        </div>
                    </div>
                    <div class="col-lg-5 col-md-6">
                        <div class="about-details mb-40">
                            <h2>Delivery free items</h2>
                            <p>Fast or Free? Get your order in just 3 days, or wait a little longer (5 days) for FREE
                                delivery. The choice is yours.</p>
                            <a href="#" class="btn btn-about">Know More</a>
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
    




    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>
</html>