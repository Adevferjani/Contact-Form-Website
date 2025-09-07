<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Cloud Programming - Contact Form</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <style>
    :root {
      --primary: #005eb8;
      --secondary: #e31837;
      --light: #f8f9fa;
      --dark: #212529;
      --success: #28a745;
      --error: #dc3545;
      --card-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
      --aws-orange: #FF9900;
      --aws-dark: #232F3E;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
      background: linear-gradient(135deg, #f4f8ff, #e6f0ff);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 30px;
      color: #333;
    }

    .container {
      max-width: 850px;
      width: 100%;
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: var(--card-shadow);
    }

    .header {
      background: linear-gradient(to right, var(--primary), #003d7a);
      color: white;
      padding: 40px;
      text-align: center;
    }

    .header h1 {
      font-size: 28px;
      font-weight: 600;
    }

    .header h2 {
      font-size: 18px;
      font-weight: 400;
      opacity: 0.9;
      margin-top: 8px;
    }

    .university-badge {
      display: inline-block;
      background: var(--secondary);
      color: white;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 500;
      margin-top: 14px;
    }

    .contact-form {
      padding: 50px;
    }

    .form-header {
      text-align: center;
      margin-bottom: 40px;
    }

    .form-header h1 {
      font-size: 34px;
      color: var(--primary);
      position: relative;
      display: inline-block;
      margin-bottom: 8px;
    }

    .form-header h1::after {
      content: '';
      display: block;
      margin: 10px auto 0;
      width: 70px;
      height: 3px;
      background: var(--secondary);
      border-radius: 2px;
    }

    .form-header p {
      color: #555;
      font-size: 16px;
      max-width: 600px;
      margin: 0 auto;
      line-height: 1.6;
    }

    .name-group {
      display: flex;
      gap: 20px;
      margin-bottom: 24px;
    }

    .name-group .form-group {
      flex: 1;
    }

    .form-group {
      margin-bottom: 24px;
    }

    label {
      display: block;
      margin-bottom: 6px;
      font-weight: 600;
      color: #333;
      font-size: 15px;
    }

    input, textarea {
      width: 100%;
      padding: 14px 16px;
      border: 1px solid #ddd;
      border-radius: 10px;
      font-size: 16px;
      transition: border-color 0.3s, box-shadow 0.3s;
    }

    input:focus, textarea:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 4px rgba(0, 94, 184, 0.1);
    }

    input::placeholder, textarea::placeholder {
      color: #999;
    }

    button {
      width: 100%;
      background: linear-gradient(to right, var(--primary), #004a93);
      color: white;
      border: none;
      padding: 16px;
      border-radius: 10px;
      font-size: 17px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 6px 18px rgba(0, 94, 184, 0.25);
    }

    button:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(0, 94, 184, 0.35);
    }

    button:disabled {
      background: #adb5bd;
      cursor: not-allowed;
      box-shadow: none;
      transform: none;
    }

    #response {
      margin-top: 25px;
      padding: 15px;
      border-radius: 8px;
      text-align: center;
      font-weight: 500;
    }

    .success {
      background: rgba(40, 167, 69, 0.15);
      color: var(--success);
      border: 1px solid var(--success);
    }

    .error {
      background: rgba(220, 53, 69, 0.15);
      color: var(--error);
      border: 1px solid var(--error);
    }

    .processing {
      color: var(--primary);
      background: rgba(0, 94, 184, 0.1);
      border: 1px solid var(--primary);
    }

    .aws-branding {
      background: var(--aws-dark);
      padding: 30px 50px;
      text-align: center;
      color: white;
    }

    .aws-logo {
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 15px;
    }

    .aws-icon {
      font-size: 50px;
      color: var(--aws-orange);
      margin-right: 15px;
    }

    .aws-text {
      font-size: 26px;
      font-weight: 700;
    }

    .aws-tagline {
      font-size: 16px;
      opacity: 0.85;
      max-width: 600px;
      margin: 0 auto;
      line-height: 1.5;
    }

    .aws-services {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 15px;
      font-size: 14px;
    }

    .service-tag {
      background: rgba(255, 255, 255, 0.15);
      padding: 5px 14px;
      border-radius: 20px;
    }

    @media (max-width: 768px) {
      .name-group {
        flex-direction: column;
        gap: 0;
      }

      .contact-form {
        padding: 35px;
      }

      .header {
        padding: 30px;
      }

      .header h1 {
        font-size: 24px;
      }

      .header h2 {
        font-size: 16px;
      }

      .form-header h1 {
        font-size: 28px;
      }

      .aws-logo {
        flex-direction: column;
      }

      .aws-icon {
        margin: 0 0 10px 0;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>IU International University of Applied Sciences</h1>
      <h2>Cloud Programming (DLBSEPCP01_E)</h2>
      <div class="university-badge">Portfolio Project</div>
    </div>

    <div class="contact-form">
      <div class="form-header">
        <h1>Contact Us</h1>
        <p>Submit your inquiries. Our team will respond promptly to assist you.</p>
      </div>

      <form id="contactForm">
        <div class="name-group">
          <div class="form-group">
            <label for="firstName">First Name</label>
            <input type="text" id="firstName" required placeholder="Enter your first name"/>
          </div>

          <div class="form-group">
            <label for="lastName">Last Name</label>
            <input type="text" id="lastName" required placeholder="Enter your last name"/>
          </div>
        </div>

        <div class="form-group">
          <label for="email">Email Address</label>
          <input type="email" id="email" required placeholder="Enter your email address"/>
        </div>

        <div class="form-group">
          <label for="message">Your Message</label>
          <textarea id="message" rows="4" required placeholder="Describe your question or issue"></textarea>
        </div>

        <button type="submit" id="submitBtn">Submit Message</button>
      </form>

      <div id="response"></div>
    </div>

    <div class="aws-branding">
      <div class="aws-logo">
        <div class="aws-icon">
          <i class="fab fa-aws"></i>
        </div>
        <div class="aws-text">Amazon Web Services</div>
      </div>
      <div class="aws-tagline">
        This project utilizes AWS cloud services to deliver a highly available, scalable solution.
      </div>
      <div class="aws-services">
        <span class="service-tag">S3</span>
        <span class="service-tag">CloudFront</span>
        <span class="service-tag">API Gateway</span>
        <span class="service-tag">Lambda</span>
        <span class="service-tag">DynamoDB</span>
      </div>
    </div>
  </div>

  <script>
    const apiEndpoint = "${api_endpoint}";
    const submitButton = document.getElementById("submitBtn");
    const responseElement = document.getElementById("response");

    document.getElementById("contactForm").addEventListener("submit", async function(e) {
      e.preventDefault();
      submitButton.disabled = true;
      responseElement.innerHTML = "<p class='processing'>Processing your request...</p>";
      responseElement.className = "processing";

      try {
        const formData = {
          firstName: document.getElementById("firstName").value,
          lastName: document.getElementById("lastName").value,
          email: document.getElementById("email").value,
          message: document.getElementById("message").value
        };

        const response = await fetch(apiEndpoint + "/submit", {
          method: "POST",
          mode: "cors",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(formData)
        });

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.message || "HTTP error! status: " + response.status);
        }

        const data = await response.json();
        responseElement.innerHTML = "<p class='success'>" + (data.message || "Submission successful!") + "</p>";
        responseElement.className = "success";
        document.getElementById("contactForm").reset();
      } catch (error) {
        console.error("Submission error:", error);
        responseElement.innerHTML = "<p class='error'>Error: " + (error.message || "Failed to submit form") + "</p>";
        responseElement.className = "error";
      } finally {
        submitButton.disabled = false;
      }
    });
  </script>
</body>
</html>
