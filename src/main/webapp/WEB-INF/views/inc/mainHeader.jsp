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
                        <div class="d-flex">
                            <input type="text" id="productSearch" placeholder="Search products..."
                                class="form-control me-2" list="productList">
                            <datalist id="productList"></datalist>
                            <button id="searchButton" class="btn btn-outline-secondary">Search</button>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">
                            Services
                        </a>
                    </li>

                    <li class="d-none d-xl-block">

                        <li class="nav-item">
                            <a href="/wishlist" class="nav-link">
                                <i class="bi bi-heart"></i>
                                <span id="favorite-count">0</span>
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
                    document.querySelectorAll('.dropdown-submenu .dropdown-menu.show').forEach(function (openMenu) {
                        if (openMenu !== subMenu) {
                            openMenu.classList.remove('show');
                        }
                    });
                    subMenu.classList.toggle('show');
                }
            });
        });
    </script>

    <script>
        document.addEventListener('click', function (e) {
            if (!e.target.matches('.dropdown-submenu .dropdown-toggle')) {
                document.querySelectorAll('.dropdown-submenu .dropdown-menu.show').forEach(function (openMenu) {
                    openMenu.classList.remove('show');
                });
            }
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", async function () {
            //updateWishlistUI();
            const productSearch = document.getElementById("productSearch");
            const dataList = document.getElementById("productList");
            const searchButton = document.getElementById('searchButton');

            //click productSearch input
            productSearch.addEventListener("input", async function () {
                const query = productSearch.value.trim();
                if (query.length < 2) return;

                try {
                    const response = await fetch(`/admin/products/productNames?query=` + query);
                    const products = await response.json();
                    //console.log(products);
                    dataList.innerHTML = "";
                    products.forEach(product => {
                        let option = document.createElement("option");
                        option.value = product.productName;
                        //console.log(product.productName);
                        dataList.appendChild(option);
                    });
                } catch (error) {
                    console.error("Error fetching products:", error);
                }
            });

            //click search button
            searchButton.addEventListener('click', async function () {
                productSearchResult();
            })

            async function productSearchResult() {
                const productSearch = document.getElementById('productSearch');
                const searchButton = document.getElementById('searchButton');
                const productContainer = document.getElementById("search-product-container");
                const query = productSearch.value.trim();

                if (!query) {
                    Swal.fire('Warning', 'Please enter a search term.', 'warning');
                    return;
                }
                try {
                    const encodedQuery = encodeURIComponent(query);
                    const url = '/users/products/search?query=' + encodedQuery;
                    fetch(url)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Network response was not ok");
                            }
                            return response.json();
                        })
                        .then(data => {
                            const searchContainer = document.getElementById('search-product-result-container');
                            searchContainer.scrollIntoView({ behavior: 'smooth' });

                            searchContainer.style.border = '2px solid #b3b347';
                            setTimeout(() => {
                                searchContainer.style.border = 'none';
                            }, 2000);

                            const resultsHeader = document.getElementById('resultsHeader');
                            resultsHeader.innerHTML = `Showing results for ` + query;
                            productContainer.innerHTML = "";
                            data.forEach(product => displayProductElement(product, productContainer));
                            updateWishlistUI();
                        })
                        .catch(error => {
                            console.error("Error fetching products:", error);
                        });
                } catch (error) {
                    console.error('Error searching for products:', error);
                    Swal.fire('Error', 'Failed to search for products. Please try again later.', 'error');
                }
            }


        });
    </script>

    <script>
        //prepare for product display
        function displayProductElement(product, productContainer) {
            const productElement = document.createElement('div');
            productElement.classList.add("col-xl-3", "col-lg-4", "col-md-4", "col-12");

            const singleProduct = document.createElement('div');
            singleProduct.classList.add("single-product");

            const productImg = document.createElement('div');
            productImg.classList.add("product-img");

            const productLink = document.createElement('a');
            productLink.href = "#";

            const productImage = document.createElement('img');
            const imageUrl = `/admin/productImage/` + product.imageId;
            productImage.src = imageUrl;
            productImage.classList.add("main-img");
            productImage.alt = product.name;

            productImage.style.height = "200px";
            productImage.style.objectFit = "cover";

            productLink.appendChild(productImage);
            productImg.appendChild(productLink);

            const buttonHead = document.createElement('div');
            buttonHead.classList.add("button-head");

            const actionButton = document.createElement('div');
            actionButton.classList.add("action-button");
            actionButton.setAttribute("data-product-id", product.productId);

            actionButton.innerHTML = `
                    <a data-toggle="modal" data-target="#exampleModal" title="Quick view" href="#">
                        <i class="bi bi-eye"></i>
                        <span>Quick View</span>
                    </a>
                    <a title="wishlist" href="#" class="wishlist-btn" data-product-id="${product.productId}">
                        <i class="bi bi-heart"></i>
                        <span>Add to Wishlist</span>
                    </a>
                    <a title="shopping" href="#">
                        <i class="bi bi-cart"></i>
                        <span>Buy Now</span>
                    </a>
                `;
            const buttonLow = document.createElement('div');
            buttonLow.classList.add("button-low");

            const addToCartButton = document.createElement('a');
            addToCartButton.href = "#";
            addToCartButton.textContent = "Add to cart";
            addToCartButton.title = "Add to cart";

            buttonLow.appendChild(addToCartButton);
            buttonHead.appendChild(actionButton);
            buttonHead.appendChild(buttonLow);
            productImg.appendChild(buttonHead);

            const productTitle = document.createElement('div');
            productTitle.classList.add("product-title");

            const title = document.createElement('h3');
            const titleLink = document.createElement('a');
            titleLink.href = "#";
            titleLink.textContent = product.name;

            title.appendChild(titleLink);
            productTitle.appendChild(title);

            const productPrice = document.createElement('div');
            productPrice.classList.add("product-price");

            const priceSpan = document.createElement('span');
            priceSpan.textContent = product.price + ' MMK';

            productPrice.appendChild(priceSpan);
            productTitle.appendChild(productPrice);

            singleProduct.appendChild(productImg);
            singleProduct.appendChild(productTitle);
            productElement.appendChild(singleProduct);

            productContainer.appendChild(productElement);
        }

        
    </script>

    <!--End of Navbar-->