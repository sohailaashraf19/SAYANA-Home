import React, { useState } from "react";
import con2 from "../../../../assets/con2.jpg";

function EmailUs() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    subject: "",
    message: "",
    file: null,
  });

  const handleChange = (e) => {
    const { name, value, files } = e.target;
    if (name === "file") {
      setFormData({ ...formData, file: files });
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Form submitted:", formData);
    alert("Your message has been sent!");
  };

  return (
    <div className="max-w-4xl mx-auto p-6 md:p-12 flex flex-col">
      {/* Title */}
      <div className="mb-6">
        <h1 className="text-4xl font-bold text-[#003664] text-left">Email Us</h1>
      </div>

      {/* Image and Form */}
      <div className="flex flex-col items-center">
        {/* Image */}
        <img
          src={con2}
          alt="Contact"
          className="rounded-lg shadow-lg w-full max-w-md mx-auto h-auto mb-8"
        />

        {/* Form */}
        <div className="w-full max-w-lg">
          <form onSubmit={handleSubmit} className="space-y-5">
            <input
              type="text"
              name="name"
              placeholder="Name"
              value={formData.name}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#003664]"
            />

            <input
              type="email"
              name="email"
              placeholder="Email"
              value={formData.email}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#003664]"
            />

            <input
              type="tel"
              name="phone"
              placeholder="Phone"
              value={formData.phone}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#003664]"
            />

            <input
              type="text"
              name="subject"
              placeholder="Subject"
              value={formData.subject}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#003664]"
            />

            <textarea
              name="message"
              placeholder="Message"
              value={formData.message}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 h-32 border border-gray-300 rounded-lg resize-none focus:outline-none focus:ring-2 focus:ring-[#003664]"
            />

            <input
              type="file"
              name="file"
              onChange={handleChange}
              multiple
              accept="image/*,video/*,.pdf"
              className="w-full"
            />

            {/* Notes */}
            <div className="text-sm text-gray-600 space-y-1">
              <p>* You can upload multiple files</p>
              <p>* Supported files are Images/Videos/PDF</p>
              <p>* File should not exceed 5MB in size</p>
            </div>

            {/* Send Button */}
            <button
              type="submit"
              className="w-full px-6 py-2 bg-[#003664] text-white rounded-full hover:bg-[#002a4a] transition text-base"
            >
              Send Message
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}

export default EmailUs;
