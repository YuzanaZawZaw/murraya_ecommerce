<form id="loginForm">
    <div class="mb-3">
        <label for="userName" class="form-label">Username</label>
        <input type="text" class="form-control" id="userName" placeholder="Enter your username" required>
    </div>
    <div class="mb-3">
        <label for="passwordHash" class="form-label">Password</label>
        <input type="password" class="form-control" id="passwordHash" placeholder="Enter your password" required>
    </div>
    <button type="submit" class="btn btn-primary w-100">Login</button>
</form>
<div class="mt-3 text-center">
    <a href="#" class="text-decoration-none" id="forgetPasswordLink">Forget Password?</a>
</div>
<div class="mt-2 text-center">
    <span>Don't have an account?
        <a href="#" class="text-decoration-none" id="signUpButton">Sign Up</a>
    </span>
</div>

<script>
    document.getElementById("loginForm").addEventListener("submit", async function (event) {
        event.preventDefault();
        const userName = document.getElementById('userName').value;
        const passwordHash = document.getElementById('passwordHash').value;

        if (!userName || !passwordHash) {
            Swal.fire("Error", "Please fill in both username and password.", "error");
            return;
        }

        try {
            const response = await fetch("/userAuth/login", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    userName,
                    passwordHash
                })
            });

            if (!response.ok) {
                throw new Error("Invalid username or password.");
            }

            const data = await response.json();
            localStorage.setItem('userToken', data.userToken);
            Swal.fire("Success", "Login successful!", "success").then(() => {
                window.location.reload();
            });
        } catch (error) {
            Swal.fire("Error", error.message, "error");
        }
    });
</script>

</body>

</html>