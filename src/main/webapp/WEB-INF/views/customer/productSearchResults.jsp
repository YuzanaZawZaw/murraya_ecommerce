<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
    <!-- Bootstrap CSS (you can link a local copy if preferred) -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" 
          integrity="sha384-M3bRHdOXo8/4xP6rZ0S9r7P9yjk1Q+9Nq1kS/xNdKT0B+CE+Lj0o93H0/zB8y0TH" 
          crossorigin="anonymous">
</head>
<body>
<div class="container mt-4">
    <h2>Search Results for "<c:out value="${keyword}" />"</h2>
    <c:if test="${products == null || products.isEmpty()}">
        <p class="text-muted">No products found.</p>
    </c:if>
    <div class="row">
        <c:forEach var="product" items="${products}">
            <div class="col-md-4 mb-4">
                <div class="card">
                    <!-- Assuming product has an imageUrl field -->
                    <img src="${product.imageUrl}" class="card-img-top" alt="Product Image">
                    <div class="card-body">
                        <h5 class="card-title"><c:out value="${product.name}" /></h5>
                        <p class="card-text"><c:out value="${product.description}" /></p>
                        <p class="font-weight-bold">$<c:out value="${product.price}" /></p>
                        <a href="${pageContext.request.contextPath}/products/${product.productId}" class="btn btn-primary">View Product</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js" 
        integrity="sha384-KyZXEAg3QhqLMpG8r+8jhAXg0fJv5W4M8A8rPjL2VQfTzx3tXrN4w29Y7Ic8eInP" 
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js" 
        integrity="sha384-LtrjvnR4/JqsjfhvpyjRmm/Ka2ocYX13laFfI4+S8qJbCtwYroC7wS+Wb9P5fF6f" 
        crossorigin="anonymous"></script>
</body>
</html>
