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
                <title>Discount Details</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetails.css?v=1.0">
                <!-- DataTables CSS and Pagination-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datatablePagination.css?v=1.0">
                <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
                <!-- SweetAlert CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
                <!--TOKEN HANDLER-->
                <script src="${pageContext.request.contextPath}/js/tokenHandler.js"></script>
                <style>
                    .container {
                        max-width: 600px;
                        margin: 50px auto;
                        background: #ffffff;
                        padding: 20px;
                        border-radius: 10px;
                        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    }

                    .product-table-container {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        margin-top: 20px;
                    }

                    h2 {
                        text-align: center;
                        color: #333;
                    }

                    .search-container {
                        display: flex;
                        gap: 10px;
                        margin-top: 20px;
                    }

                    #productSearch {
                        flex: 1;
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        font-size: 16px;
                    }

                    #searchButton {
                        padding: 10px 20px;
                        font-size: 16px;
                        border: none;
                        border-radius: 5px;
                        background-color: #007bff;
                        color: white;
                        cursor: pointer;
                        transition: background 0.3s ease;
                    }

                    #searchButton:hover {
                        background-color: #0056b3;
                    }

                    #pagination {
                        margin-top: 20px;
                        padding: 10px;
                        background: #fff;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                        min-height: 50px;
                        display: flex;
                        justify-content: flex-end;
                        align-items: center;
                        gap: 10px;
                        width: 80%;
                    }

                    #productTable {
                        width: 80%;
                        border-collapse: collapse;
                        margin-top: 20px;
                    }

                    #productTable th,
                    #productTable td {
                        border: 1px solid #ddd;
                        padding: 10px;
                        text-align: left;
                    }

                    th {
                        background-color: #f2f2f2;
                    }

                    #prevPage,
                    #nextPage {
                        padding: 10px 15px;
                        margin: 5px;
                        border: none;
                        border-radius: 5px;
                        background-color: #007bff;
                        color: white;
                        cursor: pointer;
                        transition: background 0.3s ease;
                    }

                    #prevPage:hover,
                    #nextPage:hover {
                        background-color: #0056b3;
                    }

                    #productTable td[colspan] {
                        text-align: center;
                        font-style: italic;
                        color: #888;
                    }

                    .add-discount-btn {
                        padding: 5px 10px;
                        background-color: #28a745;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                        transition: background 0.3s ease;
                    }

                    .add-discount-btn:hover {
                        background-color: #218838;
                    }

                    .remove-discount-btn {
                        background-color: #dc3545;
                        color: white;
                    }

                    .remove-discount-btn:hover {
                        background-color: #c82333;
                    }

                    .faded-button {
                        opacity: 0.5;
                        cursor: not-allowed;
                    }
                </style>
            </head>

            <body>
                <!-- Sidebar -->
                <div id="sidebar" class="sidebar">
                    <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                </div>
                <!--End Sidebar-->

                <div class="main-content">
                    <!-- View Product Module -->
                    <div class="view-product-container mt-5">
                        <h2 class="mb-4 text-center">Discount Details Management</h2>
                        <div class="category-container">
                            <!-- Product Details -->
                            <div class="product-details">
                                <!-- Back Button -->
                                <a href="/admin/discountManagement" class="back-button">
                                    <i class="fas fa-arrow-left"></i> Discount Management
                                </a>
                                <!-- Hidden field to store the discountCode -->
                                <input type="hidden" id="discountCode" name="discountCode" />
                                <div class="card-header">
                                    <h3>Discount Details</h3>
                                </div>
                                <p><strong>DiscountId</strong> :<span id="discountId"></span></p>
                                <p><strong>Code</strong> :<span id="code"></span></p>
                                <p><strong>Discount Percentage</strong> :<span id="discountPercentage"></span>%</p>
                                <p><strong>Is Delivery Free?</strong> :<span id="freeDelivery"></span></p>
                                <p><strong>Start Date</strong> :<span id="startDate"></span></p>
                                <p><strong>End Date</strong> :<span id="endDate"></span></p>
                            </div>
                        </div>
                    </div>

                    <div class="container">
                        <h2>Add Products to Discount</h2>
                        <div class="search-container">
                            <input type="text" id="productSearch" placeholder="Search for products..."
                                class="form-control" list="productList">
                            <datalist id="productList"></datalist>
                            <button id="searchButton" class="btn btn-primary">Search</button>
                        </div>
                    </div>
                    <div class="product-table-container">
                        <table id="productTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Stock Quantity</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                        <div id="pagination" class="mt-3">
                            <button id="prevPage">Previous</button>
                            <span id="pageInfo"></span>
                            <button id="nextPage">Next</button>
                        </div>
                    </div>

                    <div class="table-container mt-3">
                        <table id="myTable" class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th>Discount code</th>
                                    <th>Price</th>
                                    <th>Discount percentage</th>
                                    <th>Discounted Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${productList}">
                                    <tr>
                                        <td>${row.productName}</td>
                                        <td>${row.discountCode}</td>
                                        <td>${row.price}</td>
                                        <td>${row.discountPercentage}</td>
                                        <td>${row.discountedPrice}</td>
                                        <td>
                                            <a href="/admin/discounts/removeDiscount?productId=${row.productId}&discountCode=${row.discountCode}"
                                                class="btn btn-sm btn-danger" title="Delete"
                                                data-confirm="Are you sure?">
                                                Remove
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                    </div>
                </div>
                </div>

                <!-- Bootstrap JS and Dependencies -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <!-- DataTables JS -->
                <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <!-- Typeahead Plugin for auto complete -->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>

                <script>
                    // initialize
                    $(document).ready(function () {
                        adjustSidebarHeight();

                        $(window).resize(function () {
                            adjustSidebarHeight();
                        });

                        //datatable config
                        var table = $('#myTable').DataTable({
                            paging: true,
                            pagingType: 'full_numbers',
                            searching: true,
                            ordering: true,
                            info: true,
                            lengthMenu: [
                                [5, 10, 25, 50, 75, 100],
                                ['5 Rows', '10 Rows', '25 Rows', '50 Rows', '75 Rows', '100 Rows']
                            ],
                            initComplete: function () {
                                var api = this.api();
                                var dataSrc = [];

                                api.cells('tr', [0, 1, 2, 3, 4, 5]).every(function () {
                                    var data = $('<div>').html(this.data()).text();
                                    if (dataSrc.indexOf(data) === -1) {
                                        dataSrc.push(data);
                                    }
                                });

                                dataSrc.sort();

                                $('.dataTables_filter input[type="search"]', api.table().container())
                                    .typeahead({
                                        source: dataSrc,
                                        afterSelect: function (value) {
                                            api.search(value).draw();
                                        }
                                    });
                            }
                        });

                        //draw delete category buttons
                        table.on('draw', function () {
                            bindRemoveProductButton();
                        });

                        // initially bind delete buttons
                        bindRemoveProductButton();

                        function bindRemoveProductButton() {
                            $("[data-confirm]").on("click", function (e) {
                                e.preventDefault();
                                var href = $(this).attr("href");
                                var message = $(this).data("confirm");

                                Swal.fire({
                                    title: 'Are you sure?',
                                    text: message,
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonColor: '#d33',
                                    cancelButtonColor: '#3085d6',
                                    confirmButtonText: 'Yes, delete it!',
                                    cancelButtonText: 'Cancel'
                                }).then((willDelete) => {
                                    if (willDelete.isConfirmed) {
                                        fetch(href, {
                                            method: 'PUT',
                                            headers: {
                                                'Content-Type': 'application/json',
                                                'Authorization': 'Bearer ' + localStorage.getItem('token')
                                            }
                                        }).then(response => {
                                            if (!response.ok) {
                                                return response.json().then(err => {
                                                    Swal.fire({
                                                        icon: 'error',
                                                        title: 'Error!',
                                                        text: err.message || 'Failed to remove product.',
                                                    });
                                                });
                                            }
                                            return response.text();
                                        }).then(data => {
                                            Swal.fire({
                                                title: 'Removed!',
                                                text: 'Successfully removed',
                                                icon: 'success',
                                                showConfirmButton: false
                                            });
                                            setTimeout(() => {
                                                window.location.reload();
                                            }, 2000);
                                        }).catch(error => {
                                            Swal.fire('Error!', error.message || 'Failed to remove the product.', 'error');
                                        });
                                    }
                                });
                            });
                        }

                        const pathParts = window.location.pathname.split('/');
                        const discountId = pathParts[pathParts.length - 1];

                        const productSearch = document.getElementById("productSearch");
                        const dataList = document.getElementById("productList");
                        const searchButton = document.getElementById('searchButton');


                        if (discountId) {
                            // load discount details
                            loadDiscountDetails(discountId);

                            //click productSearch input
                            productSearch.addEventListener("input", async function () {
                                const query = productSearch.value.trim();
                                if (query.length < 2) return;

                                try {
                                    const response = await fetch(`/admin/products/productNames?query=` + query);
                                    const products = await response.json();
                                    console.log(products);
                                    dataList.innerHTML = "";
                                    products.forEach(product => {
                                        let option = document.createElement("option");
                                        option.value = product.productName;
                                        console.log(product.productName);
                                        dataList.appendChild(option);
                                    });
                                } catch (error) {
                                    console.error("Error fetching products:", error);
                                }
                            });

                            //click add-discount-btn
                            document.addEventListener("click", async function (event) {
                                const target = event.target;
                                const productId = target.getAttribute("data-product-id");
                                const discountCode = document.getElementById('discountCode').value.trim();

                                if (target.classList.contains("add-discount-btn")) {
                                    const url = '/admin/discounts/applyDiscount?productId=' + productId + '&discountCode=' + discountCode;
                                    console.log('url::', url);
                                    try {
                                        const response = await fetch(url, {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/json' }
                                        });

                                        if (!response.ok) {
                                            return response.json().then(err => {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Error!',
                                                    text: err.message || 'Failed to add discount.',
                                                });
                                            });
                                        }

                                        const result = await response.json();

                                        Swal.fire({
                                            icon: 'success',
                                            title: 'Success!',
                                            text: 'Discount added successfully!',
                                        }).then(() => {
                                            window.location.reload();
                                        });
                                    } catch (error) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error!',
                                            text: error.message || 'Failed to add discount. Please try again later.',
                                        });
                                    }
                                }
                            });

                            //click search button
                            searchButton.addEventListener('click', async function () {
                                productSearchResult();
                            })
                        } else {
                            Swal.fire('Error', 'Discount ID not found', 'error');
                        }
                    });

                    async function productSearchResult(discountId) {
                        const productSearch = document.getElementById('productSearch');
                        const searchButton = document.getElementById('searchButton');
                        const query = productSearch.value.trim();
                        if (!query) {
                            alert('Please enter a search term.');
                            return;
                        }
                        try {

                            const encodedQuery = encodeURIComponent(query);
                            const response = await fetch('/admin/products/search?query=' + encodedQuery);
                            if (!response.ok) {
                                throw new Error('Failed to fetch products.');
                            }
                            const products = await response.json();
                            console.log(products);
                            displaySearchResults(products);
                        } catch (error) {
                            console.error('Error searching for products:', error);
                            alert('Failed to search for products. Please try again later.');
                        }
                    }
                    /*Load product info*/
                    async function loadDiscountDetails(discountId) {
                        console.log('discountId::', discountId)
                        try {
                            // Fetch product details
                            const response = await fetch('/admin/discounts/viewDiscount/${discountId}');
                            console.log(response.status);
                            if (!response.ok) {
                                throw new Error('Failed to fetch discount details');
                            }

                            const discount = await response.json();

                            // Display product details
                            document.getElementById('discountId').textContent = discount.discount.discountId;
                            document.getElementById('code').textContent = discount.discount.code;
                            document.getElementById('discountPercentage').textContent = discount.discount.discountPercentage;
                            if (discount.discount.freeDelivery === true) {
                                document.getElementById('freeDelivery').textContent = 'Yes';
                            } else {
                                document.getElementById('freeDelivery').textContent = 'No';
                            }
                            document.getElementById('discountCode').value = discount.discount.code;
                            document.getElementById('startDate').textContent = formatDate(discount.discount.startDate);
                            document.getElementById('endDate').textContent = formatDate(discount.discount.endDate);
                        } catch (error) {
                            Swal.fire('Error', 'Failed to load discount details', 'error');
                        }
                    }

                    function formatDate(date) {
                        if (!date) return "";
                        const parsedDate = new Date(date);
                        return parsedDate.toISOString().split('T')[0];
                    }

                    function displaySearchResults(products) {
                        const tableBody = document.querySelector("#productTable tbody");
                        tableBody.innerHTML = '';
                        const row = document.createElement("tr");
                        if (products.content.length === 0) {
                            const row = document.createElement("tr");
                            row.innerHTML = `
                            <td colspan="5">No product found</td>
                            `;
                            tableBody.appendChild(row);
                        } else {
                            products.content.forEach(product => {
                                const row = document.createElement("tr");

                                const idCell = document.createElement("td");
                                idCell.textContent = product.productId;

                                const nameCell = document.createElement("td");
                                nameCell.textContent = product.productName;

                                const priceCell = document.createElement("td");
                                priceCell.textContent = product.price;

                                const stockCell = document.createElement("td");
                                stockCell.textContent = product.stockQuantity;

                                const actionCell = document.createElement("td");
                                const discountButton = document.createElement("button");

                                discountButton.textContent = "Add Discount";
                                discountButton.classList.add("add-discount-btn");
                                discountButton.setAttribute("data-product-id", product.productId);

                                if (product.discountId !== 0) {
                                    discountButton.classList.add("faded-button");
                                    discountButton.disabled = true;
                                }

                                actionCell.appendChild(discountButton);

                                row.appendChild(idCell);
                                row.appendChild(nameCell);
                                row.appendChild(priceCell);
                                row.appendChild(stockCell);
                                row.appendChild(actionCell);

                                tableBody.appendChild(row);
                            });
                            // Update pagination controls
                            const pageInfo = document.getElementById("pageInfo");
                            const prevPageButton = document.getElementById("prevPage");
                            const nextPageButton = document.getElementById("nextPage");

                            pageInfo.textContent = `Page ` + (products.number + 1) + `of` + products.totalPages;

                            prevPageButton.disabled = products.first;
                            nextPageButton.disabled = products.last;

                            prevPageButton.addEventListener("click", () => {
                                console.log("Loading previous page...");
                            });

                            nextPageButton.addEventListener("click", () => {
                                console.log("Loading next page...");
                            });
                        }
                    }

                    /*adjusting with sidebar*/
                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.existing-images');
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