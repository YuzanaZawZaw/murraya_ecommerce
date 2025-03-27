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
                        <title>Review history</title>
                        <!--Main CSS-->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
                    </head>

                    <body>
                        <!--Navbar-->
                        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                        <!--End of Navbar-->
                        <div class="container mt-5">
                            <h2 class="text-center mb-4">Review History</h2>
                            <div id="review-history-container" class="row">
                                <!-- User reviews will be dynamically added here -->
                            </div>
                        </div>
                        <!-- Start showing product results-->
                        <jsp:include page="/WEB-INF/views/inc/searchProductResultContainer.jsp"></jsp:include>
                        <!-- End showing product results-->

                        <!-- Footer -->
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
                                const reviewHistoryContainer = document.getElementById("review-history-container");

                                if (!userToken) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Unauthorized Access',
                                        text: 'Please login to view your review history.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    }).then(() => {
                                        window.location.href = "/users/userLoginForm";
                                    });
                                    return;
                                }

                                try {
                                    const response = await fetch("/admin/reviews/userReviews", {
                                        method: "GET",
                                        headers: {
                                            "Content-Type": "application/json",
                                            "Authorization": `Bearer ` + userToken
                                        }
                                    });

                                    if (!response.ok) {
                                        throw new Error("Failed to fetch review history");
                                    }

                                    const reviews = await response.json();

                                    if (reviews.length === 0) {
                                        reviewHistoryContainer.innerHTML = `
                                            <div class="col-12 text-center">
                                                <p class="text-muted">You have not submitted any reviews yet.</p>
                                            </div>
                                            `;
                                        return;
                                    }

                                    reviews.forEach(review => {
                                        const stars = '&#9733;'.repeat(review.rating) + '&#9734;'.repeat(5 - review.rating);
                                        const reviewCard = document.createElement("div");
                                        reviewCard.classList.add("col-md-6", "mb-4");

                                        reviewCard.innerHTML = `
                                            <div class="card shadow-sm">
                                                <div class="card-body">
                                                    <h5 class="card-title">`+ review.productName + ' - ' + stars + `</h5>
                                                    <p class="card-text"><strong>Comment:</strong> `+ review.comment + `</p>
                                                    <p class="card-text text-muted"><small>Reviewed on: `+ new Date(review.createdAt).toLocaleDateString() + `</small></p>
                                                    <button class="btn btn-danger btn-sm remove-review-button" data-review-id="` + review.reviewId + `">Remove</button>
                                                </div>
                                            </div>
                                            `;

                                        reviewHistoryContainer.appendChild(reviewCard);
                                    });
                                } catch (error) {
                                    console.error("Error fetching review history:", error);
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error',
                                        text: 'Failed to load your review history. Please try again later.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    });
                                }
                                reviewHistoryContainer.addEventListener("click", async function (event) {
                                    if (event.target.classList.contains("remove-review-button")) {
                                        const reviewId = event.target.getAttribute("data-review-id");

                                        // Confirm before removing the review
                                        const confirmResult = await Swal.fire({
                                            title: 'Are you sure?',
                                            text: "Do you want to remove this review?",
                                            icon: 'warning',
                                            showCancelButton: true,
                                            confirmButtonColor: '#d33',
                                            cancelButtonColor: '#3085d6',
                                            confirmButtonText: 'Yes, remove it!'
                                        });

                                        if (confirmResult.isConfirmed) {
                                            try {
                                                const response = await fetch(`/admin/reviews/deleteReview?reviewId=`+reviewId, {
                                                    method: "DELETE",
                                                    headers: {
                                                        "Content-Type": "application/json",
                                                        "Authorization": `Bearer ` + userToken
                                                    }
                                                });

                                                if (!response.ok) {
                                                    throw new Error("Failed to remove review");
                                                }

                                                Swal.fire({
                                                    icon: 'success',
                                                    title: 'Removed!',
                                                    text: 'The review has been removed.',
                                                    timer: 2000,
                                                    showConfirmButton: false
                                                });

                                                // Remove the review card from the DOM
                                                event.target.closest(".col-md-6").remove();
                                            } catch (error) {
                                                console.error("Error removing review:", error);
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Error',
                                                    text: 'Failed to remove the review. Please try again later.',
                                                    timer: 2000,
                                                    showConfirmButton: false
                                                });
                                            }
                                        }
                                    }
                                });
                            });
                        </script>

                    </body>

                    </html>