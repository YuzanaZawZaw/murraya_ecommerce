<!--MAIN BOOTSTRAP LINK-->
<%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management</title>
    <!--Main CSS-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productManagement.css?v=1.0">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Sidebar Header -->
        <div class="sidebar-header">
            <h3>Product Management</h3>
        </div>
        <!--side bar menu-->

    <!-- Main Content -->
    <div class="main-content">
        <h1>Welcome to Product Management</h1>
        <p>This is the main content area. You can manage your products here.</p>
    </div>

    <!-- Bootstrap JS and Dependencies -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>