<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Forgot Password</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminLogin.css?v=1.0">
            </head>

            <body>
                <div class="login-container">
                    <!-- Icon -->
                    <div class="icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h2 class="mb-4 text-center">Reset Password</h2>
                    <form action="/adminAuth/resetPassword" method="post">
                        <div class="form-group">
                            <label for="email">Your Email Address:</label>
                            <input type="email" id="email" name="email" class="form-control" value="${email}" required>
                            <label for="passwordHash">New Password:</label>
                            <input type="password" id="passwordHash" name="passwordHash" required />
                        </div>
                        <button type="submit" class="btn-login">Reset Password</button>
                    </form>
                    <div class="mt-3 text-center">
                        <a href="/adminAuth/adminLoginForm" class="forgot-password">Back to Login</a>
                    </div>
                </div>

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