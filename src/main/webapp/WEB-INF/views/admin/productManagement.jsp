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
                <title>Product Management</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productManagement.css?v=1.0">
                <!-- DataTables CSS and Pagination-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datatablePagination.css?v=1.0">
                <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
                <!-- SweetAlert CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
                <!--TOKEN HANDLER-->
                <script src="${pageContext.request.contextPath}/js/tokenHandler.js"></script> 
            </head>

            <body>
                <!-- Sidebar -->
                <div id="sidebar" class="sidebar">
                    <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                </div>
                <!--End Sidebar-->

                <!-- Main Content -->
                <div class="main-content">
                    <div class="container mt-5">
                        <h2 class="mb-4 text-center">Product Management</h2>
                        <div class="category-container">
                            <form id="productForm" class="mb-4">
                                <!-- Hidden field to determine if the form is in edit mode -->
                                <input type="hidden" id="isEditing" value="false">
                                <!-- Hidden field to store the product ID when editing -->
                                <input type="hidden" id="productId" name="productId" />
                                <!--edit_Product_Url is hide and store there-->
                                <input type="hidden" id="edit_Product_Url" name="edit_Product_Url" />

                                <div class="form-group">
                                    <label for="name">Product Name</label>
                                    <input type="text" class="form-control" id="name" placeholder="Enter product name"
                                        required>

                                    <label for="price">Price</label>
                                    <input type="number" class="form-control" id="price" placeholder="Enter price"
                                        min="0" step="0.01" required>


                                    <label for="category">Category</label>
                                    <select class="form-control" id="category" required>
                                        <option value="">Select a category</option>
                                    </select>

                                    <label for="stockQuantity">Stock Quantity</label>
                                    <input type="number" class="form-control" id="stockQuantity"
                                        placeholder="Enter stock quantity" min="0" required>

                                    <label for="status">Status</label>
                                    <select class="form-control" id="status" required>
                                        <option value="">Select a status</option>
                                    </select>

                                    <label for="description">Description</label>
                                    <textarea class="form-control" id="description"
                                        placeholder="Enter product description" rows="4" required></textarea>
                                </div>
                                <!-- Submit Button -->
                                <button type="submit" id="submitBtn" class="btn-category">Add Product</button>
                            </form>
                        </div>

                        <div class="table-container mt-3">
                            <table id="myTable" class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Price</th>
                                        <th>Stock quantity</th>
                                        <th>Category</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${productList}">
                                        <tr>
                                            <td>${row.productId}</td>
                                            <td>${row.name}</td>
                                            <td>${row.description}</td>
                                            <td>${row.price} MMK</td>
                                            <td>${row.stockQuantity}</td>
                                            <td>${row.category.name}</td>
                                            <td>${row.status.statusName}</td>
                                            <td>
                                                <!-- View Button -->
                                                <button type="button" class="btn btn-sm btn-info view-product"
                                                    title="View" data-product-id="${row.productId}"
                                                    data-view-url="http://localhost:8080/admin/viewProductDetails/${row.productId}"
                                                    onclick="viewProductPrompt(this)">
                                                    View
                                                </button>
                                                <button type="button" class="btn btn-sm btn-warning"
                                                    data-product-id="${row.productId}"
                                                    data-edit-url="http://localhost:8080/admin/updateProduct/${row.productId}"
                                                    onclick="editProductPrompt(this)">
                                                    Edit
                                                </button>
                                                <a href="http://localhost:8080/admin/deleteProduct/${row.productId}"
                                                    class="btn btn-sm btn-danger" title="Delete"
                                                    data-confirm="Are you sure?">
                                                    Delete
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
                <!-- Typeahead Plugin for auto complete -->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>
                <!-- DataTables JS -->
                <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <script>
                    $(document).ready(function () {
                        fetchCategories();//fetching categories (except parent categories) when page load
                        fetchStatuses()
                        adjustSidebarHeight();

                        $(window).resize(function () {
                            adjustSidebarHeight();
                        });
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

                            api.cells('tr', [0, 1, 2, 3, 4]).every(function () {
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
                        bindDeleteProductButton();
                    });

                    // initially bind delete buttons
                    bindDeleteProductButton();

                    function bindDeleteProductButton() {
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
                                        method: 'DELETE',
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
                                                    text: err.message || 'Failed to delete product.',
                                                });
                                            });
                                        }
                                        return response.text();
                                    }).then(data => {
                                        Swal.fire({
                                            title: 'Deleted!',
                                            text: data,
                                            icon: 'success',
                                            showConfirmButton: false
                                        });
                                        setTimeout(() => {
                                            window.location.reload();
                                        }, 2000);
                                    }).catch(error => {
                                        Swal.fire('Error!', error.message || 'Failed to delete the product.', 'error');
                                    });
                                }
                            });
                        });
                    }


                    async function fetchStatuses() {
                        try {
                            const response = await fetch('/status/allStatuses');
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to load status.',
                                    });
                                });
                            }
                            const data = await response.json();
                            const statusList = data.statusList;

                            //console.log('statusList',statusList);

                            const statusDropdown = document.getElementById('status');
                            statusDropdown.innerHTML = '<option value="">Select a status</option>';
                            statusList.forEach(status => {
                                const option = document.createElement('option');
                                option.value = status.statusId;
                                option.textContent = status.statusName;
                                statusDropdown.appendChild(option);
                            });

                            adjustSidebarHeight();
                        } catch (error) {
                            Swal.fire('Error!', error.message || 'Failed to fetch Status. Please try again later.', 'error');
                        }
                    }

                    //fetch all categories
                    async function fetchCategories() {
                        try {
                            const response = await fetch('/users/childCategories');
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to load categories.',
                                    });
                                });
                            }
                            const data = await response.json();
                            const categoryList = data.childCategoryList;

                            const categoryDropdown = document.getElementById('category');
                            categoryDropdown.innerHTML = '<option value="">Select a category</option>';
                            categoryList.forEach(category => {
                                const option = document.createElement('option');
                                option.value = category.categoryId;
                                option.textContent = category.name;
                                categoryDropdown.appendChild(option);
                            });

                            adjustSidebarHeight();
                        } catch (error) {
                            Swal.fire('Error!', error.message || 'Failed to fetch categories. Please try again later.', 'error');
                        }
                    }

                    //adjusting with sidebar
                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.table-container');
                        const sidebar = document.getElementById('sidebar');

                        if (tableContainer && sidebar) {
                            const tableHeight = tableContainer.offsetHeight;
                            const mainContentHeight = document.querySelector('.main-content').offsetHeight;
                            sidebar.style.height = `${mainContentHeight}px`;
                        }
                    }


                    //calling update and add product using isEditing flag when click submit button
                    $('#productForm').on('submit', function (event) {
                        event.preventDefault();

                        const isEditing = document.getElementById('isEditing').value === "true";
                        if (isEditing) {
                            const updateProductId = document.getElementById('productId').value.trim();
                            const url = document.getElementById('edit_Product_Url').value.trim();//getting hide url
                            updateProduct(updateProductId, url);
                        } else {
                            addProduct();
                        }
                    });

                    // add a new category
                    async function addProduct() {
                        const name = document.getElementById('name').value;
                        const price = parseFloat(document.getElementById('price').value);
                        const description = document.getElementById('description').value;
                        const categoryId = document.getElementById('category').value;
                        const stockQuantity = parseInt(document.getElementById('stockQuantity').value);
                        const statusId = parseInt(document.getElementById('status').value);

                        if (!stockQuantity || !statusId || !price || !categoryId || !name || !description) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Please fill in all fields.',
                            });
                            return;
                        }

                        try {
                            const response = await fetch('/admin/addProduct', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + localStorage.getItem('token')
                                },
                                body: JSON.stringify({
                                    name: name,
                                    price: price,
                                    description: description,
                                    stockQuantity: stockQuantity,
                                    status: {
                                        statusId: statusId
                                    },
                                    category: {
                                        categoryId: categoryId
                                    }
                                })
                            });

                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to add product.',
                                    });
                                });
                            }

                            const data = await response.json();
                            document.getElementById('productForm').reset();//reset productForm data 

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Product added successfully!',
                            }).then(() => {
                                window.location.reload();
                            });
                        } catch (error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to add product. Please try again later.',
                            });
                        }
                    }

                    //onclick="editProductPrompt(this)"
                    function editProductPrompt(buttonElement) {
                        const productId = buttonElement.getAttribute('data-product-id');
                        const edit_Product_Url = buttonElement.getAttribute('data-edit-url');
                        let product = null;

                        // Loop through table rows to find the matching category
                        document.querySelectorAll("#myTable tbody tr").forEach(row => {
                            const rowProductId = row.cells[0].textContent.trim();
                            if (rowProductId === productId) {
                                product = {
                                    productId: rowProductId,
                                    name: row.cells[1].textContent.trim(),
                                    description: row.cells[2].textContent.trim() !== "No Description" ? row.cells[2].textContent.trim() : "",
                                    price: row.cells[3].textContent.trim(),
                                    stockQuantity: row.cells[4].textContent.trim(),
                                    category: row.cells[5].textContent.trim(),
                                    status: row.cells[6].textContent.trim()
                                };
                            }
                        });

                        if (!product) {
                            Swal.fire('Error', 'Product not found', 'error');
                            return;
                        }

                        document.getElementById('productId').value = product.productId;
                        document.getElementById('edit_Product_Url').value = edit_Product_Url;
                        document.getElementById('name').value = product.name;
                        document.getElementById('description').value = product.description || '';
                        document.getElementById('price').value = product.price;
                        document.getElementById('stockQuantity').value = product.stockQuantity;

                        let categoryDropdown = document.getElementById('category');
                        if (product.category) {
                            for (let option of categoryDropdown.options) {
                                if (option.textContent.trim() === product.category) { // Compare text content, not value
                                    option.selected = true;
                                    break;
                                }
                            }
                        } else {
                            categoryDropdown.value = "";
                        }

                        let statusDropdown = document.getElementById('status');
                        if (product.status) {
                            for (let option of statusDropdown.options) {
                                if (option.textContent.trim() === product.status) {
                                    option.selected = true;
                                    break;
                                }
                            }
                        } else {
                            statusDropdown.value = "";
                        }

                        document.getElementById('productId').disabled = true;
                        document.getElementById('isEditing').value = "true";
                        document.getElementById('submitBtn').textContent = "Update Product";
                    }


                    //update product
                    async function updateProduct(updateProductId, url) {

                        const name = document.getElementById('name').value.trim();
                        const price = parseFloat(document.getElementById('price').value);
                        const description = document.getElementById('description').value.trim();
                        const categoryId = document.getElementById('category').value.trim();
                        const stockQuantity = parseInt(document.getElementById('stockQuantity').value);
                        const statusId = parseInt(document.getElementById('status').value);

                        if (!updateProductId || !stockQuantity || !statusId || !price || !categoryId || !name || !description) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Please fill in all fields.',
                            });
                            return;
                        }

                        try {
                            const response = await fetch(url, {
                                method: 'PUT',
                                headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer ' + localStorage.getItem('token')
                                },
                                body: JSON.stringify({
                                    name: name,
                                    price: price,
                                    description: description,
                                    stockQuantity: stockQuantity,
                                    status: {
                                        statusId: statusId
                                    },
                                    category: {
                                        categoryId: categoryId
                                    }
                                })
                            });

                            //fect backend errors and show them
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to update category.',
                                    });
                                });
                            }

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Product updated successfully!',
                            }).then(() => {
                                resetForm();
                                window.location.reload();
                            });
                        } catch (error) {
                            console.error('Error updating product:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to update product. Please try again later.',
                            });
                        }
                    }

                    function viewProductPrompt(buttonElement) {
                        const productId = buttonElement.getAttribute('data-product-id');
                        const view_Product_Url = buttonElement.getAttribute('data-view-url');
                        window.location.href = view_Product_Url;
                    };

                    function resetForm() {
                        document.getElementById('productForm').reset();
                        document.getElementById('productId').disabled = false;
                        document.getElementById('isEditing').value = "false";
                        document.getElementById('submitBtn').textContent = "Add Category";
                    }

                </script>
            </body>

            </html>