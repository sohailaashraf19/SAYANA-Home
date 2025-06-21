import React from "react";

function AboutServices() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">About Services</h1>
      <p className="mb-4 text-gray-700">
        At SAYANA Home, we are committed to providing a variety of helpful services to make your shopping experience as smooth and enjoyable as possible.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Home Delivery:</strong> Fast and secure delivery to your doorstep, with flexible delivery options to suit your schedule.
        </li>
        <li>
          <strong>Assembly Service:</strong> Need help putting your furniture together? Our professional team can assemble your items for you.
        </li>
        <li>
          <strong>Product Installation:</strong> We offer installation services for certain products to ensure safe and correct setup in your home.
        </li>
        <li>
          <strong>Customer Support:</strong> Our team is here to assist you before, during, and after your purchase. Contact us for any questions or concerns.
        </li>
        <li>
          <strong>Spare Parts:</strong> We provide access to original spare parts for many of our products.
        </li>
        <li>
          <strong>Returns &amp; Exchanges:</strong> If you are not fully satisfied, you can return or exchange items according to our <a href="/buyer/return-policy" className="text-[#003664] underline">return policy</a>.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        For more information about any of our services, please contact us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        {" "}or call{" "}
        <a href="tel:1234567890" className="text-[#003664] underline">
          123-456-7890
        </a>.
      </p>
    </div>
  );
}

export default AboutServices;