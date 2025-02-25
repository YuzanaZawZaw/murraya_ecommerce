<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!--MAIN BOOTSTRAP LINK-->
<%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
<!--MAIN JQUERY LINK-->
<%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
<!--FOR CATEGORIES DROP DOWN-->
<%@ include file="/WEB-INF/views/inc/categoryDropDown.jsp" %>
    <html>

    <head>
        <title>User Sign In</title>
      
        <!--Main CSS-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userLogin.css?v=1.0">

        <!--Footer CSS-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css?v=1.0">

    </head>

    <body>
        <!--Navbar-->
        <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
        <!--End of Navbar-->

        <div class="main-content">
            <div class="form-container">
                <h2>Sign In</h2>
                <form action="/auth/login" method="post">
                    <label for="userName">Username:</label>
                    <input type="text" id="userName" name="userName" required />
                    <br />
                    <label for="passwordHash">Password:</label>
                    <input type="password" id="passwordHash" name="passwordHash" required />
                    <br />
                    <button type="submit">Login</button>
                </form>
                <a href="/users/userSignUp">Don't have an account? <br /> Sign Up</a>
                <a href="/forgetPasswordForm">Forget Password?</a>
            </div>
        </div>


        <!-- ======= Footer ======= -->
        <jsp:include page="/WEB-INF/views/inc/userHomeFooter.jsp"></jsp:include>
        <!-- End Footer -->

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