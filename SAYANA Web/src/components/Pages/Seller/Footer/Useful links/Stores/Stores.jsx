import React from "react";

function StoresSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Stores</h1>
      <p className="mb-4 text-gray-700">
        Visit SYANA Home stores to experience our products in person! Our stores offer a welcoming atmosphere and expert help to make your shopping experience enjoyable.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Store Locations:</strong> Find the nearest SYANA Home store using our online store locator.
        </li>
        <li>
          <strong>In-Store Services:</strong> Get personalized advice, product demos, and enjoy special events.
        </li>
        <li>
          <strong>Order Pickup:</strong> Shop online and collect your order at your preferred store.
        </li>
        <li>
          <strong>Experience Zones:</strong> Discover room setups and get inspiration for your home.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        For store addresses and opening hours, visit our <a href="/store-locator" className="text-[#003664] underline">Store Locator</a> or contact{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        .
      </p>
    </div>
  );
}

export default StoresSeller;