<form id="resetPasswordForm">
    <div class="mb-3">
        <label for="resetPasswordEmail">Your Email Address:</label>
        <input type="email" id="resetPasswordEmail" name="email" class="form-control" readonly required>
    </div>
    <div class="mb-3">
        <label for="newPassword" class="form-label">New Password</label>
        <input type="password" class="form-control" id="newPassword"
            placeholder="Enter your new password" required>
    </div>
    <div class="mb-3">
        <label for="confirmPassword" class="form-label">Confirm Password</label>
        <input type="password" class="form-control" id="confirmPassword"
            placeholder="Confirm your new password" required>
    </div>
    <button type="submit" class="btn btn-primary w-100">Reset Password</button>
</form>

<script>
    document.getElementById("resetPasswordForm").addEventListener("submit", async function (event) {
        event.preventDefault();
        const resetPasswordEmail = document.getElementById("resetPasswordEmail").value.trim();
        const newPassword = document.getElementById("newPassword").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();

        if (!newPassword || !confirmPassword) {
            Swal.fire("Error", "Please fill in all fields.", "error");
            return;
        }

        if (newPassword !== confirmPassword) {
            Swal.fire("Error", "Passwords do not match.", "error");
            return;
        }

        try {
            const response = await fetch(`/userAuth/resetPassword?email=`+resetPasswordEmail+`&&newPassword=` + newPassword, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (!response.ok) {
                throw new Error("Failed to reset password.");
            }

            Swal.fire("Success", "Password reset successfully!", "success").then(() => {
                const resetPasswordModal = bootstrap.Modal.getInstance(document.getElementById("resetPasswordModal"));
                resetPasswordModal.hide();
            });
        } catch (error) {
            Swal.fire("Error", error.message, "error");
        }
    });
</script>