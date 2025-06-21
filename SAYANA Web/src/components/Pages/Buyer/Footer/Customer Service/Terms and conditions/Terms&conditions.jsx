import React from "react";

function TermsAndConditions() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Terms and Conditions</h1>
      <p className="mb-4">
        Welcome to SAYANA Home! These terms and conditions outline the rules and regulations for the use of our website and services.
      </p>
      <ol className="list-decimal pl-6 space-y-2 text-gray-700">
        <li>
          <strong>Acceptance of Terms:</strong> By accessing this website, you agree to be bound by these terms and conditions.
        </li>
        <li>
          <strong>Privacy:</strong> Your privacy is important to us. Please review our Privacy Policy for details on how we collect and use your information.
        </li>
        <li>
          <strong>Account Responsibility:</strong> You are responsible for maintaining the confidentiality of your account and password.
        </li>
        <li>
          <strong>Product Information:</strong> We strive to provide accurate product information, but we do not warrant that all descriptions or prices are complete, current, or error-free.
        </li>
        <li>
          <strong>Limitation of Liability:</strong> SAYANA Home will not be liable for any damages arising from the use or inability to use this site.
        </li>
        <li>
          <strong>Updates to Terms:</strong> We reserve the right to update these terms at any time. Continued use of the site means you accept any changes.
        </li>
      </ol>
      <p className="mt-6 text-gray-600">
        If you have any questions about our Terms and Conditions, please contact us at support@sayanahome.com.
      </p>
    </div>
  );
}

export default TermsAndConditions;