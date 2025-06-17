import React, { useState, useEffect } from "react";
import Sidebar from "../Sidebar/Sidebar";
import axios from "axios"; // Using axios for consistency

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedOrderId, setSelectedOrderId] = useState(null);

  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token"); // Getting the token

        if (!sellerId) {
          setError("No seller_id found in localStorage");
          setLoading(false);
          return;
        }

        if (!token) {
          setError("No token found in localStorage");
          setLoading(false);
          return;
        }

        // Using axios and adding the Authorization header
        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/getOrdersForSeller?seller_id=${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );
        
        const data = response.data;

        const transformedOrders = data.map((order) => ({
          id: order.id,
          buyerName: order.buyer.name,
          paymentStatus: order.payment_status,
          items: order.order_items.map((item) => {
            // --- KEY CHANGE: Correctly construct the image URL ---
            // We get the path from the API (e.g., "img/3.2.png")
            const imagePath = item.product.images?.[0]?.image_path;
            
            // We build the full URL by appending the path directly to the base domain
            const imageUrl = imagePath
              ? `https://olivedrab-llama-457480.hostingersite.com/${imagePath}`
              : "https://via.placeholder.com/128"; // Fallback image if none exists

            return {
              name: item.product.name,
              price: parseFloat(item.price),
              quantity: item.quantity,
              image: imageUrl, // Use the correctly constructed URL
            };
          }),
        }));

        setOrders(transformedOrders);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchOrders();
  }, []);

  const updatePaymentStatus = (id, newStatus) => {
    const updatedOrders = orders.map((order) =>
      order.id === id ? { ...order, paymentStatus: newStatus } : order
    );
    setOrders(updatedOrders);
    setSelectedOrderId(null);
  };

  const printInvoice = (order) => {
    const content = `
      <div>
        <h2>Order #${order.id}</h2>
        <p><strong>Buyer:</strong> ${order.buyerName}</p>
        <p><strong>Payment Status:</strong> ${order.paymentStatus}</p>
        <h3>Items:</h3>
        <ul>
          ${order.items
            .map(
              (item) =>
                `<li>${item.name} - ${item.quantity} x ${item.price} LE</li>`
            )
            .join("")}
        </ul>
        <p><strong>Total:</strong> ${order.items
          .reduce(
            (total, item) => total + item.price * item.quantity,
            0
          )
          .toFixed(2)} LE</p>
      </div>
    `;

    const win = window.open("", "Print", "width=600,height=600");
    win.document.write("<html><head><title>Invoice</title></head><body>");
    win.document.write(content);
    win.document.write("</body></html>");
    win.document.close();
    win.print();
  };

  if (loading) return <div className="flex justify-center p-6">Loading...</div>;
  if (error) return <div className="flex justify-center p-6 text-red-500">Error: {error}</div>;

  return (
    <div className="flex h-screen bg-[#FBFBFB]">
      <Sidebar />

      <main className="flex-1 p-6 overflow-y-scroll">
        <h1 className="text-3xl font-bold text-[#003664] mb-8">Orders</h1>

        <div className="grid grid-cols-1 gap-6">
          {orders.map((order) => {
            const totalPrice = order.items.reduce(
              (total, item) => total + item.price * item.quantity,
              0
            );

            return (
              <div
                key={order.id}
                className="bg-white p-6 rounded-2xl shadow-md hover:shadow-xl transition-all duration-300 transform hover:scale-[1.01]"
              >
                <div className="flex justify-between items-center mb-4">
                  <h2 className="text-xl font-semibold text-[#003664]">
                    Order #{order.id}
                  </h2>
                  <div className="flex gap-2">
                    <button
                      onClick={() => printInvoice(order)}
                      className="bg-[#003664] text-white px-4 py-1 rounded-full text-sm hover:opacity-90"
                    >
                      Print Invoice
                    </button>

                    <div className="relative">
                      <button
                        onClick={() =>
                          setSelectedOrderId(
                            selectedOrderId === order.id ? null : order.id
                          )
                        }
                        className="bg-[#003664] text-white px-4 py-1 rounded-full text-sm hover:opacity-90"
                      >
                        Change Status
                      </button>

                      {selectedOrderId === order.id && (
                        <div className="absolute right-0 mt-2 bg-white border rounded-md shadow-lg z-10">
                          {["Paid", "Pending", "Failed"].map((status) => (
                            <button
                              key={status}
                              onClick={() =>
                                updatePaymentStatus(order.id, status)
                              }
                              className="block w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-left"
                            >
                              {status}
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                <div className="flex gap-6 flex-wrap">
                  <div className="flex gap-3 flex-wrap">
                    {order.items.map((item, index) => (
                      <img
                        key={index}
                        src={item.image}
                        alt={item.name}
                        className="w-32 h-32 object-cover rounded-lg border border-gray-200"
                        onError={(e) => {
                          e.target.src = "https://via.placeholder.com/128";
                        }}
                      />
                    ))}
                  </div>

                  <div className="flex-1 min-w-[200px]">
                    <div className="text-sm font-semibold text-gray-700 mb-1">
                      Buyer: <span className="text-black">{order.buyerName}</span>
                    </div>

                    <div
                      className={`text-sm font-semibold mb-4 ${
                        order.paymentStatus === "Paid"
                          ? "text-green-600"
                          : order.paymentStatus === "Pending"
                          ? "text-yellow-500"
                          : "text-red-500"
                      }`}
                    >
                      Payment Status: {order.paymentStatus}
                    </div>

                    <h3 className="text-lg font-semibold text-gray-800 mb-2">
                      Order Items:
                    </h3>

                    <ul className="space-y-2">
                      {order.items.map((item, index) => (
                        <li
                          key={index}
                          className="flex justify-between text-gray-600 text-sm"
                        >
                          <span>{item.name}</span>
                          <span>
                            {item.quantity} x {item.price.toFixed(2)} LE
                          </span>
                        </li>
                      ))}
                    </ul>

                    <div className="mt-4 font-bold text-lg text-gray-800">
                      Total Price: {totalPrice.toFixed(2)} LE
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </main>
    </div>
  );
};

export default Orders;