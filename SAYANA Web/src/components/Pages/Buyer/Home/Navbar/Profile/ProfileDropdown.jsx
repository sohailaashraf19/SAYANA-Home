import { useNavigate } from "react-router-dom";
import { UserIcon, ArrowRightOnRectangleIcon } from "@heroicons/react/24/outline";
import axios from "axios";

const ProfileDropdown = ({ onClose }) => {
  const navigate = useNavigate();

  const handleLogout = async () => {
    const token = localStorage.getItem("token"); // Retrieve token from localStorage
    if (!token) {
      console.error("Token not found in localStorage");
      localStorage.removeItem("user"); // Clear user data even if token is missing
      navigate("/buyer-login");
      return;
    }

    try {
      await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/logout",
        {},
        {
          headers: {
            Authorization: `Bearer ${token}`, // Send token in the Authorization header
          },
        }
      );
      localStorage.removeItem("token"); // Clear the token from localStorage
      localStorage.removeItem("user"); // Clear the user data (name, email, phone, role)
      onClose();
      navigate("/buyer-login");
    } catch (error) {
      console.error("Error logging out:", error);
      localStorage.removeItem("token"); // Clear token even on error for safety
      localStorage.removeItem("user"); // Clear user data even on error for safety
      onClose();
      navigate("/buyer-login");
    }
  };

  return (
    <div className="w-40 bg-white rounded-lg shadow-lg z-50 py-2">
      {/* View Profile */}
      <button
        className="flex items-center w-full px-4 py-2 hover:bg-gray-100 text-sm text-gray-700"
        onClick={() => {
          onClose();
          navigate("/buyer/profile"); // Navigate to profile page
        }}
      >
        <UserIcon className="w-5 h-5 mr-2 text-gray-600" />
        View Profile
      </button>

      {/* Log Out */}
      <button
        className="flex items-center w-full px-4 py-2 hover:bg-gray-100 text-sm text-gray-700"
        onClick={handleLogout}
      >
        <ArrowRightOnRectangleIcon className="w-5 h-5 mr-2 text-gray-600" />
        Log Out
      </button>
    </div>
  );
};

export default ProfileDropdown; 