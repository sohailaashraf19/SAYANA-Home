import React, { useState, useEffect } from "react";
import axios from "axios";
import Loader from "../../Buyer/Home/Loader";

const Profile = () => {
  const [profile, setProfile] = useState({
    brand_name: "",
    email: "",
    phone: "",
  });
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [error, setError] = useState("");

  // Fetch profile data on component mount
  useEffect(() => {
    const fetchProfile = async () => {
      try {
        setLoading(true);
        setError("");

        const token = localStorage.getItem("token"); // ← حطي التوكن هنا بعد تسجيل الدخول

        const response = await axios.get(
          "https://olivedrab-llama-457480.hostingersite.com/public/api/seller/profile",
          {
            headers: {
              Authorization: `Bearer ${token}`,
              Accept: "application/json",
            },
          }
        );

        setProfile(response.data);
      } catch (err) {
        console.error(err);
        setError("Failed to load profile data");
      } finally {
        setLoading(false);
      }
    };

    fetchProfile();
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setProfile((prev) => ({ ...prev, [name]: value }));
  };

  const handleSaveProfile = () => {
    setIsModalOpen(false);
    alert("Profile updated successfully");
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#FBFBFB] flex items-center justify-center">
        <Loader />
      </div>
    );
  }

  if (error || !profile) {
    return <div className="text-center text-red-500 p-6">{error || "No profile data found."}</div>;
  }

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-8 bg-[#FBFBFB]">
      {/* Profile Section */}
      <div className="bg-white rounded-xl shadow p-6 flex items-center justify-between">
        <div>
          <h2 className="text-xl font-semibold">{profile.brand_name}</h2>
          <p className="text-gray-600">{profile.email}</p>
          <p className="text-gray-600">{profile.phone}</p>
        </div>
        <button
          className="bg-[#003664] text-white px-4 py-2 rounded-full hover:bg-opacity-80"
          onClick={() => setIsModalOpen(true)}
        >
          Edit Profile
        </button>
      </div>

      {/* Edit Profile Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-96">
            <h3 className="text-xl font-bold mb-4">Edit Profile</h3>
            <div className="mb-3">
              <label className="block text-sm text-gray-700">Brand Name</label>
              <input
                type="text"
                name="brand_name"
                value={profile.brand_name || ""}
                onChange={handleInputChange}
                className="w-full border px-3 py-2 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-3">
              <label className="block text-sm text-gray-700">Email</label>
              <input
                type="email"
                name="email"
                value={profile.email || ""}
                onChange={handleInputChange}
                className="w-full border px-3 py-2 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-4">
              <label className="block text-sm text-gray-700">Phone</label>
              <input
                type="text"
                name="phone"
                value={profile.phone || ""}
                onChange={handleInputChange}
                className="w-full border px-3 py-2 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="flex justify-end space-x-2">
              <button
                className="px-4 py-2 bg-gray-300 rounded-full hover:bg-gray-400"
                onClick={() => setIsModalOpen(false)}
              >
                Cancel
              </button>
              <button
                className="px-4 py-2 bg-[#003664] text-white rounded-full hover:bg-opacity-80"
                onClick={handleSaveProfile}
              >
                Save
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Profile;
