import { useNavigate } from "react-router-dom";
import { BellIcon } from "@heroicons/react/24/outline";

const NotificationDropdown = ({ onClose }) => {
  const navigate = useNavigate();

  const notifications = [
    { id: 1, message: "New offer on Stone Texture Sink 15% OFF " },
    { id: 2, message: "Woven Art Wall Set is available again " },
    { id: 3, message: "Your order has been shipped  🚚 " },
  ];

  return (
    <div className="w-64 bg-white rounded-lg shadow-lg z-50 py-2 text-sm">
      {notifications.length > 0 ? (
        <>
          {notifications.map((note) => (
            <div
              key={note.id}
              className="px-4 py-2 hover:bg-gray-100 text-gray-700 cursor-default flex items-start"
            >
              <BellIcon className="w-5 h-5 mr-2 mt-1 text-gray-600" />
              <span>{note.message}</span>
            </div>
          ))}

          <div className="border-t mt-2 pt-2 px-4 flex flex-col space-y-2">
            <button
              className="text-blue-600 hover:underline text-left"
              onClick={() => {
                onClose();
                navigate("/notifications"); // Ensure this page exists in your app
              }}
            >
              View all notifications
            </button>
            <button
              className="text-gray-500 hover:underline text-left text-xs"
              onClick={() => {
                // You can add logic to mark them as read here
                onClose();
              }}
            >
              Mark all as read
            </button>
          </div>
        </>
      ) : (
        <div className="px-4 py-2 text-gray-500">No notifications at the moment</div>
      )}
    </div>
  );
};

export default NotificationDropdown;