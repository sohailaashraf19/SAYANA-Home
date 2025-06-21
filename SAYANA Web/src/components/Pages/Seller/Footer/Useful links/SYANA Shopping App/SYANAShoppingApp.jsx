import React from "react";

function SYANAShoppingAppSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">SYANA Shopping App</h1>
      <p className="mb-4 text-gray-700">
        The SYANA Shopping App brings the full SYANA Home experience to your fingertips! Shop, browse, and discover our products anytime, anywhere.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Easy Browsing:</strong> Explore our entire range of products with detailed images and descriptions.
        </li>
        <li>
          <strong>Exclusive Offers:</strong> Get app-only deals and early access to new collections.
        </li>
        <li>
          <strong>Order Tracking:</strong> Track your orders and get real-time updates.
        </li>
        <li>
          <strong>Wishlist:</strong> Save your favorite items for later.
        </li>
        <li>
          <strong>Easy Payment:</strong> Shop securely using multiple payment options, including InstaPay.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        Download coming soon for iOS and Android. For more information, contact us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        .
      </p>
    </div>
  );
}

export default SYANAShoppingAppSeller;