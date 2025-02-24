<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!--Navbar-->
<nav class="navbar navbar-expand-lg sticky-top" id="main-navbar">

    <div class="container">
        <a class="navbar-brand font-weight-bold brand-color" href="#">
            Murraya
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#main-nav"
            aria-controls="main-nav" aria-expanded="false" aria-label="toggle navigation" class="nav-link">
            <span>Menu</span>
        </button>
        <div class="collapse navbar-collapse" id="main-nav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a href="/userHome" class="nav-link">
                        Home
                    </a>
                </li>
                <!-- Categories Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="categoriesDropdown" role="button"
                        data-bs-toggle="dropdown" aria-expanded="false">
                        Categories
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="categoriesDropdown">
                        <c:forEach var="entry" items="${categories}">
                            <c:set var="parent" value="${entry.key}" />
                            <c:set var="children" value="${entry.value}" />
                            <!-- Parent category item -->
                            <li class="dropdown-submenu">
                                <a class="dropdown-item dropdown-toggle" href="#">${parent.name}</a>
                                <ul class="dropdown-menu">
                                    <c:forEach var="child" items="${children}">
                                        <li>
                                            <a class="dropdown-item" href="#">${child.name}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:forEach>
                    </ul>
                </li>
                
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        Products
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        Services
                    </a>
                </li>

                <li class="d-none d-xl-block">

                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="bi-heart"></i>
                    </a>
                </li>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="bi-cart"></i>
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>



<!--End of Navbar-->