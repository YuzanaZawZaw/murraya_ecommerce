<!-- <%@ page session="true" %>
<html>
<head>
    //Other head content 
    <script type="text/javascript">
        // Retrieve the token from session and expose it to JavaScript.
        // If there's no token, serverToken will be null or empty.
        var serverToken = "<c:out value='${sessionScope.token}'/>";
        console.log("${sessionScope.token}");
    </script>
    <script src="${pageContext.request.contextPath}/js/tokenHandler.js"></script>
</head> -->
<body>
    <!-- ======= Footer ======= -->
<footer id="footer">

    <div class="footer-top">

        <div class="container">

            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <h3>Murraya Online Shopping</h3>
                    <p class="d-flex align-items-center gap-2">
                        <i class="bi bi-house fs-4"></i> <span>No23, Kyaung Kone 1 street, Hlaing Tsp,
                            Myanmar</span>
                    </p>
                    <p class="d-flex align-items-center gap-2">
                        <i class="bi bi-telephone fs-4"></i> <span>+95 9 989 081631</span>
                    </p>
                </div>
            </div>

            <div class="row footer-newsletter justify-content-center">
                <div class="col-lg-6">
                    <form action="/users/subscribe" method="POST">
                        <input type="email" name="email" placeholder="Enter your Email" required>
                        <input type="submit" value="Subscribe">
                    </form>                    
                </div>
            </div>

            <div class="social-links">
                <a href="https://www.facebook.com/murrayafashionshop" class="facebook">
                    <i class="bi bi-facebook"></i></a>
                <a href="https://www.tiktok.com/@murrayafashionshop" class="tiktok">
                    <i class="fa-brands fa-tiktok"></i></a>
            </div>

        </div>
    </div>

</footer>
<!-- End Footer -->

</body>
</html>


