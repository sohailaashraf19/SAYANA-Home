import React from "react";

function DemocraticDesign() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Democratic Design</h1>
      <p className="mb-4 text-gray-700">
        At SYANA Home, we believe that great design should be accessible to everyone. Our approach to <strong>Democratic Design</strong> ensures that every product we offer is created with five key principles in mind:
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Form:</strong> Beautiful and inspiring designs that fit every lifestyle and home.
        </li>
        <li>
          <strong>Function:</strong> Products that are practical, useful, and easy to use day after day.
        </li>
        <li>
          <strong>Quality:</strong> Durable materials and reliable construction for long-lasting value.
        </li>
        <li>
          <strong>Sustainability:</strong> Environmentally responsible choices, with a focus on minimizing our footprint and using renewable resources.
        </li>
        <li>
          <strong>Low Price:</strong> Making great design affordable for as many people as possible, without compromising on quality.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        Our mission is to combine these principles in everything we do, helping you create a home you love—at a price you can afford.
      </p>
      <p className="mt-2 text-gray-600">
        For more information about our design philosophy or specific products, please contact us at{" "}
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

export default DemocraticDesign;