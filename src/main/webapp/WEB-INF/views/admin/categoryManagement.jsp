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
                <meta name="_csrf" content="${_csrf.token}" />
                <meta name="_csrf_header" content="${_csrf.headerName}" />
                <title>Product Category Management</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/categoryManagement.css?v=1.0">
                <!-- DataTables CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datatablePagination.css?v=1.0">
                <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
                <!-- SweetAlert CSS -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
            </head>

            <body>
                <!-- Sidebar -->
                <div id="sidebar" class="sidebar">
                    <jsp:include page="/WEB-INF/views/inc/adminDashboardSidebar.jsp"></jsp:include>
                </div>
                <!--End Sidebar-->
                <div class="main-content">
                    <div class="container mt-5">
                        <h2 class="mb-4 text-center">Product Category Management</h2>
                        <div class="category-container">
                            <form id="categoryForm" class="mb-4">
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
                                <button type="submit" class="btn-category">Add Category</button>
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
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty row.parentCategory}">
                                                        ${row.parentCategory.name}
                                                    </c:when>
                                                    <c:otherwise>
                                                        None
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-warning"
                                                    onclick="editCategoryPrompt('${row.categoryId}')">Edit</button>
                                                <a href="http://localhost:8080/admin/categories/${row.categoryId}"
                                                    class="btn btn-sm btn-danger delete-category" title="Delete"
                                                    data-confirm="Are you sure?">
                                                    Delete
                                                </a>
                                            </td>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                        </div>
                    </div>
                </div>

                <!-- Typeahead Plugin -->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>

                <!-- DataTables JS -->
                <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <script>
                    $(document).ready(function () {
                        fetchParentCategories();
                        adjustSidebarHeight();

                        $(window).resize(function () {
                            adjustSidebarHeight();
                        });
                    });

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


                    table.on('draw', function () {
                        bindDeleteCategoryButton();
                    });

                    // Initially bind delete buttons
                    bindDeleteCategoryButton();

                    function bindDeleteCategoryButton() {
                        $("[data-confirm]").on("click", function (e) {
                            event.preventDefault();
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
                                            throw new Error(`HTTP error! Status: ${response.status}`);
                                        }
                                        return response.text();
                                    }).then(data => {
                                        Swal.fire({
                                            title: 'Deleted!',
                                            text: 'The category has been deleted.',
                                            icon: 'success',
                                            showConfirmButton: false 
                                        });
                                        setTimeout(() => {
                                            window.location.reload();
                                        }, 2000);
                                    }).catch(error => {
                                        Swal.fire('Error!', 'Failed to delete the category.', 'error');
                                    });
                                }
                            });
                        });
                    }

                    $('#categoryForm').on('submit', function (event) {
                        console.log("saving category");
                        event.preventDefault();
                        addCategory();
                    });

                    function adjustSidebarHeight() {
                        const tableContainer = document.querySelector('.table-container');
                        const sidebar = document.getElementById('sidebar');

                        if (tableContainer && sidebar) {
                            const tableHeight = tableContainer.offsetHeight;
                            const mainContentHeight = document.querySelector('.main-content').offsetHeight;
                            sidebar.style.height = `${mainContentHeight}px`;
                        }
                    }

                    async function fetchCategories() {
                        try {
                            const response = await fetch('http://localhost:8080/admin/categories');
                            if (!response.ok) {
                                throw new Error(`HTTP error! Status: ${response.status}`);
                            }
                            const data = await response.json();
                            console.log('Fetched Categories:', data);
                            categories = data.categoryList.map(category => ({
                                categoryId: category.categoryId,
                                name: category.name,
                                description: category.description || "No Description",
                                parentCategory: category.parentCategory || null
                            }));

                            //renderTable();
                            adjustSidebarHeight();
                        } catch (error) {
                            console.error('Error fetching categories:', error);
                            alert('Failed to fetch categories. Please try again later.');
                        }
                    }


                    async function fetchParentCategories() {
                        try {
                            const response = await fetch('http://localhost:8080/admin/categories');
                            if (!response.ok) {
                                throw new Error(`HTTP error! Status: ${response.status}`);
                            }
                            const data = await response.json();
                            const parentCategories = data.categoryList.filter(category => !category.parentCategory);

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

                    // Add a new category
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
                                throw new Error(`HTTP error! Status: ${response.status}`);
                            }

                            const result = await response.json();
                            console.log('Category added:', result.categoryId);

                            //fetchCategories(); 
                            document.getElementById('categoryForm').reset();

                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: 'Category added successfully!',
                            }).then(() => {
                                window.location.reload();
                            });
                        } catch (error) {
                            console.error('Error adding category:', error);

                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: error.message || 'Failed to add category. Please try again later.',
                            });
                        }
                    }

                    function renderTable() {
                        dataTable.clear();
                        dataTable.rows.add(categories);
                        dataTable.draw();
                    }


                    function editCategoryPrompt(id) {
                        const category = categories.find(cat => cat.categoryId === id);
                        if (category) {
                            const newName = prompt('Enter new category name:', category.name);
                            if (newName) {
                                category.name = newName;
                                renderTable();
                            }
                        }
                    }

                </script>

            </body>

            </html>