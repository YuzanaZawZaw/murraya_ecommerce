<form id="userSignUpForm">
    <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email" class="form-control" id="signUpEmail" name="email" required>
    </div>
    <div class="mb-3">
        <label for="userName" class="form-label">Username</label>
        <input type="text" class="form-control" id="userName" name="userName" required>
    </div>
    <div class="mb-3">
        <label for="passwordHash" class="form-label">Password</label>
        <input type="password" class="form-control" id="signUpPasswordHash" name="passwordHash" required>
    </div>
    <div class="mb-3">
        <label for="firstName" class="form-label">First Name</label>
        <input type="text" class="form-control" id="firstName" name="firstName">
    </div>
    <div class="mb-3">
        <label for="lastName" class="form-label">Last Name</label>
        <input type="text" class="form-control" id="lastName" name="lastName">
    </div>
    <div class="mb-3">
        <label for="phoneNumber" class="form-label">Phone Number</label>
        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber">
    </div>
    <button type="submit" class="btn btn-primary w-100">Sign Up</button>
</form>

<script>
    document.getElementById("userSignUpForm").addEventListener("submit", async function (event) {
        event.preventDefault();
        const email = document.getElementById('signUpEmail').value;
        const userName = document.getElementById('userName').value;
        const passwordHash = document.getElementById('signUpPasswordHash').value;
        const firstName = document.getElementById('firstName').value;
        const lastName = document.getElementById('lastName').value;
        const phoneNumber = document.getElementById('phoneNumber').value;

        if (!email || !userName || !passwordHash) {
            Swal.fire("Error", "Please fill in all required fields.", "error");
            return;
        }

        try {
            const response = await fetch("/userAuth/register", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email,
                    userName,
                    passwordHash,
                    firstName,
                    lastName,
                    phoneNumber
                })
            });

            if (!response.ok) {
                const errorMessage = await response.text();
                Swal.fire("Error", errorMessage, "error");
                return;
            }

            Swal.fire("Success", "Sign Up successful!", "success").then(() => {
                window.location.reload();
            });
        } catch (error) {
            Swal.fire("Error", "An unexpected error occurred. Please try again later.", "error");
        }
    });
</script>