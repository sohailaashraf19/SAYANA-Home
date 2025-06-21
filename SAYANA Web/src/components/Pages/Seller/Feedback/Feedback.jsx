import React, { useState } from "react";

const Feedback = () => {
  const [feedback, setFeedback] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage("");
    setLoading(true);

    try {
      const response = await fetch("https://olivedrab-llama-457480.hostingersite.com/public/api/feedback", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          note: feedback,
          seller_id: 100, // عدلها لو عندك seller_id ديناميكي
        }),
      });

      const data = await response.json();

      if (response.ok) {
        setMessage(data.message || "Feedback submitted successfully");
        setFeedback("");
      } else {
        setMessage(data.message || "Something went wrong. Please try again.");
      }
    } catch (error) {
      setMessage("Network error. Please try again.");
    }
    setLoading(false);
  };

  return (
    <div className="flex min-h-screen bg-[#FBFBFB]">
      <main className="flex-1 flex flex-col items-center justify-center p-8">
        <div className="bg-white rounded-3xl shadow-xl max-w-lg w-full mx-auto px-8 py-10 flex flex-col items-center">
          <h1 className="text-2xl md:text-3xl font-bold text-[#003664] mb-4 text-center">
            We value your feedback!
          </h1>
          <p className="mb-8 text-gray-500 text-center">
            Please let us know your thoughts, suggestions, or concerns regarding our service.
          </p>
          <form className="w-full flex flex-col gap-4" onSubmit={handleSubmit}>
            <textarea
              placeholder="Your Feedback"
              required
              rows={5}
              className="w-full p-3 rounded-xl border border-gray-200 focus:outline-none focus:border-[#003664] transition resize-none"
              value={feedback}
              onChange={(e) => setFeedback(e.target.value)}
              disabled={loading}
            />
            <button
              type="submit"
              className="mt-4 py-3 rounded-full bg-[#003664] text-white font-semibold hover:bg-[#002244] transition"
              disabled={loading}
            >
              {loading ? "Submitting..." : "Submit Feedback"}
            </button>
          </form>
          {message && (
            <div className="mt-4 text-center text-green-600 font-medium">{message}</div>
          )}
        </div>
      </main>
    </div>
  );
};

export default Feedback;