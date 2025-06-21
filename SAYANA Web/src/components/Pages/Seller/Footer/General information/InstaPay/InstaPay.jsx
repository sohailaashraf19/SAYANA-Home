import React from "react";

function InstaPaySeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">InstaPay</h1>
      <p className="mb-4 text-gray-700">
        SAYANA Home supports payments through InstaPay to make your shopping experience even more convenient and secure.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>What is InstaPay?</strong> <br />
          InstaPay is a leading electronic payment solution in Egypt that allows you to pay for your purchases quickly, safely, and directly from your bank account or mobile wallet.
        </li>
        <li>
          <strong>How to use InstaPay with SAYANA Home:</strong>
          <ul className="list-decimal pl-8 mt-1 space-y-1">
            <li>Select your products and proceed to checkout.</li>
            <li>Choose InstaPay as your payment method.</li>
            <li>Follow the on-screen instructions to complete your payment securely through the InstaPay app or portal.</li>
            <li>Once payment is confirmed, you will receive an order confirmation.</li>
          </ul>
        </li>
        <li>
          <strong>Benefits of using InstaPay:</strong>
          <ul className="list-decimal pl-8 mt-1 space-y-1">
            <li>Fast and secure transactions</li>
            <li>No need for cash or credit cards</li>
            <li>Instant payment confirmation</li>
            <li>Available 24/7</li>
          </ul>
        </li>
        <li>
          <strong>Need help?</strong> <br />
          If you have questions about InstaPay or encounter any issues, please contact our support team at{" "}
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
        For more details about payment options, visit our <a href="FAQ-seller" className="text-[#003664] underline">FAQ</a> page.
      </p>
    </div>
  );
}

export default InstaPaySeller;