import React from "react";

function SYANAFamilySeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">SYANA Family</h1>
      <p className="mb-4 text-gray-700">
        Join the SYANA Family and enjoy exclusive benefits, offers, and experiences! Our loyalty program is designed to reward our most valued customers.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Member Discounts:</strong> Get special prices and early access to new collections.
        </li>
        <li>
          <strong>Events &amp; Workshops:</strong> Receive invitations to members-only events and home inspiration workshops.
        </li>
        <li>
          <strong>Birthday Surprises:</strong> Enjoy a special gift on your birthday!
        </li>
        <li>
          <strong>Personalized Offers:</strong> Receive recommendations and offers tailored to your interests.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        Sign up for free in-store or online. For more details, contact{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        .
      </p>
    </div>
  );
}

export default SYANAFamilySeller;