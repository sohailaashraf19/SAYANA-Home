import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import Loader from "../../Loader";

// استيراد الصور من المجلد assets
import image1 from "../../../../../../assets/images/o1.png";
import image2 from "../../../../../../assets/images/o2.png";
import image3 from "../../../../../../assets/images/o3.png";

const ProfilePage = () => {
  const [user, setUser] = useState({
    name: "",
    email: "",
    phone: "",
    buyer_id: null,
  });
  const [orders, setOrders] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [saveLoading, setSaveLoading] = useState(false);
  const [success, setSuccess] = useState("");
  const navigate = useNavigate();
  const [viewStyle, setViewStyle] = useState("grid");
  // يتم استخدامه لتخزين البيانات المؤقتة أثناء التعديل
  const [editUser, setEditUser] = useState({
    name: "",
    email: "",
    phone: ""
  });

  // Fetch user profile and order history
  useEffect(() => {
    const fetchProfileAndOrders = async () => {
      const token = localStorage.getItem("token");
      if (!token) {
        setError("No authentication token found. Please log in.");
        setLoading(false);
        navigate("/buyer-login");
        return;
      }

      try {
        // Fetch profile
        const profileResponse = await axios.get(
          "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/profile",
          {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "application/json",
              Accept: "application/json",
            },
          }
        );

        const { name, email, phone, buyer_id } = profileResponse.data;
        setUser({ name, email, phone, buyer_id });

        // Fetch order history
        if (!buyer_id) {
          setError("Buyer ID not found. Unable to fetch orders.");
          setLoading(false);
          return;
        }

        const ordersResponse = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/history_order/${buyer_id}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "application/json",
              Accept: "application/json",
            },
          }
        );

        // Map API response to UI structure
        const mappedOrders = ordersResponse.data.map((order) => ({
          id: order.id,
          product: order.order_items[0]?.product.name || "Unknown Product",
          date: "May 9", // Placeholder; update with order.created_at if available
          status: order.status.replace("_", " ").toUpperCase(),
          mainImage: image1,
          extraImages: [image2, image3],
          price: `${parseFloat(order.total_price).toFixed(2)} EGP`,
          itemsCount: order.order_items.length,
          paymentStatus: order.payment_status.charAt(0).toUpperCase() + order.payment_status.slice(1),
        }));

        setOrders(mappedOrders);
        setLoading(false);
      } catch (err) {
        console.error("Error fetching data:", err);
        if (err.response) {
          if (err.response.status === 401) {
            setError("Unauthorized. Please log in again.");
            localStorage.removeItem("token");
            localStorage.removeItem("user");
            navigate("/buyer-login");
          } else if (err.response.status === 404) {
            setError("Profile or orders not found.");
          } else {
            setError("Failed to fetch data. Please try again.");
          }
        } else {
          setError("Network error. Please check your connection.");
        }
        setLoading(false);
      }
    };

    fetchProfileAndOrders();
  }, [navigate]);

  // افتح المودال مع ملء البيانات الحالية
  const openModalWithUserData = () => {
    setEditUser({
      name: user.name,
      email: user.email,
      phone: user.phone,
    });
    setIsModalOpen(true);
    setError("");
    setSuccess("");
  };

  // تحديث بيانات البروفايل فعلياً
  const handleSaveProfile = async () => {
    setSaveLoading(true);
    setError("");
    setSuccess("");
    const token = localStorage.getItem("token");
    try {
      const response = await axios.put(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/profile",
        {
          name: editUser.name,
          email: editUser.email,
          phone: editUser.phone,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            Accept: "application/json",
          },
        }
      );
      setSuccess("Profile updated successfully!");
      setIsModalOpen(false);
      // تحديث بيانات الصفحة فوراً بقيم التعديل
      setUser((prev) => ({
        ...prev,
        name: editUser.name,
        email: editUser.email,
        phone: editUser.phone,
      }));
    } catch (err) {
      if (err.response && err.response.data && err.response.data.errors) {
        const errors = err.response.data.errors;
        setError(Object.values(errors).flat().join(", "));
      } else {
        setError("Failed to update profile. Please try again.");
      }
    } finally {
      setSaveLoading(false);
    }
  };

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-8 bg-[#FBFBFB]">
      {loading ? (
        <div className="min-h-screen bg-[#FBFBFB] flex items-center justify-center">
          <Loader />
        </div>
      ) : error ? (
        <div className="text-center text-red-500">{error}</div>
      ) : (
        <div className="bg-white rounded-xl shadow p-6 flex items-center justify-between">
          <div>
            <h2 className="text-xl font-semibold">{user.name}</h2>
            <p className="text-gray-600">{user.email}</p>
            <p className="text-gray-600">{user.phone}</p>
          </div>
          <button
            className="bg-[#003664] text-white px-4 py-2 rounded-full hover:bg-opacity-80"
            onClick={openModalWithUserData}
          >
            Edit Profile
          </button>
        </div>
      )}

      {/* رسالة نجاح */}
      {success && (
        <div className="text-center text-green-600 font-semibold">{success}</div>
      )}

      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-xl shadow-lg w-96">
            <h3 className="text-xl font-bold mb-4">Edit Profile</h3>
            <div className="mb-3">
              <label className="block text-sm text-gray-700">Name</label>
              <input
                type="text"
                value={editUser.name}
                onChange={(e) => setEditUser({ ...editUser, name: e.target.value })}
                className="w-full border px-3 py-2 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-3">
              <label className="block text-sm text-gray-700">Email</label>
              <input
                type="email"
                value={editUser.email}
                onChange={(e) => setEditUser({ ...editUser, email: e.target.value })}
                className="w-full border px-3 py-2 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-4">
              <label className="block text-sm text-gray-700">Phone</label>
              <input
                type="text"
                value={editUser.phone}
                onChange={(e) => setEditUser({ ...editUser, phone: e.target.value })}
                className="w-full border px-3 py-2 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            {error && (
              <div className="text-red-500 mb-2 text-sm">{error}</div>
            )}
            <div className="flex justify-end space-x-2">
              <button
                className="px-4 py-2 bg-gray-300 rounded-full hover:bg-gray-400"
                onClick={() => setIsModalOpen(false)}
                disabled={saveLoading}
              >
                Cancel
              </button>
              <button
                className="px-4 py-2 bg-[#003664] text-white rounded-full hover:bg-opacity-80"
                onClick={handleSaveProfile}
                disabled={saveLoading}
              >
                {saveLoading ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}

      <div>
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-xl font-semibold">Orders</h3>
        </div>

        {orders.length === 0 ? (
          <div className="text-center text-gray-500">No orders found.</div>
        ) : (
          <div
            className={`grid ${viewStyle === "grid" ? "grid-cols-1 sm:grid-cols-2 lg:grid-cols-3" : "grid-cols-1"} gap-6`}
          >
            {orders.map((order) => (
              <div
                key={order.id}
                onClick={() => navigate(`/buyer/order/${order.id}`)}
                className={`bg-white p-4 rounded-xl shadow border transform transition-transform duration-300 ${
                  viewStyle === "grid" ? "hover:scale-105" : ""
                }`}
              >
                <div className="flex items-center justify-between mb-3">
                  <span className="text-green-600 font-semibold flex items-center">
                    ✔ {order.status}
                  </span>
                  <span className="text-sm text-gray-500">{order.date}</span>
                </div>
                <div className="grid grid-cols-3 gap-2 mb-4">
                  <img
                    src={order.mainImage}
                    alt="Main"
                    className="col-span-2 w-full h-32 object-cover rounded-md"
                  />
                  <div className="grid grid-rows-3 gap-2">
                    {order.extraImages.map((img, i) => (
                      <img
                        key={i}
                        src={img}
                        alt={`Extra ${i + 1}`}
                        className="w-full h-14 object-cover rounded-md"
                      />
                    ))}
                  </div>
                </div>
                <div className="mb-2 text-sm text-gray-700">
                  <strong>{order.itemsCount} items</strong>
                  <br />
                  Order #{order.id}
                </div>
                <div className="flex items-center justify-between mb-3">
                  <span className="text-[#201A23] font-semibold mt-2">{order.price}</span>
                  <span className="bg-gray-100 text-gray-600 text-sm px-2 py-1 rounded-full">
                    {order.paymentStatus}
                  </span>
                </div>
                <button className="w-full bg-[#003664] text-white px-4 py-2 rounded-full hover:bg-opacity-80">
                  Buy again
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ProfilePage;