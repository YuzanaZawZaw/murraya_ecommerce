<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Admin Dashboard</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminDashboard.css?v=1.0">
                <!--TOKEN HANDLER-->
                <script src="${pageContext.request.contextPath}/js/tokenHandler.js"></script>
            </head>

            <body>
                <!-- Sidebar -->
                <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                <!--End Sidebar-->

                <!-- Main Content -->
                <div class="main-content">
                    <div class="container">
                        <h1 class="text-center my-4">Admin Dashboard</h1>
                        <div class="row">
                            <!-- Total Sales Card -->
                            <div class="col-md-4">
                                <div class="main-card">
                                    <h2>Total Sales</h2>
                                    <p><span>${totalSales}</span></p>
                                </div>
                            </div>
                            <!-- Total Orders Card -->
                            <div class="col-md-4">
                                <div class="main-card">
                                    <h2>Total Orders</h2>
                                    <p>${totalOrders}</p>
                                </div>
                            </div>
                            <!-- Total Customers Card -->
                            <div class="col-md-4">
                                <div class="main-card">
                                    <h2>Total Customers</h2>
                                    <p>${totalCustomers}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="filter-container mt-4">
                        <h3 class="text-center">Filter Orders by Date</h3>
                        <form id="dateFilterForm" class="row g-3 justify-content-center">
                            <div class="col-md-4">
                                <label for="fromDate" class="form-label">From Date</label>
                                <input type="date" id="fromDate" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label for="toDate" class="form-label">To Date</label>
                                <input type="date" id="toDate" class="form-control" required>
                            </div>
                            <div class="col-md-2 align-self-end">
                                <button type="button" id="filterOrdersButton" class="btn-filter">Filter
                                    Orders</button>
                            </div>
                        </form>
                    </div>
                    <div class="order-container mt-5">
                        <h2 class="text-center mb-4">Order History</h2>
                        <div class="panel-container">
                            <div class="row">
                                <!-- Completed Orders Panel -->
                                <div class="col-md-6">
                                    <h3 class="text-center">Completed Orders</h3>
                                    <div id="completed-orders-container" class="row">
                                        <!-- Completed orders will be dynamically loaded here -->
                                    </div>
                                </div>
                                <!-- Pending Orders Panel -->
                                <div class="col-md-6">
                                    <h3 class="text-center">Pending Orders</h3>
                                    <div id="pending-orders-container" class="row">
                                        <!-- Pending orders will be dynamically loaded here -->
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
                </div>

                <!-- Bootstrap JS and Dependencies -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const filterOrdersButton = document.getElementById("filterOrdersButton");
                        const completedOrdersContainer = document.getElementById("completed-orders-container");
                        const pendingOrdersContainer = document.getElementById("pending-orders-container");

                        filterOrdersButton.addEventListener("click", async function () {
                            const fromDate = document.getElementById("fromDate").value;
                            const toDate = document.getElementById("toDate").value;
                            const adminToken = localStorage.getItem("adminToken");

                            if (!fromDate || !toDate) {
                                Swal.fire({
                                    icon: "warning",
                                    title: "Invalid Input",
                                    text: "Please select both From Date and To Date.",
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                return;
                            }

                            if (!adminToken) {
                                Swal.fire({
                                    icon: "error",
                                    title: "Unauthorized",
                                    text: "Please log in to filter your order history.",
                                    timer: 2000,
                                    showConfirmButton: false
                                }).then(() => {
                                    window.location.href = "/adminAuth/adminLoginForm";
                                });
                                return;
                            }

                            try {
                                const response = await fetch(`/admin/orders/orderHistoryByDate?fromDate=` + fromDate + `&toDate=` + toDate, {
                                    method: "GET",
                                    headers: {
                                        "Authorization": `Bearer ` + adminToken
                                    }
                                });

                                if (!response.ok) {
                                    throw new Error("Failed to fetch filtered orders");
                                }

                                const orderHistory = await response.json();

                                // Clear existing orders
                                completedOrdersContainer.innerHTML = "";
                                pendingOrdersContainer.innerHTML = "";

                                if (orderHistory.length === 0) {
                                    const emptyMessage = document.createElement("div");
                                    emptyMessage.classList.add("text-center", "mt-5");
                                    emptyMessage.innerHTML = `
                                        <h4>No orders found</h4>
                                        <p>No orders were placed in the selected date range.</p>`
                                    completedOrdersContainer.appendChild(emptyMessage);
                                    pendingOrdersContainer.appendChild(emptyMessage.cloneNode(true));
                                    return;
                                }

                                orderHistory.forEach(order => {
                                    const orderCard = createOrderCard(order);

                                    if (order.status === "Delivered") {
                                        completedOrdersContainer.appendChild(orderCard);
                                    } else {
                                        pendingOrdersContainer.appendChild(orderCard);
                                    }
                                });
                            } catch (error) {
                                console.error("Error fetching filtered orders:", error);
                                Swal.fire({
                                    icon: "error",
                                    title: "Error",
                                    text: "Failed to load filtered orders. Please try again later.",
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            }
                        });
                    });

                    function createOrderCard(order) {
                        const orderCard = document.createElement("div");
                        orderCard.classList.add("col-md-12", "mb-4");

                        const card = document.createElement("div");
                        card.classList.add("card", "shadow-sm");

                        const cardHeader = document.createElement("div");
                        cardHeader.classList.add("card-header");

                        const orderId = document.createElement("h5");
                        orderId.textContent = `Order No: ` + order.orderId;
                        cardHeader.appendChild(orderId);

                        const placedOn = document.createElement("p");

                        placedOn.textContent = `Placed on: ` + formatDate(order.createdAt);
                        cardHeader.appendChild(placedOn);

                        const estimatedDelivery = document.createElement("p");

                        estimatedDelivery.textContent = `Estimated Delivery: ` + formatDate(order.estimatedDeliveryDate);
                        cardHeader.appendChild(estimatedDelivery);

                        const status = document.createElement("p");
                        status.innerHTML = `Status: <span class="badge bg-info">` + order.status + `</span>`;
                        cardHeader.appendChild(status);

                        card.appendChild(cardHeader);

                        const cardBody = document.createElement("div");
                        cardBody.classList.add("card-body");

                        const orderItemsHeader = document.createElement("h6");
                        orderItemsHeader.textContent = "Order Items:";
                        cardBody.appendChild(orderItemsHeader);

                        const orderItemsList = document.createElement("ul");
                        orderItemsList.classList.add("list-group", "mb-3");

                        order.orderItems.forEach(item => {
                            const listItem = document.createElement("li");
                            listItem.classList.add("list-group-item", "d-flex", "justify-content-between", "align-items-center");
                            listItem.innerHTML = `
                                        <span>Product Name: `+ item.productName + `</span>` +
                                `<span>Quantity: ` + item.quantity + `</span>` +
                                `<span>Price: MMK ` + item.price.toFixed(2) + `</span>` +
                                `<span>Total: MMK ` + item.totalPrice.toFixed(2) + `</span>`;
                            orderItemsList.appendChild(listItem);
                        });

                        cardBody.appendChild(orderItemsList);

                        const tax = document.createElement("h6");
                        tax.textContent = `Tax: MMK ` + order.tax.toFixed(2);
                        cardBody.appendChild(tax);

                        const totalAmount = document.createElement("h6");
                        totalAmount.textContent = `Total Amount: MMK ` + order.totalAmount.toFixed(2);
                        cardBody.appendChild(totalAmount);

                        card.appendChild(cardBody);
                        orderCard.appendChild(card);

                        return orderCard;
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
                        const tableContainer = document.querySelector('.panel-container');
                        const sidebar = document.getElementById('sidebar');

                        if (tableContainer && sidebar) {
                            const tableHeight = tableContainer.offsetHeight;
                            const mainContentHeight = document.querySelector('.main-content').offsetHeight;
                            sidebar.style.height = mainContentHeight + `px`;
                        }
                    }
                </script>
            </body>

            </html>