import React from "react";

function SpareParts() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Spare Parts</h1>
      <p className="mb-4 text-gray-700">
        At SAYANA Home, we understand the importance of keeping your products in top condition.
        That’s why we offer a range of spare parts for many of our items.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>How to Order:</strong> Please contact our customer service with your product name, model, and the part you need.
        </li>
        <li>
          <strong>Availability:</strong> Spare parts are available for selected products only. We will let you know about stock and delivery times.
        </li>
        <li>
          <strong>Support:</strong> Our team can help you identify the required part and guide you through the ordering process.
        </li>
        <li>
          <strong>Installation:</strong> Instructions are provided with most parts. For assistance, please request installation support.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        To request a spare part, email us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        {" "}or call{" "}
        <a href="tel:1234567890" className="text-[#003664] underline">
          123-456-7890
        </a>.
      </p>
      <p className="mt-2 text-gray-600">
        Please have your order number and product details ready for faster service.
      </p>
    </div>
  );
}

export default SpareParts;