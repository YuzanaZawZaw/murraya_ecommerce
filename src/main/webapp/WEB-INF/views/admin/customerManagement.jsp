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
                <title>Customer Management</title>
                <!--Main CSS-->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerManagement.css?v=1.0">
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
                <!-- Main Content -->
                <div class="main-content">
                    <div class="container mt-5">
                        <h2 class="mb-4 text-center">Customer Management</h2>
                        <div class="table-container mt-3">
                            <table id="myTable" class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Email</th>
                                        <th>Username</th>
                                        <th>Firstname</th>
                                        <th>Lastname </th>
                                        <th>Phone number</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${userList}">
                                        <tr>
                                            <td>${row.userId}</td>
                                            <td>${row.email}</td>
                                            <td>${row.userName}</td>
                                            <td>${row.firstName}</td>
                                            <td>${row.lastName}</td>
                                            <td>${row.phoneNumber}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row.status.description == 'Active'}">
                                                        <span class="status-active">${row.status.description}</span>
                                                    </c:when>
                                                    <c:when test="${row.status.description == 'Inactive'}">
                                                        <span class="status-inactive">${row.status.description}</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>

                                            <c:if test="${row.status.description == 'Active'}">
                                                <td>
                                                    <a href="/userManagement/updateUserStatus/${row.userId}/2"
                                                        class="btn d-block w-100 d-sm-inline-block btn-outline-danger btn-sm"
                                                        title="Deactivate"
                                                        data-confirm="Are you sure you want to deactivate this account?">
                                                        <i class="zmdi zmdi-alert-octagon"></i> Deactivate
                                                    </a>
                                                </td>
                                            </c:if>
                                            <c:if test="${row.status.description =='Inactive'}">
                                                <td><a href="/userManagement/updateUserStatus/${row.userId}/1"
                                                        class="btn d-block w-100 d-sm-inline-block btn-outline-success btn-sm"
                                                        title="Deactivate"
                                                        data-confirm="Are you sure you want to activate this account ?"><i
                                                            class="zmdi zmdi-alert-octagon"></i>
                                                        Activate
                                                    </a>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS and Dependencies -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <!-- Typeahead Plugin for auto complete -->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.2/bootstrap3-typeahead.min.js"></script>
                <!-- DataTables JS -->
                <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
                <!-- SweetAlert Library -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script>
                    $(document).ready(function () {
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

                            api.cells('tr', [0, 1, 2, 3, 4, 5, 6]).every(function () {
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

                    //draw delete category buttons
                    table.on('draw', function () {
                        bindDeleteProductButton();
                    });

                    // initially bind delete buttons
                    bindDeleteProductButton();

                    function bindDeleteProductButton() {

                        $("[data-confirm]").on("click", function (e) {
                            e.preventDefault();
                            var href = $(this).attr("href");
                            var message = $(this).data("confirm");

                            Swal.fire({
                                title: message,
                                icon: 'warning',
                                showCancelButton: true,
                                confirmButtonColor: '#d33',
                                cancelButtonColor: '#3085d6',
                                confirmButtonText: 'Yes, proceed!',
                                cancelButtonText: 'Cancel'
                            }).then((willProceed) => {
                                if (willProceed.isConfirmed) {
                                    fetch(href, {
                                        method: 'PUT',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            'Authorization': 'Bearer ' + localStorage.getItem('token')
                                        }
                                    }).then(response => {
                                        if (!response.ok) {
                                            return response.text().then(text => {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Error!',
                                                    text: text || 'Failed to update user status.',
                                                });
                                            });
                                        }

                                        // Check if the response is JSON
                                        const contentType = response.headers.get('content-type');
                                        if (contentType && contentType.includes('application/json')) {
                                            return response.json().then(data => {
                                                Swal.fire({
                                                    title: 'Success!',
                                                    text: data.message || 'User status updated successfully.',
                                                    icon: 'success',
                                                    showConfirmButton: false
                                                });
                                                setTimeout(() => {
                                                    window.location.reload();
                                                }, 2000);
                                            });
                                        } else {
                                            return response.text().then(text => {
                                                Swal.fire({
                                                    title: 'Success!',
                                                    text: text || 'User status updated successfully.',
                                                    icon: 'success',
                                                    showConfirmButton: false
                                                });
                                                setTimeout(() => {
                                                    window.location.reload();
                                                }, 2000);
                                            });
                                        }
                                    }).catch(error => {
                                        Swal.fire('Error!', error.message || 'Failed to update user status', 'error');
                                    });
                                }
                            });
                        });
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