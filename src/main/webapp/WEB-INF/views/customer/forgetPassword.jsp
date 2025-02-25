<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!--MAIN BOOTSTRAP LINK-->
<%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
<!--MAIN JQUERY LINK-->
<%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
<!--FOR CATEGORIES DROP DOWN-->
<%@ include file="/WEB-INF/views/inc/categoryDropDown.jsp" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Forgot Password</title>
            <!--Main CSS-->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userLogin.css?v=1.0">
            <!--Footer CSS-->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css?v=1.0">
            <!-- Custom CSS -->
            <style>
                .form-container {
                    max-width: 400px;
                    margin: 80px auto;
                    padding: 30px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
            </style>
        </head>

        <body>
            <!--Navbar-->
            <jsp:include page="/WEB-INF/views/inc/mainHeader.jsp"></jsp:include>
            <!--End of Navbar-->

            <div class="form-container">
                <h2 class="mb-4 text-center">Forgot Password</h2>
                <form action="/auth/forgetPassword" method="post">
                    <div class="form-group">
                        <label for="email">Enter your Email Address:</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com"
                            required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Reset Password</button>
                </form>
                <div class="mt-3 text-center">
                    <a href="/userLogin">Back to Login</a>
                </div>
            </div>

            <!-- ======= Footer ======= -->
            <jsp:include page="/WEB-INF/views/inc/userHomeFooter.jsp"></jsp:include>
            <!-- End Footer -->

            <!-- SweetAlert Library -->
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            
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