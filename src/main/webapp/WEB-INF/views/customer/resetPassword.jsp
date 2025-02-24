<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Forgot Password</title>
            <!--Logo-->
            <link rel="shortcut icon" type="image/jpg"
                href="${pageContext.request.contextPath}/images/murraya_logo.jpg">
            <!-- Bootstrap CSS -->
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                crossorigin="anonymous">

            <link
                href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
            <!--Main CSS-->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userLogin.css?v=1.0">

            <!--Footer CSS-->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css?v=1.0">
            <!-- Custom CSS (optional) -->
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
                <h2 class="mb-4 text-center">Reset Password</h2>
                <!-- Optionally, display flash messages here -->
                <c:if test="${not empty message}">
                    <div class="alert alert-info" role="alert">
                        ${message}
                    </div>
                </c:if>
                <form action="/auth/resetPassword" method="post">
                    <div class="form-group">
                        <label for="email">Your Email Address:</label>
                        <input type="email" id="email" name="email" class="form-control" value="${email}" required>
                        <label for="passwordHash">New Password:</label>
                        <input type="password" id="passwordHash" name="passwordHash" required />
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
            
            <!-- Optional: Bootstrap JS and dependencies -->
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"
                integrity="sha384-KyZXEAg3QhqLMpG8r+8jhAXg0fJv5W4M8A8rPjL2VQfTzx3tXrN4w29Y7Ic8eInP"
                crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-LtrjvnR4/JqsjfhvpyjRmm/Ka2ocYX13laFfI4+S8qJbCtwYroC7wS+Wb9P5fF6f"
                crossorigin="anonymous"></script>
        </body>

        </html>