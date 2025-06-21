import React from "react";

function GuaranteesWarrantiesSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Guarantees &amp; Warranties</h1>
      <p className="mb-4 text-gray-700">
        At SAYANA Home, we are committed to ensuring customer satisfaction by providing guarantees and warranties for selected products.
      </p>
      <ul className="list-disc pl-6 space-y-3 text-gray-800">
        <li>
          <strong>Manufacturer’s Warranty:</strong> Most products come with a standard manufacturer’s warranty. Details can be found on the product page or in the product’s documentation.
        </li>
        <li>
          <strong>Extended Guarantee:</strong> For some items, you can purchase an extended guarantee for additional peace of mind. Ask our staff for more details during your purchase.
        </li>
        <li>
          <strong>Warranty Terms:</strong> Warranty coverage typically includes manufacturing defects and does not cover accidental damage, misuse, or normal wear and tear.
        </li>
        <li>
          <strong>How to Claim:</strong> To make a claim, please keep your original receipt and contact our customer service team at <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">support@sayanahome.com</a>.
        </li>
        <li>
          <strong>Service Centers:</strong> We partner with authorized service centers to provide repair or replacement services, when required.
        </li>
        <li>
          <strong>Questions?</strong> If you have any questions about a product’s warranty or guarantee, please contact us and we’ll be happy to assist you.
        </li>
      </ul>
      <p className="mt-6 text-gray-600">
        Please read our <a href="terms-seller" className="text-[#003664] underline">Terms and Conditions</a> for more information.
      </p>
    </div>
  );
}

export default GuaranteesWarrantiesSeller;