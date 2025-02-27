<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!--MAIN BOOTSTRAP LINK-->
<%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
<!--MAIN JQUERY LINK-->
<%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
    <html>

    <head>
        <title>Admin Sign In</title>
      
        <!--Main CSS-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userLogin.css?v=1.0">

    </head>

    <body>
        <!--Navbar-->
        <jsp:include page="/WEB-INF/views/inc/adminLoginHeader.jsp"></jsp:include>
        <!--End of Navbar-->

        <div class="main-content">
            <div class="form-container">
                <h2>Sign In</h2>
                <form action="/admin/adminLogin" method="post">
                    <label for="userName">Username:</label>
                    <input type="text" id="userName" name="userName" required />
                    <br />
                    <label for="passwordHash">Password:</label>
                    <input type="password" id="passwordHash" name="passwordHash" required />
                    <br />
                    <button type="submit">Login</button>
                </form>
                <a href="/admin/adminForgetPasswordForm">Forget Password?</a>
            </div>
        </div>


        <!-- SweetAlert Library -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <c:if test="${not empty success}">
            <script>
                const successMessage = "${success}";
                if (successMessage) {
                    Swal.fire({
                        title: "Success!",
                        text: "${success}",
                        icon: "success",
                        confirmButtonText: "OK"
                    });
                }
            </script>
        </c:if>

        <c:if test="${not empty error}">
            <script>
                const errorMessage = "${error}";
                if (errorMessage) {
                    Swal.fire({
                        title: "Error!",
                        text: "${error}",
                        icon: "error",
                        confirmButtonText: "Try Again"
                    });
                }
            </script>
        </c:if>

    </body>

    </html>