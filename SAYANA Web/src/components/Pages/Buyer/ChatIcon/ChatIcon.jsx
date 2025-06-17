import React, { useState } from "react";
import { BsChatSquare } from "react-icons/bs";
import { RxCross2 } from "react-icons/rx";
import { useNavigate } from "react-router-dom";
import { MdSmartToy } from "react-icons/md";
import { FaEnvelope, FaCommentDots } from "react-icons/fa";

function ChatIcon() {
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);
  const [showFeedbackBox, setShowFeedbackBox] = useState(false);
  const [feedbackText, setFeedbackText] = useState("");

  const handleClick = () => {
    if (showFeedbackBox) {
      setShowFeedbackBox(false);
    } else {
      setIsOpen(!isOpen);
    }
  };

  const handleOptionClick = (path) => {
    if (path === "feedback") {
      setShowFeedbackBox(true);
      setIsOpen(false);
    } else {
      navigate(path);
      setIsOpen(false);
      setShowFeedbackBox(false);
    }
  };

  const handleSendFeedback = () => {
    if (feedbackText.trim() === "") {
      alert("Please write your feedback before sending.");
      return;
    }
    alert("Thank you for your feedback!");
    setFeedbackText("");
    setShowFeedbackBox(false);
  };

  const handleCloseFeedback = () => {
    setShowFeedbackBox(false);
  };

  const handleBackdropClick = (e) => {
    if (e.target.id === "feedback-backdrop") {
      setShowFeedbackBox(false);
    }
  };

  return (
    <div className="fixed bottom-24 right-8 z-50">
      <div
        className="w-16 h-16 bg-[#003664] text-white rounded-full flex items-center justify-center shadow-lg cursor-pointer hover:bg-opacity-80 transition-all duration-300"
        onClick={handleClick}
      >
        {isOpen || showFeedbackBox ? <RxCross2 size={20} /> : <BsChatSquare size={30} />}
      </div>

      {isOpen && (
        <div className="absolute flex flex-col gap-3 -top-12 right-12">
          <button
            className="w-32 py-2 bg-[#003664] text-white rounded-full shadow-md hover:bg-opacity-80 flex items-center justify-between gap-2 px-2 transform translate-x-[16px]"
            onClick={() => handleOptionClick("/chatbot")}
          >
            <span className="text-sm font-medium">Chatbot</span>
            <div className="w-8 h-8 bg-white rounded-full flex items-center justify-center text-[#003664]">
              <MdSmartToy size={18} />
            </div>
          </button>
          <button
            className="w-36 py-2 bg-[#003664] text-white rounded-full shadow-md hover:bg-opacity-80 flex items-center justify-between gap-2 px-2 transform translate-x-[-24px]"
            onClick={() => handleOptionClick("/buyer/contactus")}
          >
            <span className="text-sm font-medium">Contact Us</span>
            <div className="w-8 h-8 bg-white rounded-full flex items-center justify-center text-[#003664]">
              <FaEnvelope size={16} />
            </div>
          </button>
          <button
            className="w-32 py-2 bg-[#003664] text-white rounded-full shadow-md hover:bg-opacity-80 flex items-center justify-between gap-2 px-2 transform translate-x-[16px]"
            onClick={() => handleOptionClick("feedback")}
          >
            <span className="text-sm font-medium">Feedback</span>
            <div className="w-8 h-8 bg-white rounded-full flex items-center justify-center text-[#003664]">
              <FaCommentDots size={16} />
            </div>
          </button>
        </div>
      )}

      {showFeedbackBox && (
        <div
          id="feedback-backdrop"
          className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50 animate-fadeIn"
          onClick={handleBackdropClick}
        >
          <div className="w-[600px] p-8 bg-white rounded-xl shadow-2xl border border-gray-300 relative animate-scaleIn">
            {/* Close button */}
            <button
              onClick={handleCloseFeedback}
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
                onClick={handleCloseFeedback}
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

export default ChatIcon;
