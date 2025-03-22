<form id="forgetPasswordForm">
    <div class="mb-3">
        <label for="email">Enter your Email Address:</label>
        <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" required>
    </div>
    <button type="submit" class="btn btn-primary w-100">Submit</button>
</form>

<script>
    document.getElementById("forgetPasswordForm").addEventListener("submit", async function (event) {
        event.preventDefault();
        const email = document.getElementById("email").value.trim();

        if (!email) {
            Swal.fire("Error", "Please enter your email.", "error");
            return;
        }

        try {
            const response = await fetch(`/userAuth/forgetPassword?email=` + encodeURIComponent(email), {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (!response.ok) {
                throw new Error("Failed to send reset password email.");
            }

            Swal.fire("Success", "Reset password email sent successfully!", "success").then(() => {
                const forgetPasswordModal = bootstrap.Modal.getInstance(document.getElementById("forgetPasswordModal"));
                forgetPasswordModal.hide();

                // Wait for the forgetPasswordModal to fully hide before showing the resetPasswordModal
                forgetPasswordModal._element.addEventListener('hidden.bs.modal', function () {
                    const resetPasswordModal = new bootstrap.Modal(document.getElementById("resetPasswordModal"));
                    resetPasswordModal.show();

                    // Populate the email field in the resetPasswordForm with the value from the forgetPasswordForm
                    document.getElementById("resetPasswordEmail").value = email;
                }, { once: true });
            });
        } catch (error) {
            Swal.fire("Error", error.message, "error");
        }
    });
</script>