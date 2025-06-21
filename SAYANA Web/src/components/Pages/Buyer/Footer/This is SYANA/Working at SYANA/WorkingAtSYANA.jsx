import React from "react";

function WorkingAtSYANA() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Working at SYANA</h1>
      <p className="mb-4 text-gray-700">
        At SYANA Home, our people are at the heart of everything we do. We are committed to creating a supportive, inclusive, and inspiring workplace where everyone can grow and succeed.
      </p>
      <ul className="list-disc pl-6 mb-4 text-gray-800 space-y-2">
        <li>
          <strong>Our Culture:</strong> We value teamwork, creativity, and diversity, and strive to maintain an open and positive atmosphere.
        </li>
        <li>
          <strong>Career Development:</strong> We offer training, mentorship, and growth opportunities for all employees.
        </li>
        <li>
          <strong>Work-Life Balance:</strong> We believe in flexibility and supporting our team's well-being inside and outside of work.
        </li>
        <li>
          <strong>Join Us:</strong> Interested in being part of our team? Check our careers page or send your CV to{" "}
          <a href="mailto:careers@sayanahome.com" className="text-[#003664] underline">
            careers@sayanahome.com
          </a>
          .
        </li>
      </ul>
    </div>
  );
}

export default WorkingAtSYANA;