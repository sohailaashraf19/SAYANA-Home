import React, { useState, useEffect } from "react";
import axios from "axios";
import { PencilSquareIcon, TrashIcon } from '@heroicons/react/24/outline';
import { motion, AnimatePresence } from "framer-motion";

// Spinner for loading
const spinnerVariants = {
  animate: {
    rotate: 360,
    scale: [1, 1.2, 1],
    transition: {
      rotate: { repeat: Infinity, duration: 1, ease: "linear" },
      scale: { repeat: Infinity, duration: 0.8, ease: "easeInOut" },
    },
  },
};

const WinkingEmoji = () => {
  return <div className="winking-emoji text-4xl">😉</div>;
};

const Offers = () => {
  const [offers, setOffers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // State for modal and form
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingOffer, setEditingOffer] = useState(null);
  const [formData, setFormData] = useState({
    title: "",
    discount: "",
    start_date: "",
    end_date: "",
  });

  // State for delete confirmation
  const [isDeleteConfirmOpen, setIsDeleteConfirmOpen] = useState(false);
  const [offerIdToDelete, setOfferIdToDelete] = useState(null);

  // Fetch offers with the NEW API (and guarantee offers is always array)
  const fetchOffers = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem("token");
      const seller_id = localStorage.getItem("seller_id");
      if (!token || !seller_id) {
        setError("Missing token or seller_id in localStorage");
        setLoading(false);
        return;
      }
      const response = await axios.get(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/selleroffers?seller_id=${seller_id}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      let data = response.data;
      if (!Array.isArray(data)) {
        if (data.offers && Array.isArray(data.offers)) {
          data = data.offers;
        } else {
          data = [];
        }
      }
      setOffers(data);
    } catch (err) {
      setError(err.message || "Failed to fetch offers");
      setOffers([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOffers();
  }, []);

  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  // Helper to format date as yyyy-MM-dd for <input type="date"/>
  const formatDateForInput = (dateStr) => {
    if (!dateStr) return "";
    if (dateStr.length === 10) return dateStr; // already yyyy-MM-dd
    // Try to handle ISO formats like 2025-07-01T00:00:00.000000Z
    return new Date(dateStr).toISOString().slice(0, 10);
  };

  // Modal open handler (fills all data for update)
  const openModal = (offer = null) => {
    setEditingOffer(offer);
    if (offer) {
      setFormData({
        title: offer.title || "",
        discount: offer.discount || "",
        start_date: formatDateForInput(offer.start_date),
        end_date: formatDateForInput(offer.end_date),
      });
    } else {
      setFormData({ title: "", discount: "", start_date: "", end_date: "" });
    }
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
    setEditingOffer(null);
  };

  // Show confirm tab before delete
  const handleDeleteOfferClick = (offerId) => {
    setOfferIdToDelete(offerId);
    setIsDeleteConfirmOpen(true);
  };

  // Confirm delete
  const handleConfirmDelete = async () => {
    if (!offerIdToDelete) return;
    try {
      const token = localStorage.getItem("token");
      await axios.delete(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/deletoffer/${offerIdToDelete}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setOffers(offers.filter(offer => offer.id !== offerIdToDelete));
      setIsDeleteConfirmOpen(false);
      setOfferIdToDelete(null);
    } catch (err) {
      console.error("Failed to delete offer:", err);
      setError("Failed to delete offer.");
      setIsDeleteConfirmOpen(false);
      setOfferIdToDelete(null);
    }
  };

  // Cancel delete
  const handleCancelDelete = () => {
    setIsDeleteConfirmOpen(false);
    setOfferIdToDelete(null);
  };

  // Submit offer (add or update)
  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem("token");
    const seller_id = localStorage.getItem("seller_id");

    if (!token || !seller_id) {
      setError("Missing token or seller_id in localStorage");
      return;
    }

    try {
      if (editingOffer) {
        // Use PUT with dynamic id for update
        await axios.put(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/updateoffer/${editingOffer.id}`,
          {
            title: formData.title,
            discount: formData.discount,
            start_date: formData.start_date,
            end_date: formData.end_date,
          },
          { headers: { Authorization: `Bearer ${token}` } }
        );
      } else {
        // Use the new API for adding offers for seller
        const body = {
          title: formData.title,
          discount: formData.discount,
          start_date: formData.start_date,
          end_date: formData.end_date,
          seller_id: seller_id,
        };

        await axios.post(
          "https://olivedrab-llama-457480.hostingersite.com/public/api/addnewofferseller",
          body,
          { headers: { Authorization: `Bearer ${token}` } }
        );
      }
      fetchOffers();
      closeModal();
    } catch (err) {
      console.error("Failed to submit offer:", err.response ? err.response.data : err);
      setError("Failed to submit offer. Please check console for details.");
    }
  };

  return (
    <div className="flex h-screen bg-[#FBFBFB]">
      <div className="flex-1 flex flex-col overflow-hidden">
        <header className="w-full p-4 bg-white shadow-md z-10 flex justify-between items-center">
          <div className="flex items-center gap-4">
            <h1 className="text-2xl font-bold text-gray-800">
              Wanna make offers ✨
            </h1>
            <WinkingEmoji />
          </div>
          {!loading && !error && (
            <button
              onClick={() => openModal()}
              className="px-6 py-2 bg-[#003664] text-white font-bold text-base shadow-lg transform transition-transform duration-300 hover:scale-110 hover:bg-indigo-700 focus:outline-none focus:ring-4 focus:ring-indigo-300 animate-pulse-professional"
              style={{ borderRadius: 30 }}
            >
              Add New Offer
            </button>
          )}
        </header>

        <main className="flex-1 p-16 overflow-y-auto">
          {/* Loader */}
          <AnimatePresence>
            {loading && (
              <motion.div
                className="flex justify-center items-center h-64"
                initial={{ opacity: 0, scale: 0.5 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.5 }}
                transition={{ duration: 0.4, ease: "easeInOut" }}
              >
                <motion.div
                  className="relative h-20 w-20"
                  variants={spinnerVariants}
                  animate="animate"
                >
                  <div
                    className="absolute inset-0 rounded-full"
                    style={{
                      background: "linear-gradient(45deg, #003664, #4a90e2)",
                      boxShadow: "0 0 15px rgba(0, 54, 100, 0.5)",
                    }}
                  />
                  <div className="absolute inset-2 rounded-full bg-gray-100" />
                </motion.div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Error State */}
          {error && (
            <motion.div
              className="text-center text-red-500 font-semibold"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.4 }}
            >
              {error}
            </motion.div>
          )}

          {/* Table */}
          {!loading && !error && Array.isArray(offers) && (
            <div className="w-7xl mx-auto animate-fade-in">
              <div className="overflow-x-auto bg-white rounded-lg shadow">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Title</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Discount</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Start Date</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">End Date</th>
                      <th className="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {offers.map((offer) => (
                      <tr key={offer.id} className="hover:bg-gray-50">
                        <td className="px-6 py-6 whitespace-nowrap"><div className="text-sm font-medium text-gray-900">{offer.title}</div></td>
                        <td className="px-6 py-6 whitespace-nowrap"><span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">{offer.discount}%</span></td>
                        <td className="px-6 py-6 whitespace-nowrap text-sm text-gray-500">{formatDateForInput(offer.start_date)}</td>
                        <td className="px-6 py-6 whitespace-nowrap text-sm text-gray-500">{formatDateForInput(offer.end_date)}</td>
                        <td className="px-6 py-6 whitespace-nowrap text-center text-lg font-medium">
                          <button
                            onClick={() => openModal(offer)}
                            className="black hover:text-indigo-900 mr-4"
                            title="Update Offer"
                            style={{ borderRadius: 30 }}
                          >
                            <PencilSquareIcon className="h-6 w-6" />
                          </button>
                          <button
                            onClick={() => handleDeleteOfferClick(offer.id)}
                            className="text-red-600 hover:text-red-900"
                            title="Delete Offer"
                            style={{ borderRadius: 30 }}
                          >
                            <TrashIcon className="h-6 w-6" />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </main>
      </div>

      {/* Delete confirmation modal */}
      {isDeleteConfirmOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-8 rounded-lg shadow-2xl w-full max-w-xs flex flex-col items-center">
            <h3 className="text-lg font-bold mb-4 text-center">Are you sure you want to delete this offer?</h3>
            <div className="flex gap-4 mt-4">
              <button
                onClick={handleConfirmDelete}
                className="px-4 py-2 bg-red-600 text-white rounded-full font-bold hover:bg-red-700 transition"
              >
                Yes, Delete
              </button>
              <button
                onClick={handleCancelDelete}
                className="px-4 py-2 bg-gray-300 text-gray-800 rounded-full font-bold hover:bg-gray-400 transition"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-8 rounded-lg shadow-2xl w-full max-w-md">
            <h2 className="text-2xl font-bold mb-6">{editingOffer ? "Update Offer" : "Add New Offer"}</h2>
            <form onSubmit={handleSubmit}>
              <div className="space-y-4">
                <input
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleFormChange}
                  placeholder="Title"
                  className="w-full p-2 border custom-radius focus-custom"
                  required
                />
                <input
                  type="number"
                  name="discount"
                  value={formData.discount}
                  onChange={handleFormChange}
                  placeholder="Discount (%)"
                  className="w-full p-2 border custom-radius focus-custom"
                  required
                />
                <div>
                  <label className="block text-sm font-medium text-gray-700">Start Date</label>
                  <input
                    type="date"
                    name="start_date"
                    value={formData.start_date}
                    onChange={handleFormChange}
                    className="w-full p-2 border custom-radius focus-custom"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">End Date</label>
                  <input
                    type="date"
                    name="end_date"
                    value={formData.end_date}
                    onChange={handleFormChange}
                    className="w-full p-2 border custom-radius focus-custom"
                    required
                  />
                </div>
              </div>
              <div className="mt-8 flex justify-end gap-4">
                <button
                  type="button"
                  onClick={closeModal}
                  className="py-2 px-4 bg-gray-300 hover:bg-gray-400 custom-radius"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="py-2 px-4 text-white custom-radius"
                  style={{
                    background: "#003664",
                    borderRadius: 30,
                    transition: "background 0.3s",
                  }}
                  onMouseOver={e => (e.currentTarget.style.background = "#002244")}
                  onMouseOut={e => (e.currentTarget.style.background = "#003664")}
                >
                  {editingOffer ? "Update" : "Save"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <style>
        {`
          .custom-radius {
            border-radius: 30px !important;
          }
          .focus-custom:focus {
            outline: none !important;
            border-color: #003664 !important;
            box-shadow: 0 0 0 2px #00366433 !important;
          }
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
          }
          .animate-fade-in {
            animation: fadeIn 0.5s ease-in-out;
          }
          @keyframes pulse-professional {
            0%, 100% {
              transform: scale(1);
              box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.7);
            }
            50% {
              transform: scale(1.05);
              box-shadow: 0 0 0 10px rgba(99, 102, 241, 0);
            }
          }
          .animate-pulse-professional {
            animation: pulse-professional 2.5s infinite;
          }
          @keyframes wink {
            0%, 90%, 100% {
              transform: scaleY(1);
            }
            95% {
              transform: scaleY(0.1);
            }
          }
          .winking-emoji {
            animation: wink 3s infinite;
          }
        `}
      </style>
    </div>
  );
};

export default Offers;