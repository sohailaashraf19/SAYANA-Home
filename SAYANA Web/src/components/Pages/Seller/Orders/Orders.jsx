import React, { useState, useEffect } from "react";
import axios from "axios";
import { motion, AnimatePresence } from "framer-motion";

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

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedOrderId, setSelectedOrderId] = useState(null);
  const [selectedItemId, setSelectedItemId] = useState(null);
  const [statusError, setStatusError] = useState(null);
  const [updatingStatus, setUpdatingStatus] = useState(null);
  const [updatingItemStatus, setUpdatingItemStatus] = useState(null);

  const fetchOrders = async () => {
    try {
      const sellerId = localStorage.getItem("seller_id");
      const token = localStorage.getItem("token");

      if (!sellerId) {
        throw new Error("No seller_id found in localStorage");
      }

      if (!token) {
        throw new Error("No token found in localStorage");
      }

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
        buyerId: order.buyer_id,
        orderStatus: order.status,
        paymentStatus: order.payment_status,
        paymentMethod: order.payment_method,
        offer: parseFloat(order.offer || 0),
        sellerTotal: parseFloat(order.seller_total || 0),
        notes: order.notes,
        addressId: order.address_id,
        paymentImg: order.payment_img,
        items: order.order_items.map((item) => {
          const imagePath = item.product.images?.[0]?.image_path;
          const imageUrl = imagePath
            ? `https://olivedrab-llama-457480.hostingersite.com/${imagePath}`
            : "https://via.placeholder.com/128";

          return {
            id: item.id,
            productId: item.product_id,
            name: item.product.name,
            description: item.product.description,
            price: parseFloat(item.price),
            quantity: item.quantity,
            status: item.status,
            sellerId: item.saller_id,
            image: imageUrl,
            productDetails: {
              category_id: item.product.category_id,
              sales_count: item.product.sales_count,
              color: item.product.color,
              type: item.product.type,
              discount: item.product.discount,
              reportcount: item.product.reportcount,
            }
          };
        }),
      }));

      setOrders(transformedOrders);
      console.log("Fetched orders:", transformedOrders);
    } catch (err) {
      console.error("Fetch orders error:", err);
      setError(err.message || "Failed to fetch orders");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, []);

  const updateOrderStatus = async (orderId, newStatus) => {
    const sellerId = localStorage.getItem("seller_id");
    const token = localStorage.getItem("token");

    if (!sellerId || !token) {
      setStatusError("Authentication required");
      setTimeout(() => setStatusError(null), 3000);
      return;
    }

    setUpdatingStatus(orderId);
    const requestBody = {
      seller_id: parseInt(sellerId),
      order_id: orderId,
      status: newStatus,
    };

    try {
      const response = await axios.put(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/orderupdate-status`,
        requestBody,
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
        }
      );

      if (response.status === 200) {
        setOrders((prevOrders) =>
          prevOrders.map((order) =>
            order.id === orderId ? { ...order, orderStatus: newStatus } : order
          )
        );
        setSelectedOrderId(null);
        await fetchOrders();
      }
    } catch (err) {
      console.error("Error updating order status:", err);
      setStatusError(err.response?.data?.message || "Failed to update order status");
      setTimeout(() => setStatusError(null), 3000);
    } finally {
      setUpdatingStatus(null);
    }
  };

  const updateItemStatus = async (itemId, orderId, newStatus) => {
    const sellerId = localStorage.getItem("seller_id");
    const token = localStorage.getItem("token");

    if (!sellerId || !token) {
      setStatusError("Authentication required");
      setTimeout(() => setStatusError(null), 3000);
      return;
    }

    setUpdatingItemStatus(itemId);
    const requestBody = {
      seller_id: parseInt(sellerId),
      order_id: orderId,
      item_id: itemId,
      status: newStatus,
    };

    try {
      const response = await axios.put(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/orderupdate-status`,
        requestBody,
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
        }
      );

      if (response.status === 200) {
        setOrders((prevOrders) =>
          prevOrders.map((order) => ({
            ...order,
            items: order.items.map((item) =>
              item.id === itemId ? { ...item, status: newStatus } : item
            )
          }))
        );
        setSelectedItemId(null);
        await fetchOrders();
      }
    } catch (err) {
      console.error("Error updating item status:", err);
      setStatusError(err.response?.data?.message || "Failed to update item status");
      setTimeout(() => setStatusError(null), 3000);
    } finally {
      setUpdatingItemStatus(null);
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case "complete":
        return "text-green-600";
      case "not_ready":
        return "text-yellow-500";
      case "cancelled":
        return "text-blue-500";
      case "shipped":
        return "text-purple-500";
      case "refund":
        return "text-red-500";
      default:
        return "text-gray-500";
    }
  };

  const printInvoice = (order) => {
    const content = `
      <div style="font-family: Arial, sans-serif; padding: 20px;">
        <h2>Order #${order.id}</h2>
        <p><strong>Buyer:</strong> ${order.buyerName}</p>
        <p><strong>Order Status:</strong> ${order.orderStatus}</p>
        <p><strong>Payment Status:</strong> ${order.paymentStatus}</p>
        <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
        <p><strong>Offer:</strong> ${order.offer.toFixed(2)} LE</p>
        <p><strong>Seller Total:</strong> ${order.sellerTotal.toFixed(2)} LE</p>
        ${order.notes ? `<p><strong>Notes:</strong> ${order.notes}</p>` : ''}
        <h3>Items:</h3>
        <ul>
          ${order.items
            .map(
              (item) =>
                `<li>
                  <strong>${item.name}</strong><br>
                  Quantity: ${item.quantity} x ${item.price.toFixed(2)} LE<br>
                  Status: ${item.status}<br>
                  Total: ${(item.quantity * item.price).toFixed(2)} LE
                </li>`
            )
            .join("")}
        </ul>
        <p><strong>Items Total:</strong> ${order.items
          .reduce(
            (total, item) => total + item.price * item.quantity,
            0
          )
          .toFixed(2)} LE</p>
      </div>
    `;

    const win = window.open("", "Print", "width=800,height=600");
    win.document.write("<html><head><title>Invoice</title></head><body>");
    win.document.write(content);
    win.document.write("</body></html>");
    win.document.close();
    win.print();
  };

  return (
    <div className="flex h-screen bg-[#FBFBFB]">
      <main className="flex-1 p-6 overflow-y-scroll">
        <h1 className="text-3xl font-bold text-[#003664] mb-8">Orders</h1>

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

        {error && !loading && (
          <div className="flex justify-center p-6 text-red-500">Error: {error}</div>
        )}

        {statusError && (
          <div className="mb-4 text-red-500 text-sm text-center">{statusError}</div>
        )}

        {!loading && !error && (
        <div className="grid grid-cols-1 gap-6">
          {orders.map((order) => {
            const itemsTotal = order.items.reduce(
              (total, item) => total + item.price * item.quantity,
              0
            );

            return (
              <div
                key={order.id}
                className="bg-white p-6 rounded-2xl shadow-md hover:shadow-xl transition-all duration-300"
              >
                {/* Order Header */}
                <div className="flex justify-between items-center mb-6">
                  <div>
                    <h2 className="text-xl font-semibold text-[#003664] mb-2">
                      Order #{order.id}
                    </h2>
                    <div className="text-sm text-gray-600">
                      <span className="font-medium">Buyer:</span> {order.buyerName}
                    </div>
                  </div>
                  
                  <div className="flex gap-2">
                    <button
                      onClick={() => printInvoice(order)}
                      className="bg-[#003664] text-white px-4 py-2 rounded-full text-sm hover:opacity-90"
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
                        className="bg-[#003664] text-white px-4 py-2 rounded-full text-sm hover:opacity-90"
                        disabled={updatingStatus === order.id}
                      >
                        {updatingStatus === order.id ? "Updating..." : "Change Order Status"}
                      </button>

                      {selectedOrderId === order.id && (
                        <div className="absolute right-0 mt-2 bg-white border rounded-md shadow-lg z-10 min-w-[150px]">
                          {["not_ready", "cancelled", "shipped", "complete", "refund"].map((status) => (
                            <button
                              key={status}
                              onClick={() => updateOrderStatus(order.id, status)}
                              className="block w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-left capitalize"
                              disabled={updatingStatus === order.id}
                            >
                              {status}
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                {/* Order Info */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6 p-4 bg-gray-50 rounded-lg">
                  
                  <div>
                    <span className="text-sm font-medium text-gray-600">Payment Status:</span>
                    <div className={`font-semibold ${getStatusColor(order.paymentStatus)}`}>
                      {order.paymentStatus}
                    </div>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-600">Payment Method:</span>
                    <div className="font-semibold">{order.paymentMethod}</div>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-600">Offer:</span>
                    <div className="font-semibold">{order.offer.toFixed(2)} LE</div>
                  </div>
                </div>

                {order.notes && (
                  <div className="mb-4 p-3 bg-blue-50 rounded-lg">
                    <span className="text-sm font-medium text-gray-600">Notes:</span>
                    <div className="text-sm">{order.notes}</div>
                  </div>
                )}

                {/* Order Items */}
                <div className="space-y-4">
                  <h3 className="text-lg font-semibold text-gray-800">Order Items:</h3>
                  
                  {order.items.map((item) => (
                    <div key={item.id} className="border rounded-lg p-4 bg-gray-50">
                      <div className="flex gap-4">
                        {/* Product Image */}
                        <img
                          src={item.image}
                          alt={item.name}
                          className="w-24 h-24 object-cover rounded-lg border"
                          onError={(e) => {
                            e.target.src = "https://via.placeholder.com/96";
                          }}
                        />

                        {/* Product Details */}
                        <div className="flex-1">
                          <h4 className="font-semibold text-gray-800 mb-2">{item.name}</h4>
                          {item.description && (
                            <p className="text-sm text-gray-600 mb-2 line-clamp-2">{item.description}</p>
                          )}
                          
                          <div className="grid grid-cols-2 md:grid-cols-4 gap-2 text-sm">
                            <div>
                              <span className="font-medium">Quantity:</span> {item.quantity}
                            </div>
                            <div>
                              <span className="font-medium">Price:</span> {item.price.toFixed(2)} LE
                            </div>
                            <div>
                              <span className="font-medium">Total:</span> {(item.quantity * item.price).toFixed(2)} LE
                            </div>
                            <div>
                              <span className="font-medium">Status:</span>
                              <span className={`ml-1 font-semibold ${getStatusColor(item.status)}`}>
                                {item.status}
                              </span>
                            </div>
                          </div>
                        </div>

                        {/* Item Status Update */}
                        <div className="relative">
                          <button
                            onClick={() =>
                              setSelectedItemId(
                                selectedItemId === item.id ? null : item.id
                              )
                            }
                            className="bg-gray-600 text-white px-3 py-1 rounded-full text-xs hover:opacity-90"
                            disabled={updatingItemStatus === item.id}
                          >
                            {updatingItemStatus === item.id ? "Updating..." : "Change Status"}
                          </button>
                           
                          {selectedItemId === item.id && (
                            <div className="absolute right-0 mt-2 bg-white border rounded-md shadow-lg z-10 min-w-[120px]">
                              {["not_ready", "cancelled", "shipped", "complete", "refund"].map((status) => (
                                <button
                                  key={status}
                                  onClick={() => updateItemStatus(item.id, order.id, status)}
                                  className="block w-full px-3 py-2 text-xs text-gray-700 hover:bg-gray-100 text-left capitalize"
                                  disabled={updatingItemStatus === item.id}
                                >
                                  {status}
                                </button>
                              ))}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Order Summary */}
                <div className="mt-6 p-4 bg-[#003664] text-white rounded-lg">
                  <div className="flex justify-between items-center">
                    <div>
                      <div className="text-sm opacity-90">Items Total: {itemsTotal.toFixed(2)} LE</div>
                      <div className="text-lg font-bold">Seller Total: {order.sellerTotal.toFixed(2)} LE</div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm opacity-90">Order ID: {order.id}</div>
                      <div className="text-sm opacity-90">Buyer ID: {order.buyerId}</div>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
        )}
      </main>
    </div>
  );
};

export default Orders;