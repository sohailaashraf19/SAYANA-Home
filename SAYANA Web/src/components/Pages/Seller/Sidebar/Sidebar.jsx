import React, { useState, useEffect } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import {
  HomeIcon,
  CubeIcon,
  ShoppingCartIcon,
  MegaphoneIcon,
  ChatBubbleBottomCenterTextIcon,
  QuestionMarkCircleIcon,
} from "@heroicons/react/24/outline";
import { ArrowRightOnRectangleIcon } from "@heroicons/react/24/solid";

const Sidebar = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [showConfirm, setShowConfirm] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [sellerName, setSellerName] = useState("..."); // default name

  useEffect(() => {
    const fetchSellerProfile = async () => {
      const token = localStorage.getItem("token");
      if (!token) {
        setError("No token found");
        return;
      }

      try {
        const response = await fetch("https://olivedrab-llama-457480.hostingersite.com/public/api/seller/profile", {
          headers: {
            "Authorization": `Bearer ${token}`,
          },
        });

        const data = await response.json();
        if (response.ok) {
          // لو في بيانات بنجاح
          setSellerName(data.brand_name || "Homei");
        } else {
          setError("Failed to fetch profile");
        }
      } catch (err) {
        setError("Network error");
        console.error("Error fetching profile:", err);
      }
    };

    fetchSellerProfile();
  }, []);

  const isActive = (path) => location.pathname === path;

  const linkClass = (path) =>
    `flex items-center gap-2 py-2 px-4 rounded-full transition-all duration-300 ${
      isActive(path)
        ? "bg-[#FBFBFB] text-[#003664] shadow"
        : "text-white hover:bg-[#FBFBFB] hover:text-[#003664] hover:shadow"
    }`;

  const handleLogout = () => {
    setError("");
    setShowConfirm(true);
  };

  const confirmLogout = async () => {
    setError("");
    setLoading(true);

    try {
      const token = localStorage.getItem("token");
      if (!token) {
        setError("No token found. Please log in again.");
        setLoading(false);
        setShowConfirm(false);
        navigate("/login");
        return;
      }

      const response = await fetch("https://olivedrab-llama-457480.hostingersite.com/public/api/seller/logout", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
      });

      const data = await response.json();

      if (response.ok) {
        localStorage.removeItem("token");
        localStorage.removeItem("seller");
        console.log("Logout successful:", data);
        setShowConfirm(false);
        navigate("/login");
      } else {
        setError(data.message || "An error occurred during logout.");
      }
    } catch (err) {
      setError("Failed to connect to the server. Please try again.");
      console.error("Error:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <aside className="w-64 h-screen bg-[#003664] text-white p-6 flex flex-col justify-between rounded-r-full">
        <div>
          <h1 className="text-2xl font-bold mt-10 mb-10">{sellerName}</h1>

          <nav className="space-y-5">
            <Link to="/home" className={linkClass("/home")}>
              <HomeIcon className="w-5 h-5" />
              Dashboard
            </Link>
            <Link to="/products" className={linkClass("/products")}>
              <CubeIcon className="w-5 h-5" />
              Products
            </Link>
            <Link to="/orders" className={linkClass("/orders")}>
              <ShoppingCartIcon className="w-5 h-5" />
              Orders
            </Link>
            <Link to="/offers" className={linkClass("/offers")}>
              <MegaphoneIcon className="w-5 h-5" />
              Offers
            </Link>
            <Link to="/feedback" className={linkClass("/feedback")}>
              <ChatBubbleBottomCenterTextIcon className="w-5 h-5" />
              Feedback
            </Link>
            <Link to="/help" className={linkClass("/help")}>
              <QuestionMarkCircleIcon className="w-5 h-5" />
              Help
            </Link>
          </nav>
        </div>

        <div className="mt-auto mb-32">
          <button onClick={handleLogout} className={linkClass("/log_out")} disabled={loading}>
            <ArrowRightOnRectangleIcon className="w-5 h-5" />
            {loading ? "Logging out..." : "Log Out"}
          </button>
        </div>
      </aside>
      {showConfirm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
          <div className="bg-white p-6 rounded-lg shadow-lg text-center w-96">
            <h2 className="text-xl font-semibold text-[#003664] mb-4">Confirm Logout</h2>
            <p className="text-gray-700 mb-6">Are you sure you want to log out?</p>
            {error && (
              <div className="text-red-500 text-sm mb-4">
                {error}
              </div>
            )}
            <div className="flex justify-center gap-4">
              <button
                onClick={() => setShowConfirm(false)}
                className="px-4 py-2 bg-gray-300 text-gray-800 rounded-full hover:bg-gray-400"
                disabled={loading}
              >
                Cancel
              </button>
              <button
                onClick={confirmLogout}
                className="px-4 py-2 bg-[#003664] text-white rounded-full hover:bg-opacity-90"
                disabled={loading}
              >
                {loading ? "Confirm" : "Confirm"}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Sidebar;
