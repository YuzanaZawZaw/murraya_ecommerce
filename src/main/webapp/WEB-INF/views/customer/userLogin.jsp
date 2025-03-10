<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--MAIN BOOTSTRAP LINK-->
    <%@ include file="/WEB-INF/views/inc/bootstrap.jsp" %>
        <!--MAIN JQUERY LINK-->
        <%@ include file="/WEB-INF/views/inc/jquery.jsp" %>
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
                        <form id="userLoginForm" method="post">
                            <label for="userName">Username:</label>
                            <input type="text" id="userName" name="userName" required />
                            <br />
                            <label for="passwordHash">Password:</label>
                            <input type="password" id="passwordHash" name="passwordHash" required />
                            <br />
                            <button type="submit">Login</button>
                        </form>
                        <a href="/users/userSignUpForm">Don't have an account? <br /> Sign Up</a>
                        <a href="/users/forgetPasswordForm">Forget Password?</a>
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

                <script>
                    $('#userLoginForm').on('submit', function (event) {
                        console.log("Loading user");
                        event.preventDefault();
                        userLogin();
                    });
                    async function userLogin() {
                        const userName = document.getElementById('userName').value;
                        const passwordHash = document.getElementById('passwordHash').value;
                        try {
                            const response = await fetch('http://localhost:8080/userAuth/login', {
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

                            localStorage.setItem('token', token);

                            // Redirect to the admin dashboard
                            window.location.href = 'http://localhost:8080/users/userHomeModuleForm';

                        } catch (error) {
                            console.error('Login failed:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message, 
                            });
                        }
                    }
                </script>

            </body>

            </html>