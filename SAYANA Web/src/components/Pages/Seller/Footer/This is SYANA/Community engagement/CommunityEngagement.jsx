import React from "react";

function CommunityEngagementSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Community Engagement</h1>
      <p className="mb-4 text-gray-700">
        SYANA Home is proud to be an active part of our community. We believe in giving back and supporting positive change through various initiatives and partnerships.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Local Partnerships:</strong> We collaborate with local organizations and charities to make a difference.
        </li>
        <li>
          <strong>Volunteer Programs:</strong> Our team regularly participates in volunteering activities to support community causes.
        </li>
        <li>
          <strong>Educational Workshops:</strong> We host events and workshops to share knowledge about sustainable living, home improvement, and more.
        </li>
        <li>
          <strong>Customer Involvement:</strong> We encourage our customers to join our community programs and help us create a positive impact.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        Want to get involved or learn more? Email us at{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        .
      </p>
    </div>
  );
}

export default CommunityEngagementSeller;