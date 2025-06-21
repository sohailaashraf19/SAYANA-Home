import React from "react";

function PlanningToolsSeller() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Planning Tools</h1>
      <p className="mb-4 text-gray-700">
        Make home design easier with SYANA Home’s Planning Tools! Whether you’re arranging a room or planning a full renovation, our digital tools help you visualize and organize your space.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Room Planners:</strong> Virtually arrange furniture and decor to see how everything fits before you buy.
        </li>
        <li>
          <strong>Measurement Guides:</strong> Get tips and guidelines to ensure your new furniture fits perfectly.
        </li>
        <li>
          <strong>Style Inspiration:</strong> Browse mood boards and design ideas created by our team.
        </li>
        <li>
          <strong>Shopping Lists:</strong> Save and manage your favorite products for easy purchasing.
        </li>
      </ul>
      <p className="mt-4 text-gray-600">
        Try our planning tools online or ask in-store for assistance. For help, contact{" "}
        <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">
          support@sayanahome.com
        </a>
        .
      </p>
    </div>
  );
}

export default PlanningToolsSeller;