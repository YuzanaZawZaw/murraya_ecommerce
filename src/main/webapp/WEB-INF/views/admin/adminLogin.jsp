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
                <title>Admin Login</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminLogin.css?v=1.0">
            </head>

            <body>
                <div class="login-container">
                    <!-- Icon -->
                    <div class="icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h2>Admin Login</h2>
                    <!-- Login Form -->
                    <form action="/adminAuth/adminLogin" method="post">
                        <div class="form-group">
                            <label for="userName">Username</label>
                            <input type="text" id="userName" name="userName" placeholder="Enter your username"
                                required />
                        </div>
                        <div class="form-group">
                            <label for="passwordHash">Password</label>
                            <input type="password" id="passwordHash" name="passwordHash"
                                placeholder="Enter your password" required />
                        </div>
                        <button type="submit" class="btn-login">Login</button>
                    </form>

                   
                    <a href="/adminAuth/adminForgetPasswordForm" class="forgot-password">Forgot Password?</a>
                </div>

                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <!-- Display Success or Error Messages -->
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