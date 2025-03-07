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
                <title>Product Details</title>
                <title>Product Category Management</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetails.css?v=1.0">
                <!-- DataTables CSS and Pagination-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datatablePagination.css?v=1.0">
                <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
                <!-- SweetAlert CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
                <!--TOKEN HANDLER-->
                <script src="${pageContext.request.contextPath}/js/tokenHandler.js"></script>
            </head>

            <body>
                <!-- Sidebar -->
                <div id="sidebar" class="sidebar">
                    <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                </div>
                <!--End Sidebar-->

                <div class="main-content">
                    <!-- View Product Module -->
                    <div class="view-product-container mt-5">
                        <h2 class="mb-4 text-center">Product Image Management</h2>
                        <div class="category-container">
                            <!-- Product Details -->
                            <div class="product-details">
                                <!-- Back Button -->
                                <a href="/admin/productManagement" class="back-button">
                                    <i class="fas fa-arrow-left"></i> Product Management
                                </a>
                                <div class="card-header">
                                    <h3>Product Details</h3>
                                </div>
                                <p><strong>ProductId</strong> :<span id="productId"></span></p>
                                <p><strong>Name</strong> :<span id="productName"></span></p>
                                <p><strong>Price</strong> :<span id="productPrice"></span></p>
                                <p><strong>Description</strong> :<span id="productDescription"></span></p>
                                <p><strong>Category</strong> :<span id="productCategory"></span></p>
                                <p><strong>Status</strong> :<span id="productStatus"></span></p>
                                <p><strong>Stock Quantity</strong> :<span id="productStockQuantity"></span></p>
                            </div>
                        </div>

                        <!-- Image Preview Container -->
                        <div id="imagePreviewContainer" class="image-preview-container">

                        </div>

                        <!-- Image Upload Form -->
                        <form id="imageUploadForm" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="productImages">Upload Images</label>
                                <div class="file-input-container">
                                    <!-- Custom Button -->
                                        <button type="button" class="custom-file-input"
                                            onclick="document.getElementById('productImages').click()">
                                            Choose Files
                                        </button>
                                        <!-- Hidden File Input -->
                                        <input type="file" id="productImages" name="images" multiple accept="image/*"
                                            onchange="validateFileSize()">
                                </div>
                                <div class="file-input-feedback" id="fileFeedback">No files chosen</div>
                            </div>
                            <button type="submit" class="btn btn-primary" id="uploadButton">
                                <i class="fas fa-upload"></i> Upload Images
                            </button>
                        </form>

                        <!-- Existing Images -->
                        <div class="existing-images table-container mt-3">
                            <h3>Product Images</h3>
                            <div id="imageList" class="image-list"></div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS and Dependencies -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script>
                    function handleImagePreview(event) {
                        const files = event.target.files;
                        const uploadButton = document.getElementById('uploadButton');
                        const previewContainer = document.getElementById('imagePreviewContainer');

                        if (files.length === 0) return;

                        previewContainer.innerHTML = '';
                        if (files.length > 0) {
                            uploadButton.classList.remove("fade-out");
                            for (let i = 0; i < files.length; i++) {
                                const file = files[i];
                                const reader = new FileReader();

                                reader.onload = function (e) {
                                    const img = document.createElement('img');
                                    img.src = e.target.result;
                                    img.classList.add('product-image');
                                    previewContainer.appendChild(img);
                                };
                                reader.readAsDataURL(file);
                            }
                        }

                    }

                    $(document).ready(function () {
                        adjustSidebarHeight();
                        $(window).resize(function () {
                            adjustSidebarHeight();
                        });

                        const pathParts = window.location.pathname.split('/');
                        const productId = pathParts[pathParts.length - 1];

                        const uploadButton = document.getElementById('uploadButton');
                        const previewContainer = document.getElementById('imagePreviewContainer');
                        const previewImages = previewContainer.querySelectorAll('product-image');

                        uploadButton.classList.add("fade-out");// Hide the upload button

                        document.getElementById('productImages').addEventListener('change', handleImagePreview);// preview image befor upload

                        if (productId) {
                            loadProductDetails(productId);
                        } else {
                            Swal.fire('Error', 'Product ID not found', 'error');
                        }

                        document.getElementById('imageUploadForm').addEventListener('submit',
                            async function (event) {
                                event.preventDefault();

                                const fileInput = document.getElementById('productImages');
                                const formData = new FormData();

                                for (const file of fileInput.files) {
                                    formData.append('images', file);
                                }

                                try {
                                    const response = await fetch(`/admin/uploadProductImages/${productId}`, {
                                        method: 'POST',
                                        headers: {
                                            'Authorization': 'Bearer ' + localStorage.getItem('token')
                                        },
                                        body: formData,
                                    });

                                    if (response.ok) {
                                        Swal.fire('Success', 'Image uploaded successfully', 'success');

                                        loadProductImages(productId);// loaded after upload

                                        uploadButton.classList.add("fade-out");
                                        fileInput.value = '';
                                        previewContainer.classList.add("fade-out");
                                        setTimeout(() => {
                                            previewContainer.innerHTML = "";
                                            previewContainer.classList.remove("fade-out");
                                        }, 500);

                                    } else {
                                        throw new Error('Image upload failed');
                                    }
                                } catch (error) {
                                    console.error('Error uploading image:', error);
                                    Swal.fire('Error', 'Failed to upload image', 'error');
                                }
                            });
                    });


                    async function loadProductImages(productId) {
                        try {
                            console.log('loadProductImages product id', productId);
                            const response = await fetch('/admin/productImages/${productId}');
                            const images = await response.json();
                            //console.log('response: images',images);

                            const imageList = document.getElementById('imageList');
                            imageList.innerHTML = '';

                            images.forEach(image => {

                                const img = document.createElement('img');
                                const imageWrapper = document.createElement('div');
                                imageWrapper.classList.add("image-wrapper");

                                img.src = '/admin/productImage/' + image.id;
                                img.alt = image.altText || "Product image";
                                img.classList.add('product-image');

                                // Metadata Display
                                const metaInfo = document.createElement('p');
                                metaInfo.textContent = image.imageContentType;


                                imageWrapper.appendChild(img);
                                imageWrapper.appendChild(metaInfo);
                                console.log('imageWrapper', imageWrapper);
                                imageList.appendChild(imageWrapper);

                                // Click image to confirm deletion
                                img.onclick = function () {
                                    Swal.fire({
                                        title: "Are you sure?",
                                        text: "This image will be permanently deleted!",
                                        icon: "warning",
                                        showCancelButton: true,
                                        confirmButtonColor: "#d33",
                                        cancelButtonColor: "#3085d6",
                                        confirmButtonText: "Yes, delete it!",
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            deleteImage(image.id, imageWrapper);
                                        }
                                    });
                                };
                            });
                        } catch (error) {
                            console.error('Error loading images:', error);
                        }
                    }


                    function validateFileSize() {
                        const fileInput = document.getElementById('productImages');
                        const fileFeedback = document.getElementById('fileFeedback');
                        const maxSize = 10 * 1024 * 1024; // 10MB in bytes

                        if (fileInput.files.length > 0) {
                            const files = fileInput.files;
                            let isValid = true;

                            for (const file of files) {
                                if (file.size > maxSize) {
                                    isValid = false;
                                    alert('File size exceeds the maximum allowed limit of 10MB.');
                                    fileInput.value = ''; // Clear the file input
                                    fileFeedback.textContent = 'No files chosen';
                                    break;
                                }
                            }

                            if (isValid) {
                                fileFeedback.textContent = `${files.length} file(s) chosen`;
                            }
                        } else {
                            fileFeedback.textContent = 'No files chosen';
                        }
                    }

                    async function loadProductDetails(productId) {
                        try {
                            // Fetch product details
                            const response = await fetch('/admin/viewProduct/${productId}');
                            if (!response.ok) {
                                throw new Error('Failed to fetch product details');
                            }

                            const product = await response.json();

                            // Display product details
                            document.getElementById('productId').textContent = product.product.productId;
                            document.getElementById('productName').textContent = product.product.name;
                            document.getElementById('productPrice').textContent = product.product.price;
                            document.getElementById('productDescription').textContent = product.product.description;
                            document.getElementById('productCategory').textContent = product.product.category?.name || 'N/A';
                            document.getElementById('productStatus').textContent = product.product.status?.statusName || 'N/A';
                            document.getElementById('productStockQuantity').textContent = product.product.stockQuantity;
                            loadProductImages(productId);

                        } catch (error) {
                            console.error('Error loading product details:', error);
                            Swal.fire('Error', 'Failed to load product details', 'error');
                        }
                    }

                    async function deleteImage(imageId, imgWrapper) {
                        try {
                            const response = await fetch(`/admin/deleteProductImage/` + imageId, {
                                method: "DELETE",
                                headers: {
                                    "Authorization": "Bearer " + localStorage.getItem("token"),
                                },
                            });

                            if (response.ok) {
                                Swal.fire("Deleted!", "Image has been deleted.", "success");
                                imgWrapper.remove();
                            } else {
                                throw new Error("Failed to delete image");
                            }
                        } catch (error) {
                            console.error("Error deleting image:", error);
                            Swal.fire("Error", "Failed to delete image", "error");
                        }
                    }

                    //adjusting with sidebar
                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.existing-images');
                        const sidebar = document.getElementById('sidebar');

                        if (tableContainer && sidebar) {
                            const tableHeight = tableContainer.offsetHeight;
                            const mainContentHeight = document.querySelector('.main-content').offsetHeight;
                            sidebar.style.height = `${mainContentHeight}px`;
                        }
                    }
                </script>

            </body>

            </html>