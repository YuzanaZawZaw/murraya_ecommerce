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
                <!-- <meta name="_csrf" content="${_csrf.token}" />
                <meta name="_csrf_header" content="${_csrf.headerName}" /> 
                -->
                <title>Product Category Management</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/categoryManagement.css?v=1.0">
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

                <!--Main Content-->
                <div class="main-content">
                    <div class="container mt-5">
                        <h2 class="mb-4 text-center">Product Category Management</h2>
                        <div class="category-container">
                            <form id="categoryForm" class="mb-4">
                                <!--dynamically use create or edit form-->
                                <input type="hidden" id="isEditing" value="false">
                                <!--edit_Category_Url is hide and store there-->
                                <input type="hidden" id="edit_Category_Url" name="edit_Category_Url" />
                                <div class="form-group">
                                    <label for="categoryId">Category Id</label>
                                    <input type="text" class="form-control" id="categoryId"
                                        placeholder="Enter category Id" required>
                                    <label for="name">Category Name</label>
                                    <input type="text" class="form-control" id="name" placeholder="Enter category name"
                                        required>
                                    <label for="parentCategory">Parent Category</label>
                                    <select class="form-control" id="parentCategory">
                                        <option value="">Select a parent category</option>

                                    </select>
                                    <label for="description">Description</label>
                                    <textarea class="form-control" id="description" placeholder="Enter description"
                                        rows="4" required></textarea>
                                </div>
                                <button type="submit" id="submitBtn" class="btn-category">Add Category</button>
                            </form>
                        </div>

                        <div class="table-container mt-3">
                            <table id="myTable" class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Parent Category</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${categoryList}">
                                        <tr>
                                            <td>${row.categoryId}</td>
                                            <td>${row.name}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty row.description}">
                                                        ${row.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        No Description
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td data-parentid="${row.parentCategory.categoryId}">${not empty
                                                row.parentCategory ? row.parentCategory.name : 'None'}</td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-warning"
                                                    data-category-id="${row.categoryId}"
                                                    data-edit-url="http://localhost:8080/admin/updateCategories/${row.categoryId}"
                                                    onclick="editCategoryPrompt(this)">
                                                    Edit
                                                </button>
                                                <a href="http://localhost:8080/admin/deleteCategories/${row.categoryId}"
                                                    class="btn btn-sm btn-danger delete-category" title="Delete"
                                                    data-confirm="Are you sure?">
                                                    Delete
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                        </div>
                    </div>
                </div>

                <!-- Typeahead Plugin for auto complete -->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>
                <!-- DataTables JS -->
                <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <!-- Bootstrap JS (with Popper.js) -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    $(document).ready(function () {
                        fetchParentCategories();//fetching parent categories when page load
                        adjustSidebarHeight();

                        $(window).resize(function () {
                            adjustSidebarHeight();
                        });
                    });

                    //datatable config
                    var table = $('#myTable').DataTable({
                        paging: true,
                        pagingType: 'full_numbers',
                        searching: true,
                        ordering: true,
                        info: true,
                        lengthMenu: [
                            [5, 10, 25, 50, 75, 100],
                            ['5 Rows', '10 Rows', '25 Rows', '50 Rows', '75 Rows', '100 Rows']
                        ],
                        initComplete: function () {
                            var api = this.api();
                            var dataSrc = [];

                            api.cells('tr', [0, 1, 2, 3, 4]).every(function () {
                                var data = $('<div>').html(this.data()).text();
                                if (dataSrc.indexOf(data) === -1) {
                                    dataSrc.push(data);
                                }
                            });

                            dataSrc.sort();

                            $('.dataTables_filter input[type="search"]', api.table().container())
                                .typeahead({
                                    source: dataSrc,
                                    afterSelect: function (value) {
                                        api.search(value).draw();
                                    }
                                });
                        }
                    });

                    //fetch all categories
                    async function fetchCategories() {
                        try {
                            const response = await fetch('http://localhost:8080/users/categories');
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to load categories.',
                                    });
                                });
                            }
                            const data = await response.json();
                            categories = data.categoryList.map(category => ({
                                categoryId: category.categoryId,
                                name: category.name,
                                description: category.description || "No Description",
                                parentCategory: category.parentCategory || null
                            }));

                            adjustSidebarHeight();
                        } catch (error) {
                            Swal.fire('Error!', error.message || 'Failed to fetch categories. Please try again later.', 'error');
                        }
                    }

                    //fetch parent categories
                    async function fetchParentCategories() {
                        try {
                            const response = await fetch('http://localhost:8080/users/parentCategories');
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to load parent categories.',
                                    });
                                });
                            }
                            const data = await response.json();
                            const parentCategories = data.parentCategoryList;
                            console.log('parentCategories', parentCategories);

                            const parentCategoryDropdown = document.getElementById('parentCategory');
                            parentCategoryDropdown.innerHTML = '<option value="">Select a parent category</option>';
                            parentCategories.forEach(category => {
                                const option = document.createElement('option');
                                option.value = category.categoryId;
                                option.textContent = category.name;
                                parentCategoryDropdown.appendChild(option);
                            });
                        } catch (error) {
                            console.error('Error fetching parent categories:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Failed to fetch parent categories. Please try again later.',
                            });
                        }
                    }

                    //draw delete category buttons
                    table.on('draw', function () {
                        bindDeleteCategoryButton();
                    });

                    // initially bind delete buttons
                    bindDeleteCategoryButton();

                    function bindDeleteCategoryButton() {
                        $("[data-confirm]").on("click", function (e) {
                            e.preventDefault();
                            var href = $(this).attr("href");
                            var message = $(this).data("confirm");

                            Swal.fire({
                                title: 'Are you sure?',
                                text: message,
                                icon: 'warning',
                                showCancelButton: true,
                                confirmButtonColor: '#d33',
                                cancelButtonColor: '#3085d6',
                                confirmButtonText: 'Yes, delete it!',
                                cancelButtonText: 'Cancel'
                            }).then((willDelete) => {
                                if (willDelete.isConfirmed) {
                                    fetch(href, {
                                        method: 'DELETE',
                                        headers: {
                                            'Content-Type': 'application/json'
                                        }
                                    }).then(response => {
                                        if (!response.ok) {
                                            return response.json().then(err => {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Error!',
                                                    text: err.message || 'Failed to delete category.',
                                                });
                                            });
                                        }
                                        return response.text();
                                    }).then(data => {
                                        Swal.fire({
                                            title: 'Deleted!',
                                            text: data,
                                            icon: 'success',
                                            showConfirmButton: false
                                        });
                                        setTimeout(() => {
                                            window.location.reload();
                                        }, 2000);
                                    }).catch(error => {
                                        Swal.fire('Error!', error.message || 'Failed to delete the category.', 'error');
                                    });
                                }
                            });
                        });
                    }

                    //calling update and add category using isEditing flag when click submit button
                    $('#categoryForm').on('submit', function (event) {
                        event.preventDefault();

                        const isEditing = document.getElementById('isEditing').value === "true";
                        if (isEditing) {
                            const updateCategoryId = document.getElementById('categoryId').value.trim();
                            const url = document.getElementById('edit_Category_Url').value.trim();//getting hide url
                            updateCategory(updateCategoryId, url);
                        } else {
                            addCategory();
                        }
                    });

                    // add a new category
                    async function addCategory() {
                        const categoryId = document.getElementById('categoryId').value.trim();
                        const name = document.getElementById('name').value.trim();
                        const description = document.getElementById('description').value.trim();
                        const parentCategoryId = document.getElementById('parentCategory').value;

                        if (!categoryId || !name || !description) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Please fill in all fields.',
                            });
                            return;
                        }

                        try {
                            const response = await fetch('http://localhost:8080/admin/addCategory', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({
                                    categoryId,
                                    name,
                                    description,
                                    parentCategory: parentCategoryId ? { categoryId: parentCategoryId } : null
                                })
                            });

                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to add category.',
                                    });
                                });
                            }

                            const result = await response.json();
                            console.log('Category added:', result.categoryId);

                            document.getElementById('categoryForm').reset();//reset categoryForm data 

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Category added successfully!',
                            }).then(() => {
                                window.location.reload();//reload when adding a new category
                            });
                        } catch (error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to add category. Please try again later.',
                            });
                        }
                    }

                    //onclick="editCategoryPrompt(this)"
                    function editCategoryPrompt(buttonElement) {
                        const categoryId = buttonElement.getAttribute('data-category-id');
                        const edit_Category_Url = buttonElement.getAttribute('data-edit-url');
                        let category = null;

                        // Loop through table rows to find the matching category
                        document.querySelectorAll("#myTable tbody tr").forEach(row => {
                            const rowCategoryId = row.cells[0].textContent.trim();
                            if (rowCategoryId === categoryId) {
                                category = {
                                    categoryId: rowCategoryId,
                                    name: row.cells[1].textContent.trim(),
                                    description: row.cells[2].textContent.trim() !== "No Description" ? row.cells[2].textContent.trim() : "",
                                    parentCategory: row.cells[3].dataset.parentid || null
                                };
                            }
                        });

                        if (!category) {
                            Swal.fire('Error', 'Category not found', 'error');
                            return;
                        }

                        document.getElementById('categoryId').value = category.categoryId;
                        document.getElementById('edit_Category_Url').value = edit_Category_Url;
                        document.getElementById('name').value = category.name;
                        document.getElementById('description').value = category.description || '';

                        let parentCategoryDropdown = document.getElementById('parentCategory');
                        if (category.parentCategory) {
                            for (let option of parentCategoryDropdown.options) {
                                if (option.value === category.parentCategory) {
                                    option.selected = true;
                                    break;
                                }
                            }
                        } else {
                            parentCategoryDropdown.value = "";
                        }

                        document.getElementById('categoryId').disabled = true;
                        document.getElementById('isEditing').value = "true";
                        document.getElementById('submitBtn').textContent = "Update Category";
                    }

                    //update category
                    async function updateCategory(updateCategoryId, url) {

                        const name = document.getElementById('name').value.trim();
                        const description = document.getElementById('description').value.trim();
                        const parentCategoryId = document.getElementById('parentCategory').value;

                        if (!updateCategoryId || !name || !description) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: 'Please fill in all fields.',
                            });
                            return;
                        }

                        try {
                            const response = await fetch(url, {
                                method: 'PUT',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({
                                    name,
                                    description,
                                    parentCategory: parentCategoryId ? { categoryId: parentCategoryId } : null
                                })
                            });
                            //fect backend errors and show them
                            if (!response.ok) {
                                return response.json().then(err => {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: err.message || 'Failed to update category.',
                                    });
                                });
                            }

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Category updated successfully!',
                            }).then(() => {
                                resetForm();
                                window.location.reload();
                            });
                        } catch (error) {
                            console.error('Error updating category:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to update category. Please try again later.',
                            });
                        }
                    }
                    //reset categoryForm data
                    function resetForm() {
                        document.getElementById('categoryForm').reset();
                        document.getElementById('categoryId').disabled = false;
                        document.getElementById('isEditing').value = "false";
                        document.getElementById('submitBtn').textContent = "Add Category";
                    }


                    //adjusting with sidebar
                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.table-container');
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