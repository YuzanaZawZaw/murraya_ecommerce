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
                    <form id="adminLoginForm" method="post">
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
                <script>
                    $('#adminLoginForm').on('submit', function (event) {
                        console.log("Loading user");
                        event.preventDefault();
                        adminLogin();
                    });

                    async function adminLogin() {
                        const userName = document.getElementById('userName').value;
                        const passwordHash = document.getElementById('passwordHash').value;
                        console.log('username::::')
                        try {
                            const response = await fetch('http://localhost:8080/adminAuth/adminLogin', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: new URLSearchParams({
                                    userName,
                                    passwordHash
                                })
                            });

                            if (!response.ok) {
                                const errorData = await response.text();
                                throw new Error(errorData);
                            }

                            const data = await response.json();
                            const token = data.token;

                            // Store the token in localStorage or sessionStorage
                            localStorage.setItem('token', token);

                            // Redirect to the admin dashboard
                            window.location.href = 'http://localhost:8080/adminAuth/adminDashboard';
                        } catch (error) {
                            console.error('Login failed:', error);
                            Swal.fire({
                                title: "Error!",
                                text: "${error.message}",
                                icon: "error",
                                confirmButtonText: "Try Again"
                            });
                        }
                    }
                </script>

            </body>

            </html>