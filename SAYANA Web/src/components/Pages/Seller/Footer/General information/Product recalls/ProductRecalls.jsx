import React from "react";

function ProductRecallsSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Product Recalls</h1>
      <p className="mb-4 text-gray-700">
        At SAYANA Home, your safety and satisfaction are our top priorities. We are committed to informing our customers promptly about any product recalls related to our items.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Current Recalls:</strong> We currently have no active product recalls. Please check this page regularly for the latest information.
        </li>
        <li>
          <strong>Recall Notices:</strong> If a product you have purchased is recalled, we will contact you directly using the information provided at the time of purchase. Details will also be posted here.
        </li>
        <li>
          <strong>What to Do:</strong> If you believe you own a recalled product, please stop using it immediately and follow the recall instructions provided on this page, or contact our support team for assistance.
        </li>
        <li>
          <strong>Customer Support:</strong> For questions or to report a concern, contact us at{" "}
          <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
            support@sayanahome.com
          </a>
          {" "}or call{" "}
          <a href="tel:1234567890" className="text-[#003664] underline">
            123-456-7890
          </a>.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        For more information about product safety, please refer to our{" "}
        <a href="terms-seller" className="text-[#003664] underline">
          Terms and Conditions
        </a>
        .
      </p>
    </div>
  );
}

export default ProductRecallsSeller;