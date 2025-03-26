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
                <title>Order management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerManagement.css?v=1.0">
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
                <div class="main-content">
                    <div class="container mt-5">
                        <h2 class="mb-4 text-center">Order Management</h2>

                        <!-- Pending Orders Table -->
                        <div class="table-container mt-3">
                            <h3 class="mb-4 text-center">Pending Orders</h3>
                            <table id="pendingOrdersTable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="pendingOrdersTableBody">
                                    <c:forEach var="row" items="${pendingOrders}">
                                        <tr>
                                            <td>
                                                <a href="#" class="order-id-link" data-order-id="${row.orderId}">
                                                    ${row.orderId}
                                                </a>
                                            </td>
                                            <td>${row.customerName}</td>
                                            <td>${row.totalAmount}</td>
                                            <td>${row.status}</td>
                                            <td>${row.createdAt}</td>
                                            <td>
                                                <button class="btn btn-success btn-sm confirm-order-button"
                                                    data-order-id="${row.orderId}">
                                                    Confirm
                                                </button>
                                                <button class="btn btn-danger btn-sm cancelled-order-button"
                                                    data-order-id="${row.orderId}">
                                                    Cancelled
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Cancelled Orders Table -->
                        <div class="table-container mt-3">
                            <h3 class="mb-4 text-center">Cancelled Orders</h3>
                            <table id="cancelledOrdersTable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="cancelledOrdersTableBody">
                                    <c:forEach var="row" items="${cancelledOrders}">
                                        <tr>
                                            <td>
                                                <a href="#" class="order-id-link" data-order-id="${row.orderId}">
                                                    ${row.orderId}
                                                </a>
                                            </td>
                                            <td>${row.customerName}</td>
                                            <td>${row.totalAmount}</td>
                                            <td>${row.status}</td>
                                            <td>${row.createdAt}</td>
                                            <td>
                                                <button class="btn btn-outline-warning btn-sm pending-order-button"
                                                    data-order-id="${row.orderId}">
                                                    Add to pending
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Confirmed Orders Table -->
                        <div class="table-container mt-3">
                            <h3 class="mb-4 text-center">Confirmed Orders</h3>
                            <table id="confirmedOrdersTable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="confirmedOrdersTableBody">
                                    <c:forEach var="row" items="${confirmedOrders}">
                                        <tr>
                                            <td>
                                                <a href="#" class="order-id-link" data-order-id="${row.orderId}">
                                                    ${row.orderId}
                                                </a>
                                            </td>
                                            <td>${row.customerName}</td>
                                            <td>${row.totalAmount}</td>
                                            <td>${row.status}</td>
                                            <td>${row.createdAt}</td>
                                            <td>
                                                <!-- <button class="btn btn-secondary btn-sm" disabled>Completed</button> -->
                                                <button class="btn btn-success btn-sm prodessing-order-button"
                                                    data-order-id="${row.orderId}">
                                                    Processing
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Processing Orders Table -->
                        <div class="table-container mt-3">
                            <h3 class="mb-4 text-center">Processing Orders</h3>
                            <table id="processingOrdersTable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="processingOrdersTableBody">
                                    <c:forEach var="row" items="${processingOrders}">
                                        <tr>
                                            <td>
                                                <a href="#" class="order-id-link" data-order-id="${row.orderId}">
                                                    ${row.orderId}
                                                </a>
                                            </td>
                                            <td>${row.customerName}</td>
                                            <td>${row.totalAmount}</td>
                                            <td>${row.status}</td>
                                            <td>${row.createdAt}</td>
                                            <td>
                                                <button class="btn btn-success btn-sm shipped-order-button"
                                                    data-order-id="${row.orderId}">
                                                    Shipped
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Shipped Orders Table -->
                        <div class="table-container mt-3">
                            <h3 class="mb-4 text-center">Shipped Orders</h3>
                            <table id="shippedOrdersTable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="shippedOrdersTableBody">
                                    <c:forEach var="row" items="${shippedOrders}">
                                        <tr>
                                            <td>
                                                <a href="#" class="order-id-link" data-order-id="${row.orderId}">
                                                    ${row.orderId}
                                                </a>
                                            </td>
                                            <td>${row.customerName}</td>
                                            <td>${row.totalAmount}</td>
                                            <td>${row.status}</td>
                                            <td>${row.createdAt}</td>
                                            <td>
                                                <!-- <button class="btn btn-secondary btn-sm" disabled>Completed</button> -->
                                                <button class="btn btn-success btn-sm delivered-order-button"
                                                    data-order-id="${row.orderId}">
                                                    Delivered
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Delivered Orders Table -->
                        <div class="table-container mt-3">
                            <h3 class="mb-4 text-center">Delivered Orders</h3>
                            <table id="deliveredOrdersTable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="deliveredOrdersTableBody">
                                    <c:forEach var="row" items="${deliveredOrders}">
                                        <tr>
                                            <td>
                                                <a href="#" class="order-id-link" data-order-id="${row.orderId}">
                                                    ${row.orderId}
                                                </a>
                                            </td>
                                            <td>${row.customerName}</td>
                                            <td>${row.totalAmount}</td>
                                            <td>${row.status}</td>
                                            <td>${row.createdAt}</td>
                                            <td>
                                                <button class="btn btn-secondary btn-sm" disabled>Completed</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <!-- Order Details Modal -->
                <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div id="orderDetailsContainer">
                                    <!-- Order details will be dynamically added here -->
                                </div>
                            </div>
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
                    function initializeDataTable(tableId) {
                        var table = $(`#` + tableId).DataTable({
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
                                const api = this.api();
                                const dataSrc = [];

                                api.cells('tr', [0, 1, 2, 3, 4, 5]).every(function () {
                                    const data = $('<div>').html(this.data()).text();
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
                    }

                    document.addEventListener("DOMContentLoaded", function () {
                        const orderDetailsModal = new bootstrap.Modal(document.getElementById("orderDetailsModal"));
                        const orderDetailsContainer = document.getElementById("orderDetailsContainer");
                        // Initialize all tables
                        initializeDataTable("pendingOrdersTable");
                        initializeDataTable("cancelledOrdersTable");
                        initializeDataTable("confirmedOrdersTable");
                        initializeDataTable("processingOrdersTable");
                        initializeDataTable("shippedOrdersTable");
                        initializeDataTable("deliveredOrdersTable");

                        // Add event listeners for table actions
                        const pendingOrdersTableBody = document.getElementById("pendingOrdersTableBody");
                        pendingOrdersTableBody.addEventListener("click", handlePendingOrderActions);

                        const confirmedOrdersTableBody = document.getElementById("confirmedOrdersTableBody");
                        confirmedOrdersTableBody.addEventListener("click", handleConfirmedOrderActions);

                        const cancelledOrdersTableBody = document.getElementById("cancelledOrdersTableBody");
                        cancelledOrdersTableBody.addEventListener("click", handleCancelledOrderActions);

                        const processingOrdersTableBody = document.getElementById("processingOrdersTableBody");
                        processingOrdersTableBody.addEventListener("click", handleProcessingOrderActions);

                        const shippedOrdersTableBody = document.getElementById("shippedOrdersTableBody");
                        shippedOrdersTableBody.addEventListener("click", handleShippedOrderActions);


                        document.addEventListener("click", async function (event) {
                            if (event.target.classList.contains("order-id-link")) {
                                event.preventDefault();
                                const orderId = event.target.getAttribute("data-order-id");

                                try {
                                    const response = await fetch(`/admin/orders/` + orderId, {
                                        method: "GET",
                                        headers: {
                                            "Content-Type": "application/json"
                                        }
                                    });

                                    if (!response.ok) {
                                        throw new Error("Failed to fetch order details");
                                    }

                                    const orderDetails = await response.json();

                                    // Populate the modal with order details

                                    orderDetailsContainer.innerHTML = `
                                            <div class="card shadow-sm">
                                                <div class="card-header bg-secondary text-white">
                                                    <h5>Order Details</h5>
                                                </div>
                                                <div class="card-body">
                                                    <p><strong>Order ID:</strong> `+ orderDetails.orderId + `</p>
                                                    <p><strong>Customer Name:</strong> `+ orderDetails.customerName + `</p>
                                                    <h5>Shipping Address:</h5>
                                                    <p>`+orderDetails.shippingAddressDTO.addressLine1+`, `+ 
                                                        orderDetails.shippingAddressDTO.addressLine2+`, `+ 
                                                        orderDetails.shippingAddressDTO.city+`, `+ 
                                                        orderDetails.shippingAddressDTO.state +` - `+
                                                        orderDetails.shippingAddressDTO.zipCode+`, `+
                                                        orderDetails.shippingAddressDTO.country+ 
                                                    `</p>
                                                    <p><strong>Phone:</strong> `+orderDetails.shippingAddressDTO.phoneNumber+ `</p>
                                                    <p><strong>Status:</strong> `+ orderDetails.status + `</p>
                                                    <p><strong>Ordered on:</strong>`+ formatDate(orderDetails.createdAt) + `</p>
                                                    <p><strong>Estimated delivery date:</strong>`+ formatDate(orderDetails.estimatedDeliveryDate) + `</p>
                                                    <h5>Order Items:</h5>`+
                                                    `<ul class="list-group">` +
                                                        orderDetails.orderItems.map(item => `
                                                            <li class="list-group-item d-flex justify-content-between align-items-center">`+
                                                        item.productName +
                                                        `<span>` +
                                                        item.quantity + ' x ' + item.price +
                                                        ` MMK</span>
                                                            </li>
                                                        `).join("") + `
                                                    </ul>
                                                    <p class="mt-3 text-end"><strong>Tax:</strong>`+ orderDetails.tax.toFixed(2) + ` MMK </p >
                                                    <p class="text-end"><strong>Total Amount:</strong>`+ orderDetails.totalAmount + ` MMK </p>
                                                </div >
                                            </div >
                                        `;
                                    // Show the modal
                                    orderDetailsModal.show();
                                } catch (error) {
                                    console.error("Error fetching order details:", error);
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error',
                                        text: 'Failed to load order details. Please try again later.',
                                        timer: 2000,
                                        showConfirmButton: false
                                    });
                                }
                            };
                        });

                    });

                    async function handlePendingOrderActions(event) {
                        if (event.target.classList.contains("confirm-order-button")) {
                            const orderId = event.target.getAttribute("data-order-id");

                            // Confirm the order
                            try {
                                const confirmResponse = await fetch(`/ admin / orders / ` + orderId + ` / confirm`, {
                                    method: "PUT",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                });

                                if (!confirmResponse.ok) {
                                    return confirmResponse.json().then(err => {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Error!',
                                            text: err.error || 'Failed to confirm order',
                                        });
                                    });
                                    return confirmResponse.text();
                                }

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order Confirmed',
                                    text: `Order ` + orderId + `has been confirmed.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                setTimeout(() => {
                                    window.location.reload();
                                }, 2000);
                            } catch (error) {
                                console.error("Error confirming order:", error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Failed to confirm the order. Please try again later.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        }

                        if (event.target.classList.contains("cancelled-order-button")) {
                            const orderId = event.target.getAttribute("data-order-id");

                            // Cancelled the order
                            try {
                                const confirmResponse = await fetch(`/ admin / orders / ` + orderId + ` / cancelled`, {
                                    method: "PUT",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                });

                                if (!confirmResponse.ok) {
                                    throw new Error("Failed to cancelled order");
                                }

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order cancelled',
                                    text: `Order ` + orderId + `has been cancelled.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                setTimeout(() => {
                                    window.location.reload();
                                }, 2000);
                            } catch (error) {
                                console.error("Error Cancelled order:", error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Failed to Cancelled the order. Please try again later.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        }
                    }

                    async function handleConfirmedOrderActions(event) {
                        if (event.target.classList.contains("prodessing-order-button")) {
                            const orderId = event.target.getAttribute("data-order-id");

                            // processing the order
                            try {
                                const processingResponse = await fetch(`/ admin / orders / ` + orderId + ` / processing`, {
                                    method: "PUT",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                });

                                if (!processingResponse.ok) {
                                    throw new Error("Failed to processing order");
                                }

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order processing',
                                    text: `Order ` + orderId + `has been processing.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                setTimeout(() => {
                                    window.location.reload();
                                }, 2000);
                            } catch (error) {
                                console.error("Error Processing order:", error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Failed to Processing the order. Please try again later.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        }
                    }

                    async function handleCancelledOrderActions(event) {
                        if (event.target.classList.contains("pending-order-button")) {
                            const orderId = event.target.getAttribute("data-order-id");

                            // Confirm the order
                            try {
                                const processingResponse = await fetch(`/ admin / orders / ` + orderId + ` / pending`, {
                                    method: "PUT",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                });

                                if (!processingResponse.ok) {
                                    throw new Error("Failed to pending order");
                                }

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order pending',
                                    text: `Order ` + orderId + `has been pending.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                setTimeout(() => {
                                    window.location.reload();
                                }, 2000);
                            } catch (error) {
                                console.error("Error pending order:", error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Failed to pending the order. Please try again later.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        }
                    }

                    async function handleProcessingOrderActions(event) {
                        if (event.target.classList.contains("shipped-order-button")) {
                            const orderId = event.target.getAttribute("data-order-id");

                            // Shipped the order

                            try {
                                const processingResponse = await fetch(`/ admin / orders / ` + orderId + ` / shipped`, {
                                    method: "PUT",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                });

                                if (!processingResponse.ok) {
                                    throw new Error("Failed to shipped order");
                                }

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order shipped',
                                    text: `Order ` + orderId + `has been shipped.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                setTimeout(() => {
                                    window.location.reload();
                                }, 2000);
                            } catch (error) {
                                console.error("Error Shipped order:", error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Failed to Shipped the order. Please try again later.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        }
                    }

                    async function handleShippedOrderActions(event) {
                        if (event.target.classList.contains("delivered-order-button")) {
                            const orderId = event.target.getAttribute("data-order-id");

                            // Confirm the order
                            try {
                                const processingResponse = await fetch(`/ admin / orders / ` + orderId + ` / delivered`, {
                                    method: "PUT",
                                    headers: {
                                        "Content-Type": "application/json"
                                    }
                                });

                                if (!processingResponse.ok) {
                                    throw new Error("Failed to delivered order");
                                }

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order delivered',
                                    text: `Order ` + orderId + `has been delivered.`,
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                setTimeout(() => {
                                    window.location.reload();
                                }, 2000);
                            } catch (error) {
                                console.error("Error delivered order:", error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: 'Failed to delivered the order. Please try again later.',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        }
                    }

                    function formatDate(date) {
                        console.log(date);
                        if (Array.isArray(date)) {
                            // Convert the array to a Date object
                            const [year, month, day, hour, minute, second, nanosecond] = date;
                            date = new Date(year, month - 1, day, hour, minute, second, Math.floor(nanosecond / 1e6));
                        } else {
                            date = new Date(date);
                        }
                        return isNaN(date.getTime()) ? "Invalid Date" : date.toLocaleDateString("en-US", {
                            year: "numeric",
                            month: "long",
                            day: "numeric"
                        });
                    }
                    //adjusting with sidebar
                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.table-container');
                        const sidebar = document.getElementById('sidebar');

                        if (tableContainer && sidebar) {
                            const tableHeight = tableContainer.offsetHeight;
                            const mainContentHeight = document.querySelector('.main-content').offsetHeight;
                            sidebar.style.height = `${mainContentHeight} px`;
                        }
                    }

                </script>

            </body>

            </html>