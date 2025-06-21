import React from "react";

function AboutSYANASeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">About SYANA Home</h1>
      <p className="mb-4 text-gray-700">
        SYANA Home is dedicated to providing high-quality furniture and home accessories that blend style, comfort, and affordability. Our goal is to help you create a beautiful and functional living space that truly feels like home.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Who We Are:</strong> <br />
          SYANA Home is a team of passionate professionals with years of experience in the furniture and home décor industry. We carefully select every product to ensure quality and value for our customers.
        </li>
        <li>
          <strong>Our Mission:</strong> <br />
          To make stylish and durable home furnishings accessible to everyone, while delivering an exceptional customer experience.
        </li>
        <li>
          <strong>What We Offer:</strong> <br />
          A wide variety of furniture, accessories, and décor items, with new collections added regularly. We also offer fast delivery, assembly, and customer support services.
        </li>
        <li>
          <strong>Why Choose SYANA Home?</strong>
          <ul className="list-disc pl-6 mt-1 space-y-1">
            <li>High-quality products at affordable prices</li>
            <li>Dedicated customer service</li>
            <li>Convenient online shopping and secure payments</li>
            <li>Fast delivery and reliable after-sale support</li>
          </ul>
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        For questions, partnership opportunities, or to learn more about us, please contact us at{" "}
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

export default AboutSYANASeller;