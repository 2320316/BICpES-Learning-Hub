document.addEventListener("DOMContentLoaded", () => {
    const loginButton = document.getElementById("login");
    const cancelButton = document.getElementById("cancel");

    // login button
    loginButton.addEventListener("click", () => {
        const username = document.getElementById("Username").value;
        const password = document.getElementById("Password").value;

        // Simpleng validation example
        if (username === "admin" && password === "1234") {
            alert("Login successful!");
            // Redirect to dashboard/homepage
            window.location.href = "dashboard.html";
        } else {
            alert("Invalid username or password.");
        }
    });

    cancelButton.addEventListener("click", () => {
        window.location.href="index.html";
    });
});