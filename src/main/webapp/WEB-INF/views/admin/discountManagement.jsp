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
                <title>Product Discount Management</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/categoryManagement.css?v=1.0">
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
            </head>

            <body>
                <!-- Sidebar -->
                <div id="sidebar" class="sidebar">
                    <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                </div>
                <!--End Sidebar-->

                <!--Main Content-->
                <div class="main-content">
                    <div class="container mt-5">
                        <h2 class="mb-4 text-center">Product Discount Management</h2>
                        <div class="category-container">
                            <form id="discountForm" class="mb-4">
                                <!--dynamically use create or edit form-->
                                <input type="hidden" id="isEditing" value="false">
                                <!-- Hidden field to store the discount ID when editing -->
                                <input type="hidden" id="discountId" name="discountId" />
                                <!--edit_Discount_Url is hide and store there-->
                                <input type="hidden" id="edit_Discount_Url" name="edit_Discount_Url" />
                                <div class="form-group">

                                    <label for="code">Discount Code:</label>
                                    <input type="text" id="code" name="code" required />

                                    <label for="discountPercentage">Discount Percentage:</label>
                                    <input type="number" id="discountPercentage" name="discountPercentage" step="0.01"
                                        required />

                                    <div class="checkbox-container">
                                        <label for="freeDelivery" class="checkbox-label">Free Delivery:</label>
                                        <input type="checkbox" id="freeDelivery" name="freeDelivery"
                                            class="checkbox-input" />
                                    </div>

                                    <div class="date-container">
                                        <div class="date-group">
                                            <label for="startDate" class="date-label">Start Date:</label>
                                            <input type="date" id="startDate" name="startDate" class="date-input"
                                                required />
                                        </div>
                                        <div class="date-group">
                                            <label for="endDate" class="date-label">End Date:</label>
                                            <input type="date" id="endDate" name="endDate" class="date-input"
                                                required />
                                        </div>
                                    </div>

                                </div>
                                <button type="submit" id="submitBtn" class="btn-category">Add Discount</button>
                            </form>
                        </div>

                        <div class="table-container mt-3">
                            <table id="myTable" class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Code</th>
                                        <th>Discount percentage</th>
                                        <th>Free Delivery</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${discountList}">
                                        <tr>
                                            <td>${row.discountId}</td>
                                            <td>${row.code}</td>
                                            <td>${row.discountPercentage}</td>
                                            <td>${row.freeDelivery}</td>
                                            <td>${row.startDate}</td>
                                            <td>${row.endDate}</td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-info view-product"
                                                    title="View" data-discount-id="${row.discountId}"
                                                    data-view-url="/admin/viewDiscountDetails/${row.discountId}"
                                                    onclick="viewDiscountPrompt(this)">
                                                    View
                                                </button>
                                                <button type="button" class="btn btn-sm btn-warning"
                                                    data-discount-id="${row.discountId}"
                                                    data-edit-url="/admin/discounts/updateDiscount/${row.discountId}"
                                                    onclick="editDiscountPrompt(this)">
                                                    Edit
                                                </button>
                                                <a href="/admin/discounts/deleteDiscount/${row.discountId}"
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

                <!-- Typeahead Plugin for auto complete -->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>
                <!-- DataTables JS -->
                <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
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
                    });
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

                    //draw delete discount buttons
                    table.on('draw', function () {
                        bindDeleteDiscountButton();
                    });

                    // initially bind delete buttons
                    bindDeleteDiscountButton();

                    function bindDeleteDiscountButton() {
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
                                            'Content-Type': 'application/json'
                                        }
                                    }).then(response => {
                                        if (!response.ok) {
                                            return response.json().then(err => {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Error!',
                                                    text: err.message || 'Failed to delete discount.',
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
                                        Swal.fire('Error!', error.message || 'Failed to delete the discount.', 'error');
                                    });
                                }
                            });
                        });
                    }

                    //calling update and add discount using isEditing flag when click submit button
                    $('#discountForm').on('submit', function (event) {
                        event.preventDefault();

                        const isEditing = document.getElementById('isEditing').value === "true";
                        if (isEditing) {
                            const updateDiscountId = document.getElementById('discountId').value.trim();
                            const url = document.getElementById('edit_Discount_Url').value.trim();//getting hide url
                            updateDiscount(updateDiscountId, url);
                        } else {
                            addDiscount();
                        }
                    });

                    // add a new discount
                    async function addDiscount() {
                        const code = document.getElementById('code').value.trim();
                        const discountPercentage = document.getElementById('discountPercentage').value.trim();
                        const freeDelivery = document.getElementById('freeDelivery').checked;
                        const startDate = document.getElementById('startDate').value;
                        const endDate = document.getElementById('endDate').value;

                        if (!code || !discountPercentage || !startDate || !endDate) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Please fill in all fields.',
                            });
                            return;
                        }

                        try {
                            const response = await fetch('/admin/discounts/addDiscount', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({
                                    code,
                                    discountPercentage,
                                    freeDelivery,
                                    startDate,
                                    endDate
                                })
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
                            console.log('Discount added:', result.discountId);

                            document.getElementById('discountForm').reset();//reset discountForm data 

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Discount added successfully!',
                            }).then(() => {
                                window.location.reload();//reload when adding a new discount
                            });
                        } catch (error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to add discount. Please try again later.',
                            });
                        }
                    }

                    function viewDiscountPrompt(buttonElement) {
                        const discountId = buttonElement.getAttribute('data-discount-id');
                        const view_Discount_Url = buttonElement.getAttribute('data-view-url');
                        window.location.href = view_Discount_Url;
                    };

                    //onclick="editDiscountPrompt(this)"
                    function editDiscountPrompt(buttonElement) {
                        const discountId = buttonElement.getAttribute('data-discount-id');
                        const edit_Discount_Url = buttonElement.getAttribute('data-edit-url');
                        let discount = null;

                        // Loop through table rows to find the matching category
                        document.querySelectorAll("#myTable tbody tr").forEach(row => {
                            const rowDiscountId = row.cells[0].textContent.trim();
                            if (rowDiscountId === discountId) {
                                discount = {
                                    discountId: rowDiscountId,
                                    code: row.cells[1].textContent.trim(),
                                    discountPercentage: row.cells[2].textContent.trim(),
                                    freeDelivery: row.cells[3].textContent.trim(),
                                    startDate: row.cells[4].textContent.trim(),
                                    endDate: row.cells[5].textContent.trim()
                                };
                            }
                        });

                        if (!discount) {
                            Swal.fire('Error', 'Discount not found', 'error');
                            return;
                        }

                        document.getElementById('edit_Discount_Url').value = edit_Discount_Url;
                        document.getElementById('code').value = discount.code;
                        document.getElementById('discountPercentage').value = discount.discountPercentage;

                        const freeDelivery = discount.freeDelivery === "true" || discount.freeDelivery === true;
                        document.getElementById('freeDelivery').checked = freeDelivery;

                        document.getElementById('startDate').value = discount.startDate;
                        document.getElementById('endDate').value = discount.endDate;

                        document.getElementById('discountId').disabled = true;
                        document.getElementById('isEditing').value = "true";
                        document.getElementById('submitBtn').textContent = "Update Discount";
                    }

                    //update category
                    async function updateDiscount(updateDiscountId, url) {
                        console.log('url::', url);
                        const code = document.getElementById('code').value.trim();
                        const discountPercentage = document.getElementById('discountPercentage').value.trim();
                        const freeDelivery = document.getElementById('freeDelivery').checked;
                        const startDate = document.getElementById('startDate').value;
                        const endDate = document.getElementById('endDate').value;

                        if (updateDiscountId || !code || !discountPercentage || !startDate || !endDate) {
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
                                    code,
                                    discountPercentage,
                                    freeDelivery,
                                    startDate,
                                    endDate
                                })
                            });

                            console.log('payload', JSON.stringify({
                                code,
                                discountPercentage,
                                freeDelivery,
                                startDate,
                                endDate
                            }));
                            //fect backend errors and show them
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to update discount.',
                                    });
                                });
                            }

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Discount updated successfully!',
                            }).then(() => {
                                resetForm();
                                window.location.reload();
                            });
                        } catch (error) {
                            console.error('Error updating discount:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to update discount. Please try again later.',
                            });
                        }
                    }
                    //reset categoryForm data
                    function resetForm() {
                        document.getElementById('discountForm').reset();
                        document.getElementById('discountId').disabled = false;
                        document.getElementById('isEditing').value = "false";
                        document.getElementById('submitBtn').textContent = "Add Discount";
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
                </script>

            </body>

            </html>