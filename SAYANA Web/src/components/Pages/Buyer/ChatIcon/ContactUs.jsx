import React, { useState } from "react";
import { RxCross2 } from "react-icons/rx";
import { useNavigate } from "react-router-dom";
import con2 from "../../../../assets/con2.jpg";
import fed2 from "../../../../assets/fed2.jpg";

function ContactUs() {
  const [showFeedbackBox, setShowFeedbackBox] = useState(false);
  const [feedbackText, setFeedbackText] = useState("");
  const navigate = useNavigate();


  const handleSendFeedback = () => {
    if (feedbackText.trim() === "") {
      alert("Please write your feedback before sending.");
      return;
    }
    alert("Thank you for your feedback!");
    setFeedbackText("");
    setShowFeedbackBox(false);
  };

  return (
    <div className="flex flex-col py-12 px-6 md:px-12 max-w-5xl mx-auto">
      {/* Title */}
      <h1 className="text-4xl font-bold text-[#003664] mb-8 text-left">Contact Us</h1>

      {/* Images + Text */}
      <div className="flex flex-col md:flex-row gap-8 mb-12">
        {/* Left image + text */}
        <div className="flex-1 flex flex-col items-center">
        <img src={con2} alt="Assistance" className="rounded-lg mb-4  h-[225px] object-cover" />


          <p className="text-center text-base text-gray-700">
            Questions, Concerns, or Assistance? Contact us and we will be happy to assist.
          </p>
        </div>

        {/* Right image + text */}
        <div className="flex-1 flex flex-col items-center">
        <img src={fed2} alt="Assistance" className="rounded-lg mb-4" />
          <p className="text-center text-base text-gray-700">
            We would love your feedback, Let us know what you think!
          </p>
        </div>
      </div>

      {/* Buttons under images */}
      <div className="flex flex-col md:flex-row gap-8 mb-12">
        {/* Left buttons */}
        <div className="flex-1 flex flex-col items-start gap-6">
          <button 
            onClick={() => navigate("/buyer/emailus")}
            className="px-6 py-2 bg-[#003664] text-white rounded-full text-sm hover:bg-[#002a4a] transition">
            Email Us
          </button>
          <button 
            onClick={() => navigate("/chatbot")}
            className="px-6 py-2 bg-[#003664] text-white rounded-full text-sm hover:bg-[#002a4a] transition">
            Chat with Us
          </button>
          <div className="mt-2 text-lg font-semibold text-gray-800">
            Hotline: 16576
          </div>
        </div>

        {/* Right button */}
        <div className="flex-1 flex flex-col items-start gap-4">
          <button
            className="px-6 py-2 bg-[#003664] text-white rounded-full text-sm hover:bg-[#002a4a] transition"
            onClick={() => setShowFeedbackBox(true)}
          >
            Feedback
          </button>
        </div>
      </div>

      {/* Follow us */}
      <div className="border-t border-gray-300 pt-8 text-left">
        <h3 className="text-xl font-semibold text-[#003664] mb-8">Follow us on</h3>
        <p className="text-gray-600 text-sm">Facebook | Instagram | YouTube</p>
      </div>

      {/* Feedback Box */}
      {showFeedbackBox && (
        <div
          className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50"
          onClick={(e) => {
            if (e.target.id === "feedback-backdrop") setShowFeedbackBox(false);
          }}
          id="feedback-backdrop"
        >
          <div className="w-[600px] p-8 bg-white rounded-xl shadow-2xl border border-gray-300 relative">
            <button
              onClick={() => setShowFeedbackBox(false)}
              className="absolute top-3 right-3 text-gray-500 hover:text-gray-700 text-xl"
            >
              <RxCross2 />
            </button>

            <h3 className="text-[#003664] font-bold mb-5 text-center text-2xl">
              Give Us Your Feedback
            </h3>

            <textarea
              className="w-full h-48 p-4 border border-gray-300 rounded-lg resize-none focus:outline-none focus:ring-2 focus:ring-[#003664] text-base"
              placeholder="Please tell us about your experience. The more details you share, the better.."
              value={feedbackText}
              onChange={(e) => setFeedbackText(e.target.value)}
            />
            <div className="flex justify-end space-x-4 mt-6">
              <button
                onClick={() => setShowFeedbackBox(false)}
                className="px-6 py-2 bg-gray-300 rounded-full hover:bg-gray-400 transition text-base"
              >
                Close
              </button>
              <button
                onClick={handleSendFeedback}
                className="px-6 py-2 bg-[#003664] text-white rounded-full hover:bg-[#002a4a] transition text-base"
              >
                Send
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default ContactUs;
