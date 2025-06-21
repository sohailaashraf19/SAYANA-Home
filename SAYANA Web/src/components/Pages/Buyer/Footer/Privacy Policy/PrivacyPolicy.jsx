import React from "react";

function PrivacyPolicy() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Privacy Policy</h1>
      <p className="mb-4 text-gray-700">
        At SYANA Home, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our website, app, and services.
      </p>

      <h2 className="text-xl font-semibold mt-6 mb-2">What Information We Collect</h2>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Personal Information:</strong> Such as your name, contact details, address, and account information.
        </li>
        <li>
          <strong>Usage Data:</strong> Information on how you use our website and app, including pages visited and actions taken.
        </li>
        <li>
          <strong>Cookies & Tracking:</strong> We use cookies and similar technologies to enhance your experience (see our Cookie Policy for details).
        </li>
      </ul>

      <h2 className="text-xl font-semibold mt-6 mb-2">How We Use Your Information</h2>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>To provide and improve our products and services.</li>
        <li>To personalize your experience with SYANA Home.</li>
        <li>To process orders and manage your account.</li>
        <li>To communicate with you about updates, offers, and support.</li>
        <li>To comply with legal obligations.</li>
      </ul>

      <h2 className="text-xl font-semibold mt-6 mb-2">How We Protect Your Information</h2>
      <p className="mb-4 text-gray-700">
        We use industry-standard security measures to keep your information safe. Only authorized personnel have access to your data, and we never sell your information to third parties.
      </p>

      <h2 className="text-xl font-semibold mt-6 mb-2">Your Rights</h2>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>You can request to view, update, or delete your personal information at any time.</li>
        <li>You may opt out of marketing communications by following the instructions in our emails.</li>
        <li>For questions or requests about your data, contact us at <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">support@sayanahome.com</a>.</li>
      </ul>

      <h2 className="text-xl font-semibold mt-6 mb-2">Updates to This Policy</h2>
      <p className="mb-4 text-gray-700">
        We may update this Privacy Policy from time to time. Please check this page regularly for any changes.
      </p>
    </div>
  );
}

export default PrivacyPolicy;