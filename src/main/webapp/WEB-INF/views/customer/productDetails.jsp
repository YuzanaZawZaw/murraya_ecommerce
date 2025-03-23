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
                        <title>Product Details</title>
                        <!--Main CSS-->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                    </head>

                    <body>
                        <!--Navbar-->
                        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                        <!--End of Navbar-->

                        <!-- Start product details info-->
                        <div class="container mt-5">
                            <h2 class="text-center mb-4">Product Details</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/users/userHome">Home</a></li>
                                    <li class="breadcrumb-item"><a href="/users/wishlist">Favourite items</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Product Details</li>
                                </ol>
                            </nav>
                            <div id="product-details-container">
                            </div>
                            <div class="container mt-5">
                                <h3 class="text-center mb-4">Customer Reviews</h3>
                                <div id="reviews-container" class="row">
                                    <!-- Reviews will be dynamically added here -->
                                </div>
                                <div class="text-center mt-4">
                                    <button id="reviewButton" class="btn btn-primary">Write a Review</button>
                                </div>
                            </div>
                        </div>
                        <!-- Review Modal -->
                        <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel"
                            aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="reviewModalLabel">Write a Review</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="reviewForm">
                                            <div class="mb-3">
                                                <label for="rating" class="form-label">Rating (1-5)</label>
                                                <select id="rating" class="form-select" required>
                                                    <option value="" disabled selected>Select Rating</option>
                                                    <option value="1">1 - Poor</option>
                                                    <option value="2">2 - Fair</option>
                                                    <option value="3">3 - Good</option>
                                                    <option value="4">4 - Very Good</option>
                                                    <option value="5">5 - Excellent</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="comment" class="form-label">Comment</label>
                                                <textarea id="comment" class="form-control" rows="4"
                                                    placeholder="Write your review here..." required></textarea>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Close</button>
                                        <button type="button" id="submitReviewButton" class="btn btn-primary">Submit
                                            Review</button>
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

                                const userToken = localStorage.getItem('userToken');
                                const productContainer = document.getElementById("product-details-container");
                                const reviewsContainer = document.getElementById("reviews-container");

                                const url = new URL(window.location.href);
                                const searchParams = new URLSearchParams(url.search);
                                const productId = searchParams.get('productId');

                                fetch("/users/products/productDetailsInfo?productId=" + productId, {
                                    method: "GET",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        displayProductDetails(data, productContainer);
                                        updateShoppingCount();
                                    })
                                    .catch(error => {
                                        console.error("Error fetching product details info :", error);
                                    });

                                // Fetch reviews for the product
                                fetch(`/admin/reviews/`+productId, {
                                    method: "GET",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                })
                                    .then(response => response.json())
                                    .then(reviewDtoList => {
                                        if (reviewDtoList.length === 0) {
                                            reviewsContainer.innerHTML = `
                                                    <div class="col-12 text-center">
                                                        <p class="text-muted">No reviews yet for this product.</p>
                                                    </div>
                                                `;
                                            return;
                                        }

                                        reviewDtoList.forEach(review => {
                                            const stars = '&#9733;'.repeat(review.rating) + '&#9734;'.repeat(5 - review.rating);
                                            const reviewCard = document.createElement("div");
                                            reviewCard.classList.add("col-md-6", "mb-4");

                                            reviewCard.innerHTML = `
                                                    <div class="card shadow-sm">
                                                        <div class="card-body">
                                                            <h5 class="card-title">`+review.userName+`</h5>
                                                            <p class="card-text"><strong>Rating:</strong> `+stars+`</p>
                                                            <p class="card-text"><strong>Comment:</strong> `+review.comment+`</p>
                                                            <p class="card-text text-muted"><small>Reviewed on: `+new Date(review.createdAt).toLocaleDateString()+`</small></p>
                                                        </div>
                                                    </div>
                                                `;

                                            reviewsContainer.appendChild(reviewCard);
                                        });
                                    })
                                    .catch(error => {
                                        console.error("Error fetching reviews:", error);
                                        reviewsContainer.innerHTML = `
                                            <div class="col-12 text-center">
                                                <p class="text-danger">Failed to load reviews. Please try again later.</p>
                                            </div>
                                        `;
                                    });
                                const reviewButton = document.getElementById("reviewButton");
                                // Hide the review button if the userToken does not exist
                                if (!userToken) {
                                    reviewButton.style.display = "none";
                                }
                                const submitReviewButton = document.getElementById("submitReviewButton");
                                // Show the modal when the "Review" button is clicked
                                reviewButton.addEventListener("click", function () {
                                    const reviewModal = new bootstrap.Modal(document.getElementById("reviewModal"));
                                    reviewModal.show();
                                });

                                // Handle review submission
                                submitReviewButton.addEventListener("click", function () {
                                    const rating = document.getElementById("rating").value;
                                    const comment = document.getElementById("comment").value;

                                    if (!rating || !comment) {
                                        Swal.fire({
                                            icon: 'warning',
                                            title: 'Incomplete Review',
                                            text: 'Please provide both a rating and a comment.',
                                            timer: 2000,
                                            showConfirmButton: false
                                        });
                                        return;
                                    }

                                    const productId = new URLSearchParams(window.location.search).get('productId');

                                    fetch("/admin/reviews/createReview", {
                                        method: "POST",
                                        headers: {
                                            "Content-Type": "application/json",
                                            "Authorization": `Bearer ` + userToken
                                        },
                                        body: JSON.stringify({
                                            productId: productId,
                                            rating: rating,
                                            comment: comment
                                        })
                                    })
                                        .then(response => {
                                            if (!response.ok) {
                                                throw new Error("Failed to submit review");
                                            }
                                            return response.json();
                                        })
                                        .then(data => {
                                            Swal.fire({
                                                icon: 'success',
                                                title: 'Review Submitted',
                                                text: 'Your review has been submitted successfully.',
                                                timer: 2000,
                                                showConfirmButton: false
                                            }).then(() => {
                                                // Close the modal and reset the form
                                                const reviewModal = bootstrap.Modal.getInstance(document.getElementById("reviewModal"));
                                                reviewModal.hide();
                                                document.getElementById("reviewForm").reset();
                                            });
                                        })
                                        .catch(error => {
                                            console.error("Error submitting review:", error);
                                            Swal.fire({
                                                icon: 'error',
                                                title: 'Error',
                                                text: 'Failed to submit your review. Please try again later.',
                                                timer: 2000,
                                                showConfirmButton: false
                                            });
                                        });
                                });
                            });

                        </script>

                    </body>

                    </html>