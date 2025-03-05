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
                                <div class="card">
                                    <h2>Total Sales</h2>
                                    <p>$<span>${totalSales}</span></p>
                                </div>
                            </div>
                            <!-- Total Orders Card -->
                            <div class="col-md-4">
                                <div class="card">
                                    <h2>Total Orders</h2>
                                    <p>${totalOrders}</p>
                                </div>
                            </div>
                            <!-- Total Customers Card -->
                            <div class="col-md-4">
                                <div class="card">
                                    <h2>Total Customers</h2>
                                    <p>${totalCustomers}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS and Dependencies -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const token = localStorage.getItem('token');
                    if (token) {
                        console.log("token found::",token);
                    } else {
                        console.error('No token found in localStorage');
                    }
                </script>
            </body>

            </html>