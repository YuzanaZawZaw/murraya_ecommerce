<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!--NESTED DROPWON LINK-->
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
                        <a href="/users/userHome" class="nav-link">
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
                        <!-- <a href="#" class="nav-link">
                        Products
                    </a> -->
                        <form class="d-flex" action="/products/search" method="get">
                            <input class="form-control me-2" type="search" name="keyword"
                                placeholder="Search products..." aria-label="Search">
                            <button class="btn btn-outline-secondary" type="submit">Search</button>
                        </form>
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

    <!--FOR CATEGORIES DROP DOWN-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // This script toggles nested dropdowns on click.
        document.querySelectorAll('.dropdown-submenu .dropdown-toggle').forEach(function (element) {
            element.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                let subMenu = element.nextElementSibling;
                if (subMenu) {
                    // Close all other open submenus
                    document.querySelectorAll('.dropdown-submenu .dropdown-menu.show').forEach(function (openMenu) {
                        if (openMenu !== subMenu) {
                            openMenu.classList.remove('show');
                        }
                    });
                    // Toggle the current submenu
                    subMenu.classList.toggle('show');
                }
            });
        });
    </script>

    <script>
        // Close all dropdowns when clicking outside
        document.addEventListener('click', function (e) {
            if (!e.target.matches('.dropdown-submenu .dropdown-toggle')) {
                document.querySelectorAll('.dropdown-submenu .dropdown-menu.show').forEach(function (openMenu) {
                    openMenu.classList.remove('show');
                });
            }
        });
    </script>
    <!--End of Navbar-->