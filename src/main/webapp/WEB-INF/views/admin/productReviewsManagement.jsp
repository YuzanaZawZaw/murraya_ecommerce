<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Product Reviews</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productReviews.css?v=1.0">
                <!-- DataTables CSS and Pagination-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datatablePagination.css?v=1.0">
                <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
                <!-- SweetAlert CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
                <!--TOKEN HANDLER-->
                <script src="${pageContext.request.contextPath}/js/tokenHandler.js"></script>
                <style>
                    .collapse {
                        margin-left: 20px;
                    }

                    a {
                        text-decoration: none;
                        color: #333;
                        display: block;
                    }

                    a.active {
                        background-color: #007bff;
                        color: white;
                    }
                </style>
                </style>
            </head>

            <body>
                <!-- Sidebar -->
                <div id="sidebar" class="sidebar">
                    <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                </div>
                <!--End Sidebar-->
                <div class="main-content">
                    <div class="review-container mt-5">
                        <h2 class="mb-4 text-center">Product Reviews</h2>
                        <div class="review-form">
                            <label for="productDropdown" class="form-label">Select Product:</label>
                            <select id="productDropdown" class="form-select mb-3">
                                <option value="">-- Select a Product --</option>
                            </select>
                            <button class="btn btn-outline-secondary" onclick="loadReviews()">Load Reviews</button>
                        </div>
                    </div>
                    <!-- <div id="admin-review-list" class="review-list mt-4"></div> -->
                    <div class="panel-container mt-4">
                        <div id="approved-review-list" class="panel">
                            <h3>Approved Reviews</h3>
                        </div>

                        <div id="pending-review-list" class="panel">
                            <h3>Pending Reviews</h3>
                        </div>
                    </div>

                </div>
                <!-- Bootstrap JS and Dependencies -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <!-- Bootstrap JS (with Popper.js) -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    $(document).ready(function () {
                        const currentUrl = window.location.pathname;

                        if (currentUrl === '/admin/productReviewsManagement' || currentUrl === '/admin/discountManagement' ) {
                            const settingsMenu = document.getElementById('settingsMenu');
                            if (settingsMenu) {
                                settingsMenu.classList.add('show');
                            }
                        }
                        adjustSidebarHeight();
                        fetchProducts();
                        $(window).resize(function () {
                            adjustSidebarHeight();
                        });
                    })

                    async function fetchProducts() {
                        try {
                            const response = await fetch('/admin/products');
                            const products = await response.json();
                            const dropdown = document.getElementById('productDropdown');

                            // Clear existing options
                            dropdown.innerHTML = '<option value="">-- Select a Product --</option>';

                            // Add products to the dropdown
                            products.forEach(product => {
                                const option = document.createElement('option');
                                option.value = product.productId;
                                option.textContent = product.productName;
                                dropdown.appendChild(option);
                            });
                        } catch (error) {
                            console.error('Failed to fetch products:', error);
                        }
                    }

                    function loadReviews() {
                        const productId = document.getElementById('productDropdown').value;
                        if (!productId) {
                            Swal.fire({
                                icon: 'warning',
                                title: 'Warning!',
                                text: 'Please select a product.',
                                showConfirmButton: true
                            });
                            return;
                        }

                        $.ajax({
                            url: `/admin/reviews/` + productId,
                            method: 'GET',
                            dataType: 'json',
                            beforeSend: function () {
                                $('#admin-review-list').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading reviews...</div>');
                            },
                            success: function (data) {
                                console.log("Received data:", data);
                                $('#approved-review-list').empty();
                                $('#pending-review-list').empty();

                                if (data.length === 0) {
                                    $('#approved-review-list').html('<div class="text-center">No reviews found for this product.</div>');
                                    $('#pending-review-list').html('<div class="text-center">No reviews found for this product.</div>');
                                    return;
                                }

                                data.forEach(review => {
                                    const formattedDate = new Date(review.createdAt).toLocaleString();
                                    const stars = '&#9733;'.repeat(review.rating) + '&#9734;'.repeat(5 - review.rating);

                                    const productName = review.productName;
                                    const reviewId = review.reviewId;
                                    const rating = review.rating;
                                    const comment = review.comment;
                                    const userName = review.userName;

                                    // Create review card
                                    const reviewCard = document.createElement('div');
                                    reviewCard.classList.add('card', 'mb-3', 'shadow-lg', 'review-card');

                                    const cardBody = document.createElement('div');
                                    cardBody.classList.add('card-body');

                                    const cardTitle = document.createElement('h5');
                                    cardTitle.classList.add('card-title');
                                    cardTitle.innerHTML = productName + ' - ' + stars;

                                    const cardTextComment = document.createElement('p');
                                    cardTextComment.classList.add('card-text');
                                    cardTextComment.textContent = comment;

                                    const cardTextUser = document.createElement('p');
                                    cardTextUser.classList.add('card-text');
                                    const userInfo = document.createElement('small');
                                    userInfo.classList.add('text-muted');
                                    userInfo.textContent = 'Reviewed by ' + userName + ' on ' + formattedDate;
                                    cardTextUser.appendChild(userInfo);

                                    const approveButton = document.createElement('button');
                                    approveButton.classList.add('btn', 'btn-success', 'btn-sm');
                                    approveButton.textContent = 'Approve';
                                    approveButton.onclick = function () {
                                        approveReview(reviewId, this);
                                        moveToApproved(reviewCard);
                                    };


                                    const deleteButton = document.createElement('button');
                                    deleteButton.classList.add('btn', 'btn-danger', 'btn-sm');
                                    deleteButton.textContent = 'Delete';
                                    deleteButton.onclick = function () {
                                        deleteReview(reviewId);
                                    };

                                    cardBody.appendChild(cardTitle);
                                    cardBody.appendChild(cardTextComment);
                                    cardBody.appendChild(cardTextUser);
                                    cardBody.appendChild(approveButton);
                                    cardBody.appendChild(deleteButton);

                                    reviewCard.appendChild(cardBody);
                                    console.log("review.approve", review.approve);
                                    if (review.approve === true) {
                                        approveButton.disabled = true;
                                        approveButton.textContent = 'Approved';
                                        approveButton.classList.remove('btn-success');
                                        approveButton.classList.add('btn-secondary');

                                        const approvedPanel = document.querySelector('#approved-review-list');
                                        approvedPanel.appendChild(reviewCard);
                                    } else {
                                        const pendingPanel = document.querySelector('#pending-review-list');
                                        pendingPanel.appendChild(reviewCard);
                                    }
                                });

                                function moveToApproved(reviewCard) {
                                    const approvedPanel = document.querySelector('#approved-review-list');
                                    approvedPanel.appendChild(reviewCard);
                                }
                            }
                        });
                    }

                    function approveReview(reviewId, buttonElement) {
                        Swal.fire({
                            title: 'Are you sure?',
                            text: 'Do you want to approve this review?',
                            icon: 'question',
                            showCancelButton: true,
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            confirmButtonText: 'Yes, approve it!'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                // const url=`/admin/reviews/`+reviewId+`/approve`;
                                // console.log(url);
                                buttonElement.disabled = true;
                                buttonElement.textContent = 'Approved';
                                buttonElement.classList.remove('btn-success');
                                buttonElement.classList.add('btn-secondary');
                                $.ajax({
                                    url: `/admin/reviews/` + reviewId + `/approve`,
                                    method: 'PUT',
                                    success: function () {
                                        Swal.fire({
                                            icon: 'success',
                                            title: 'Approved!',
                                            text: 'Review approved successfully.',
                                            showConfirmButton: false,
                                            timer: 1500
                                        }).then(() => {
                                            loadReviews();
                                        });
                                    },
                                    error: function (xhr, status, error) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error!',
                                            text: 'Failed to approve review.',
                                            showConfirmButton: true
                                        });
                                        console.error('Error:', error);
                                    }
                                });
                            }
                        });
                    }

                    function deleteReview(reviewId) {
                        console.log("reviewId", reviewId);
                        Swal.fire({
                            title: 'Are you sure?',
                            text: 'Do you want to delete this review?',
                            icon: 'question',
                            showCancelButton: true,
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            confirmButtonText: 'Yes, delete it!'
                        }).then((result) => {
                            if (result.isConfirmed) {

                                $.ajax({
                                    url: `/admin/reviews/` + reviewId,
                                    method: 'DELETE',
                                    success: function (response) {
                                        Swal.fire({
                                            icon: 'success',
                                            title: 'Success!',
                                            text: response.message,
                                            showConfirmButton: false,
                                            timer: 1500
                                        }).then(() => {
                                            loadReviews();
                                        });
                                    },
                                    error: function (xhr, status, error) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error!',
                                            text: 'Failed to delete review.',
                                            showConfirmButton: true
                                        });
                                        console.error('Error:', error);
                                    }
                                });
                            }
                        })
                    }

                    /*adjusting with sidebar*/
                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.admin-review-list');
                        const sidebar = document.getElementById('sidebar');

                        if (tableContainer && sidebar) {
                            const tableHeight = tableContainer.offsetHeight;
                            const mainContentHeight = document.querySelector('.main-content').offsetHeight;
                            sidebar.style.height = `${mainContentHeight}px`;
                        }
                    }
                </script>

            </body>

            </html>