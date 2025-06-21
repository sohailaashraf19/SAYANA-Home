import React from "react";

function ReturnPolicy() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Return Policy</h1>
      <p className="mb-4 text-gray-700">
        At SAYANA Home, your satisfaction is important to us. If you are not completely satisfied with your purchase, you may return most items within <strong>14 days</strong> of receipt for a refund or exchange, subject to the conditions below:
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Eligibility:</strong> Items must be unused, in their original packaging, and accompanied by a receipt or proof of purchase.
        </li>
        <li>
          <strong>Non-returnable Items:</strong> Certain products such as customized items, clearance items, and personal care products cannot be returned unless faulty.
        </li>
        <li>
          <strong>Return Process:</strong> To initiate a return, please contact our customer service at <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">support@sayanahome.com</a> or call <a href="tel:1234567890" className="text-[#003664] underline">123-456-7890</a> to obtain a return authorization.
        </li>
        <li>
          <strong>Refunds:</strong> Once your return is received and inspected, we will notify you of the approval or rejection of your refund. Approved refunds will be processed to your original method of payment.
        </li>
        <li>
          <strong>Exchanges:</strong> If you wish to exchange an item for the same or another product, please mention this when you contact us to arrange your return.
        </li>
        <li>
          <strong>Return Shipping:</strong> Customers are responsible for return shipping costs unless the item is defective or incorrect.
        </li>
        <li>
          <strong>Damaged or Defective Items:</strong> If you receive a damaged or defective product, please contact us immediately with photos and order details. We will arrange for a replacement or refund.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        For more details, please read our <a href="/buyer/terms" className="text-[#003664] underline">Terms and Conditions</a> or contact our support team for assistance.
      </p>
    </div>
  );
}

export default ReturnPolicy;