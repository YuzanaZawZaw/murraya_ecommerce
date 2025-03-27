<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Order History</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=1.0">
            </head>

            <body>
                <!-- Navbar -->
                <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
                <!-- End Navbar -->

                <div class="container mt-5">
                    <h2 class="text-center mb-4">Order History</h2>
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
                        const userToken = localStorage.getItem("userToken");
                        const completedOrdersContainer = document.getElementById("completed-orders-container");
                        const pendingOrdersContainer = document.getElementById("pending-orders-container");

                        if (!userToken) {
                            Swal.fire({
                                icon: "error",
                                title: "Unauthorized",
                                text: "Please log in to view your order history.",
                                timer: 2000,
                                showConfirmButton: false
                            }).then(() => {
                                window.location.href = "/users/userHome";
                            });
                            return;
                        }

                        try {
                            const response = await fetch("/users/orders/orderHistory", {
                                method: "GET",
                                headers: {
                                    "Authorization": `Bearer ` + userToken
                                }
                            });

                            if (!response.ok) {
                                throw new Error("Failed to fetch order history");
                            }

                            const orderHistory = await response.json();
                            if (orderHistory.length === 0) {
                                const emptyMessage = document.createElement("div");
                                emptyMessage.classList.add("text-center", "mt-5");
                                emptyMessage.innerHTML = `
                                        <h4>No orders found</h4>
                                        <p>Start shopping and place your first order!</p>`;
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
                            console.error("Error fetching order history:", error);
                            Swal.fire({
                                icon: "error",
                                title: "Error",
                                text: "Failed to load order history. Please try again later.",
                                timer: 2000,
                                showConfirmButton: false
                            });
                        }

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

                            const totalAmount = document.createElement("h6");
                            totalAmount.textContent = `Total Amount: MMK ` + order.totalAmount.toFixed(2);
                            cardBody.appendChild(totalAmount);

                            const tax = document.createElement("h6");
                            tax.textContent = `Tax: MMK ` + order.tax.toFixed(2);
                            cardBody.appendChild(tax);

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
                    });
                </script>
            </body>

            </html>