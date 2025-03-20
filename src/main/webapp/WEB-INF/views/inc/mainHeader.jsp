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
                        <a href="/users/wishlist" class="nav-link">
                            <i class="bi bi-heart"></i>
                            <span id="favorite-count">0</span>
                        </a>
                    </li>
                    </li>
                    <li class="nav-item">
                        <a href="/users/shoppingList" class="nav-link">
                            <i class="bi bi-cart"></i>
                            <span id="shopping-count">0</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!--FOR CATEGORIES DROP DOWN-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert Library -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                            updateShoppingCount();
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
                    </a> `;
            // <a title="shopping" href="#" class="cart-btn" data-product-id="${product.productId}">
            //     <i class="bi bi-cart"></i>
            //     <span>Buy Now</span>
            // </a>

            //const buttonLow = document.createElement('div');
            //buttonLow.classList.add("button-low");

            // const addToCartButton = document.createElement('a');
            // addToCartButton.href = "#";
            // addToCartButton.textContent = "Add to cart";
            // addToCartButton.title = "Add to Cart";
            // addToCartButton.classList.add("cart-btn");
            // addToCartButton.setAttribute("data-product-id", product.productId);
            // addToCartButton.onclick = function () {
            //     addToCart(product.productId);
            // };


            //buttonLow.appendChild(addToCartButton);
            buttonHead.appendChild(actionButton);
            //buttonHead.appendChild(buttonLow);
            productImg.appendChild(buttonHead);

            // Product details container
            const productTitle = document.createElement("div");
            productTitle.classList.add("product-title");

            const title = document.createElement("h5");
            title.classList.add("card-title");
            title.textContent = product.name;

            const priceContainer = document.createElement("p");
            priceContainer.classList.add("card-text");

            if (product.discountedPrice && product.discountPercentage) {
                priceContainer.innerHTML =
                    `<del><strong>Price:</strong> ` + Math.floor(product.price) + `MMK</del><br>` +
                    `<strong>Discounted Price:</strong> ` + Math.floor(product.discountedPrice) + ` MMK` +
                    `<span class="text-danger">(` + Math.floor(product.discountPercentage) + `% off)</span>`;
            } else {
                priceContainer.innerHTML = `<strong>Price:</strong> ` + Math.floor(product.price) + ` MMK`;
            }

            productTitle.appendChild(title);
            productTitle.appendChild(priceContainer);
            singleProduct.appendChild(productImg);
            singleProduct.appendChild(productTitle);
            productElement.appendChild(singleProduct);

            productContainer.appendChild(productElement);
        }

        // Product Details info 
        function displayProductDetails(data, productContainer) {
            const productElement = document.createElement("div");
            productElement.classList.add("row");

            // Left Side: Product Images (Carousel)
            const imagesContainer = document.createElement("div");
            imagesContainer.classList.add("col-md-6");

            const carousel = document.createElement("div");
            carousel.id = `productCarousel-` + data.productId;
            carousel.classList.add("carousel", "slide");
            carousel.setAttribute("data-bs-ride", "carousel");

            const carouselInner = document.createElement("div");
            carouselInner.classList.add("carousel-inner");

            data.images.forEach((image, index) => {
                const carouselItem = document.createElement("div");
                carouselItem.classList.add("carousel-item");
                if (index === 0) {
                    carouselItem.classList.add("active");
                }

                const img = document.createElement("img");
                img.src = `/admin/productImage/` + image.imageId;
                img.classList.add("d-block", "w-100");
                img.style.height = "400px";
                img.style.objectFit = "cover";

                carouselItem.appendChild(img);
                carouselInner.appendChild(carouselItem);
            });

            // Carousel Controls
            const prevButton = document.createElement("button");
            prevButton.classList.add("carousel-control-prev");
            prevButton.setAttribute("data-bs-target", `#productCarousel-` + data.productId);
            prevButton.setAttribute("data-bs-slide", "prev");
            prevButton.innerHTML = `<span class="carousel-control-prev-icon"></span>`;

            const nextButton = document.createElement("button");
            nextButton.classList.add("carousel-control-next");
            nextButton.setAttribute("data-bs-target", `#productCarousel-` + data.productId);
            nextButton.setAttribute("data-bs-slide", "next");
            nextButton.innerHTML = `<span class="carousel-control-next-icon"></span>`;

            carousel.appendChild(carouselInner);
            carousel.appendChild(prevButton);
            carousel.appendChild(nextButton);
            imagesContainer.appendChild(carousel);

            // Right Side: Product Details
            const detailsContainer = document.createElement("div");
            detailsContainer.classList.add("col-md-6");

            const title = document.createElement("h2");
            title.textContent = data.name;

            const description = document.createElement("p");
            description.textContent = data.description;


            const priceContainer = document.createElement("p");
            priceContainer.classList.add("card-text");

            if (data.discountedPrice && data.discountPercentage) {
                priceContainer.innerHTML =
                    `<del><strong>Price:</strong> ` + Math.floor(data.price) + `MMK</del><br>` +
                    `<strong>Discounted Price:</strong> ` + Math.floor(data.discountedPrice) + ` MMK` +
                    `<span class="text-danger">(` + Math.floor(data.discountPercentage) + `% off)</span>`;
            } else {
                priceContainer.innerHTML = `<strong>Price:</strong> ` + Math.floor(data.price) + ` MMK`;
            }

            // Free Delivery Status
            const freeDelivery = document.createElement("p");
            freeDelivery.classList.add("card-text");
            freeDelivery.innerHTML = `<strong>Free Delivery?:</strong> ` + (data.freeDelivery ? "Yes" : "No");

            // Quantity Selector with Minus and Plus Buttons
            const quantityLabel = document.createElement("label");
            quantityLabel.textContent = "Quantity:";
            quantityLabel.classList.add("form-label");

            const quantityWrapper = document.createElement("div");
            quantityWrapper.classList.add("input-group", "mb-3");
            quantityWrapper.style.width = "150px";

            // Minus Button
            const minusButton = document.createElement("button");
            minusButton.classList.add("btn", "btn-outline-secondary");
            minusButton.type = "button";
            minusButton.textContent = "-";
            minusButton.addEventListener("click", () => {
                const currentValue = parseInt(quantityInput.value);
                if (currentValue > 1) {
                    quantityInput.value = currentValue - 1;
                }
            });

            // Quantity Input
            const quantityInput = document.createElement("input");
            quantityInput.type = "number";
            quantityInput.classList.add("form-control", "text-center");
            quantityInput.value = "1";
            quantityInput.min = "1";
            quantityInput.max = data.stockQuantity;

            // Plus Button
            const plusButton = document.createElement("button");
            plusButton.classList.add("btn", "btn-outline-secondary");
            plusButton.type = "button";
            plusButton.textContent = "+";
            
            plusButton.addEventListener("click", () => {
                const currentValue = parseInt(quantityInput.value);
                if (currentValue < data.stockQuantity) {
                    quantityInput.value = currentValue + 1;
                }
            });
            // Append Minus, Input, and Plus to Quantity Wrapper
            quantityWrapper.appendChild(minusButton);
            quantityWrapper.appendChild(quantityInput);
            quantityWrapper.appendChild(plusButton);



            // Add to Cart Button
            const addToCartButton = document.createElement("button");
            addToCartButton.classList.add("btn", "btn-primary");
            addToCartButton.textContent = "Add to Cart";
            addToCartButton.onclick = function () {
                data.stockQuantity = parseInt(quantityInput.value); // Bind quantity to the product object
                addToCart(data);
            };

            // Append Details
            detailsContainer.appendChild(title);
            detailsContainer.appendChild(description);
            detailsContainer.appendChild(priceContainer);
            detailsContainer.appendChild(freeDelivery);
            detailsContainer.appendChild(quantityLabel);
            detailsContainer.appendChild(quantityWrapper);
            detailsContainer.appendChild(addToCartButton);

            // Append Everything
            productElement.appendChild(imagesContainer);
            productElement.appendChild(detailsContainer);
            productContainer.appendChild(productElement);
        }

        function addToCart(product) {
            console.log('product', product);
            let shopping = JSON.parse(localStorage.getItem("shopping")) || [];
            console.log('shopping', shopping);

            // Check if the product is already in the cart
            const existingProduct = shopping.find(item => item.productId === product.productId);
            if (!existingProduct) {
                const productToAdd = {
                    productId: product.productId,
                    name: product.name,
                    description: product.description,
                    stockQuantity: product.stockQuantity,
                    price: product.price,
                    images: product.images, // Array of image URLs
                    freeDelivery: product.freeDelivery // Include freeDelivery value
                };

                console.log('productToAdd', productToAdd);

                // Include discount details if discountCode exists
                if (product.discountCode) {
                    productToAdd.discountCode = product.discountCode;
                    productToAdd.discountedPrice = product.discountedPrice;
                    productToAdd.discountPercentage = product.discountPercentage;
                }

                shopping.push(productToAdd);
                localStorage.setItem("shopping", JSON.stringify(shopping));
                console.log('shopping', shopping);

                // Use Swal alert instead of alert
                Swal.fire({
                    icon: 'success',
                    title: 'Added to Cart',
                    text: product.name + ` has been added to your cart.`,
                    timer: 2000,
                    showConfirmButton: false
                }).then(() => {
                    updateShoppingCount();
                });
            } else {
                Swal.fire({
                    icon: 'info',
                    title: 'Already in Cart',
                    text: product.name + ` is already in your cart.`,
                    timer: 2000,
                    showConfirmButton: false
                });
            }
        }
    </script>

    <!--End of Navbar-->