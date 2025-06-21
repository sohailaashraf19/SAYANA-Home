import React from "react";

function CookiePolicy() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Cookie Policy</h1>
      <p className="mb-4 text-gray-700">
        This Cookie Policy explains how SYANA Home ("we", "us", or "our") uses cookies and similar technologies on our website and app. By using our services, you agree to the use of cookies as described in this policy.
      </p>
      <h2 className="text-xl font-semibold mt-6 mb-2">What are Cookies?</h2>
      <p className="mb-4 text-gray-700">
        Cookies are small text files placed on your device to help websites and apps function better and provide a more personalized experience. They help us remember your preferences and understand how you use our services.
      </p>
      <h2 className="text-xl font-semibold mt-6 mb-2">How We Use Cookies</h2>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li><strong>Essential Cookies:</strong> Required for the operation of our website and cannot be switched off.</li>
        <li><strong>Performance Cookies:</strong> Help us understand how visitors use our site so we can improve it.</li>
        <li><strong>Functional Cookies:</strong> Allow us to remember your preferences and provide enhanced features.</li>
        <li><strong>Targeting/Advertising Cookies:</strong> Used to deliver relevant ads and track their effectiveness.</li>
      </ul>
      <h2 className="text-xl font-semibold mt-6 mb-2">Managing Cookies</h2>
      <p className="mb-4 text-gray-700">
        You can control cookies through your browser settings. Please note that disabling some cookies may impact your experience on our site.
      </p>
      <h2 className="text-xl font-semibold mt-6 mb-2">More Information</h2>
      <p className="mb-4 text-gray-700">
        For any questions about our Cookie Policy, please contact us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>.
      </p>
    </div>
  );
}

export default CookiePolicy;