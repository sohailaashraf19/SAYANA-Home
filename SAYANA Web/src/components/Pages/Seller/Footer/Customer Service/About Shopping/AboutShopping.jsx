import React from "react";

function AboutShoppingSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">About Shopping</h1>
      <p className="mb-4 text-gray-700">
        Shopping with SAYANA Home is designed to be easy, safe, and enjoyable! Here’s everything you need to know about buying from us:
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Wide Selection:</strong> Discover a broad range of products for your home, from furniture to accessories and more.
        </li>
        <li>
          <strong>Easy Ordering:</strong> Our online platform allows you to browse, select, and order your favorite items from anywhere, anytime.
        </li>
        <li>
          <strong>Safe &amp; Secure Payment:</strong> We use secure payment gateways to protect your information. Accepted methods include Cash and InstaPay.
        </li>
        <li>
          <strong>Order Tracking:</strong> Once you place your order, you can easily track its status through your account.
        </li>
        <li>
          <strong>Fast Delivery:</strong> Enjoy reliable and quick delivery to your doorstep.
        </li>
        <li>
          <strong>Customer Support:</strong> Our team is always available to assist you before and after your purchase.
        </li>
        <li>
          <strong>Returns &amp; Exchanges:</strong> If you’re not satisfied, you can return or exchange items according to our <a href="return-policy-seller" className="text-[#003664] underline">return policy</a>.
        </li>
        <li>
          <strong>Shopping Tips:</strong> Need advice? Check our <a href="FAQ-seller" className="text-[#003664] underline">FAQ</a> or contact us directly!
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        For questions or help with your order, email us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>{" "}
        or call{" "}
        <a href="tel:1234567890" className="text-[#003664] underline">
          123-456-7890
        </a>.
      </p>
    </div>
  );
}

export default AboutShoppingSeller;