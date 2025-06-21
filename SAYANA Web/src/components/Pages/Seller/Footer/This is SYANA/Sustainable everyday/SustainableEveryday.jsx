import React from "react";

function SustainableEverydaySeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Sustainable Everyday</h1>
      <p className="mb-4 text-gray-700">
        At SYANA Home, we believe in making sustainability part of daily life. We are committed to offering products and services that help you make eco-friendly choices and reduce your environmental impact.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Eco-friendly Materials:</strong> We prioritize the use of renewable, recycled, and responsibly sourced materials in our products.
        </li>
        <li>
          <strong>Energy Efficiency:</strong> Our products are designed to help save energy and reduce waste, both in your home and during production.
        </li>
        <li>
          <strong>Recycling Initiatives:</strong> We support recycling and offer guidance on how to responsibly dispose of or recycle our products.
        </li>
        <li>
          <strong>Continuous Improvement:</strong> We are always looking for new ways to make our business and your home more sustainable.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        Learn more about our sustainability efforts or share your ideas by contacting us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        .
      </p>
    </div>
  );
}

export default SustainableEverydaySeller;