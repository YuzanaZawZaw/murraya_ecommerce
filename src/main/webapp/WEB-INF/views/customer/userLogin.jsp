<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>User Sign In</title>
        <!--Logo-->
        <link rel="shortcut icon" type="image/jpg" href="${pageContext.request.contextPath}/images/murraya_logo.jpg">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
            integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

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

        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
    </body>


    </html>