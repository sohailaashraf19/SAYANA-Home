import React, { useState, useEffect, useRef } from "react";
import { Card, CardContent } from "../../../ui/card";
import { Progress } from "../../../ui/progress";
import { FaSearch } from "react-icons/fa";
import { BellIcon } from "@heroicons/react/24/outline";
import { Link } from "react-router-dom";
import {
  PieChart,
  Pie,
  Cell,
  Tooltip,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  ResponsiveContainer,
} from "recharts";
import { motion } from "framer-motion";
import axios from "axios";

const COLORS = ["#FFBB28", "#00C49F", "#3B82F6"];

const iconVariants = {
  hover: { scale: 1.1, transition: { duration: 0.2 } },
  tap: { scale: 0.95, transition: { duration: 0.1 } },
};

const Home = () => {
  const [customerData, setCustomerData] = useState([]);
  const [trendingProducts, setTrendingProducts] = useState([]);
  const [productCount, setProductCount] = useState(null);
  const [totalOrders, setTotalOrders] = useState(null);
  const [uniqueBuyers, setUniqueBuyers] = useState(null);
  const [totalSale, setTotalSale] = useState(null);
  const [revenueData, setRevenueData] = useState([]);
  const [recentOrders, setRecentOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // states for searching
  const [searchQuery, setSearchQuery] = useState("");
  const [searchResults, setSearchResults] = useState([]);
  const [searchLoading, setSearchLoading] = useState(false);
  const [searchError, setSearchError] = useState(null);

  // 1- Reference for input and results
  const searchRef = useRef(null);

  // 2- Close search results when clicking outside
  useEffect(() => {
    function handleClickOutside(event) {
      if (
        searchRef.current &&
        !searchRef.current.contains(event.target)
      ) {
        setSearchResults([]);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  useEffect(() => {
    const fetchHighestSpendingCustomers = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

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

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/highestspending?seller_id=${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        const sortedData = response.data.sort(
          (a, b) => b.purchase_count - a.purchase_count
        );
        const topThreeCustomers = sortedData.slice(0, 3);
        setCustomerData(topThreeCustomers);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    const fetchTrendingProducts = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/popular-products?saller_id=${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        const transformedData = response.data.map((item) => ({
          product_id: item.product_id,
          name: item.name,
          total_sold: parseInt(item.total_orders, 10) || 0,
          image_path: item.image,
        }));
        setTrendingProducts(transformedData);
      } catch (err) {
        setError(err.message);
      }
    };

    const fetchProductCount = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/sellercount-products?saller_id=${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        setProductCount(response.data.product_count);
      } catch (err) {
        setError(err.message);
      }
    };

    const fetchTotalOrders = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/sellerorders-count/${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        setTotalOrders(response.data.total_orders_participated_in);
      } catch (err) {
        setError(err.message);
      }
    };

    const fetchUniqueBuyers = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/sellerunique-buyers/${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        setUniqueBuyers(response.data.unique_buyers_count);
      } catch (err) {
        setError(err.message);
      }
    };

    const fetchTotalSale = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/calculateSellerPaidOrders/${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        setTotalSale(response.data.total_paid_sales);
      } catch (err) {
        setError(err.message);
      }
    };

    const fetchRevenueData = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/sellerrevenue/${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        const { total_sales_before_fees, net_profit_95_percent } = response.data;
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
        const avgNetProfitPerMonth = net_profit_95_percent / 6;
        const newRevenueData = months.map((month, index) => ({
          month,
          netProfit: avgNetProfitPerMonth * (index + 1),
        }));
        setRevenueData(newRevenueData);
      } catch (err) {
        setError(err.message);
      }
    };

    // Fetch recent orders, include buyer_id instead of tracking
    const fetchRecentOrders = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/ordersnot-ready?seller_id=${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "application/json",
            },
          }
        );

        if (!response.data || !response.data.orders) {
          setError("Invalid response data from API");
          return;
        }

        const transformedOrders = response.data.orders.map((order, index) => {
          const totalAmount = order.products.reduce((sum, product) => {
            return sum + parseFloat(product.price) * product.quantity;
          }, 0);

          return {
            id: order.order_id || `#${String(index + 1).padStart(3, "0")}`,
            purchaseDate: new Date("2025-06-21").toLocaleDateString("en-GB", {
              day: "2-digit",
              month: "short",
              year: "numeric",
            }),
            amount: `${totalAmount.toFixed(2)} LE`,
            status: order.status.replace("_", " "),
            buyer_id: order.buyer_id, // <-- هنا تم الإضافة
            products: order.products,
          };
        });

        setRecentOrders(transformedOrders.slice(0, 5));
      } catch (err) {
        setError(`Failed to fetch recent orders: ${err.message}`);
      }
    };

    fetchRevenueData();
    fetchTotalOrders();
    fetchHighestSpendingCustomers();
    fetchTrendingProducts();
    fetchProductCount();
    fetchUniqueBuyers();
    fetchTotalSale();
    fetchRecentOrders();
  }, []);

  // Search handler
  const handleSearch = async (q) => {
    const sellerId = localStorage.getItem("seller_id");
    const token = localStorage.getItem("token");
    setSearchLoading(true);
    setSearchError(null);
    try {
      const response = await axios.get(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/sellerproductssearch?seller_id=${sellerId}&keyword=${encodeURIComponent(
          q
        )}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setSearchResults(
        response.data.map((product) => {
          const imagePath = product.images?.[0]?.image_path;
          const imageUrl = imagePath
            ? `https://olivedrab-llama-457480.hostingersite.com/${imagePath}`
            : "https://via.placeholder.com/64";
          return { ...product, imageUrl };
        })
      );
    } catch (err) {
      setSearchError("A search error occurred!");
    } finally {
      setSearchLoading(false);
    }
  };

  return (
    <div className="flex h-screen bg-[#FBFBFB]">
      <main className="flex-1 p-6 overflow-y-scroll">
        <motion.div
          initial={{ opacity: 0, y: -50 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="flex justify-between items-center mb-6"
        >
          <div className="relative w-1/3" ref={searchRef}>
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => {
                setSearchQuery(e.target.value);
                handleSearch(e.target.value);
              }}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  handleSearch(searchQuery);
                }
              }}
              placeholder="Search Here"
              className="w-full p-2 pl-10 border border-white-300 shadow rounded-full focus:outline-none focus:border-[#003664]"
            />
            <FaSearch className="absolute left-3 top-3 text-gray-500" />
            {searchLoading && (
              <div className="mt-2 text-gray-500 text-sm">Searching...</div>
            )}
            {searchError && (
              <div className="mt-2 text-red-500 text-sm">{searchError}</div>
            )}
            {searchResults.length > 0 && (
              <div className="absolute left-0 w-full bg-white shadow rounded mt-2 p-2 max-h-64 overflow-y-auto z-10">
                {searchResults.map((product) => (
                  <Link
                    key={product.product_id}
                    to={`/products-update/${product.product_id}`}
                    state={{ product }}
                    className="flex items-center gap-3 border-b py-2 hover:bg-gray-100 transition rounded"
                  >
                    <img
                      src={product.imageUrl}
                      alt={product.name}
                      className="w-10 h-10 object-cover rounded border"
                      onError={(e) => {
                        e.target.src = "https://via.placeholder.com/64";
                      }}
                    />
                    <div>
                      <div className="font-bold text-gray-800">{product.name}</div>
                    </div>
                  </Link>
                ))}
              </div>
            )}
          </div>
          <div className="flex items-center space-x-4">
            <motion.div variants={iconVariants} whileHover="hover" whileTap="tap">
              <BellIcon className="h-6 w-6 text-gray-600" />
            </motion.div>
            <Link to="/profile">
              <img
                src="src/assets/images/abd.jpeg"
                alt="Profile"
                className="w-8 h-8 rounded-full object-cover cursor-pointer"
              />
            </Link>
          </div>
        </motion.div>

        <motion.div
          className="grid grid-cols-4 gap-4 mb-6"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.6 }}
        >
          {[
            {
              title: "Total Sale",
              value: totalSale ? `${totalSale} LE` : "Loading...",
              change: "37% Last Week",
            },
            {
              title: "Product",
              value: productCount !== null ? productCount : "Loading...",
              change: "23% Last Week",
            },
            {
              title: "Total Orders",
              value: totalOrders !== null ? totalOrders : "Loading...",
              change: "17% Last Week",
            },
            {
              title: "Customers",
              value: uniqueBuyers !== null ? uniqueBuyers : "Loading...",
              change: "14% Last Week",
            },
          ].map((stat, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.4, delay: i * 0.2 }}
            >
              <Card className="p-4 bg-[#EFF4F7]">
                <CardContent>
                  <p className="text-sm text-grey-500">{stat.title}</p>
                  <h2 className="text-xl font-bold">{stat.value}</h2>
                  <p className="text-xs text-yellow-500">🔻 {stat.change}</p>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </motion.div>

        <motion.div
          className="grid grid-cols-3 gap-4 mb-6"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.7 }}
        >
          <Card className="col-span-2 p-4 bg-[#EFF4F7]">
            <CardContent>
              <h3 className="font-bold mb-2">Revenue</h3>
              <p className="text-sm text-gray-500 mb-4">
                $
                {revenueData.length > 0
                  ? revenueData[5].netProfit.toFixed(2)
                  : "Loading..."}{" "}
                Net Profit All Time
              </p>
              <div style={{ width: "100%", height: 250 }}>
                <ResponsiveContainer>
                  <LineChart
                    data={revenueData}
                    margin={{ top: 10, right: 30, left: 0, bottom: 0 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="month" />
                    <YAxis />
                    <Tooltip />
                    <Line
                      type="monotone"
                      dataKey="netProfit"
                      stroke="#3B82F6"
                      strokeWidth={2}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>

          <Card className="p-4 bg-[#EFF4F7]">
            <CardContent>
              <h3 className="font-bold mb-2">Highest Spending Customer</h3>
              {loading ? (
                <p>Loading...</p>
              ) : error ? (
                <p>Error: {error}</p>
              ) : (
                <>
                  <div className="flex justify-center">
                    <PieChart width={200} height={200}>
                      <Pie
                        data={customerData}
                        dataKey="purchase_count"
                        nameKey="buyer_name"
                        cx="50%"
                        cy="50%"
                        outerRadius={70}
                        innerRadius={40}
                        label
                      >
                        {customerData.map((entry, index) => (
                          <Cell
                            key={`cell-${index}`}
                            fill={COLORS[index % COLORS.length]}
                          />
                        ))}
                      </Pie>
                      <Tooltip />
                    </PieChart>
                  </div>
                  <ul className="mt-4 text-sm text-gray-700 space-y-1">
                    {customerData.map((customer, index) => (
                      <li key={index} className="flex items-center space-x-2">
                        <div
                          className="w-3 h-3 rounded-full"
                          style={{
                            backgroundColor: COLORS[index % COLORS.length],
                          }}
                        ></div>
                        <span>
                          {customer.buyer_name} - {customer.purchase_count} orders
                        </span>
                      </li>
                    ))}
                  </ul>
                </>
              )}
            </CardContent>
          </Card>
        </motion.div>

        <motion.div
          className="grid grid-cols-3 gap-4"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.7 }}
        >
          <Card className="col-span-2 p-4 bg-[#EFF4F7]">
            <CardContent>
              <h3 className="font-bold mb-4">Orders Not Ready</h3>
              {loading ? (
                <p>Loading...</p>
              ) : error ? (
                <p>Error: {error}</p>
              ) : (
                <table className="w-full text-left text-sm">
                  <thead className="text-gray-500">
                    <tr>
                      <th>#</th>
                      <th>Purchase On</th>
                      <th>Amount</th>
                      <th>Status</th>
                      <th>Buyer ID</th>
                    </tr>
                  </thead>
                  <tbody className="text-gray-700">
                    {recentOrders.length > 0 ? (
                      recentOrders.map((order, i) => (
                        <tr key={i} className="border-t">
                          <td>{order.id}</td>
                          <td>{order.purchaseDate}</td>
                          <td>{order.amount}</td>
                          <td
                            className={`font-semibold capitalize ${
                              order.status === "shipped"
                                ? "text-green-600"
                                : order.status === "cancelled"
                                ? "text-red-600"
                                : order.status === "delivered"
                                ? "text-blue-600"
                                : "text-yellow-600"
                            }`}
                          >
                            {order.status}
                          </td>
                          <td>
                            {order.buyer_id ? order.buyer_id : "N/A"}
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan="5" className="text-center py-4 text-gray-500">
                          No recent orders found
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              )}
            </CardContent>
          </Card>

          <Card className="p-4 bg-[#EFF4F7]">
            <CardContent>
              <h3 className="font-bold mb-4">Trending Products</h3>
              {loading ? (
                <p>Loading...</p>
              ) : error ? (
                <p>Error: {error}</p>
              ) : (
                <>
                  {trendingProducts.length > 0 && (
                    <div
                      className={`${
                        trendingProducts.length > 7
                          ? "max-h-48 overflow-y-auto"
                          : ""
                      }`}
                    >
                      {trendingProducts.map((item, i) => {
                        const totalSold = trendingProducts.reduce(
                          (sum, product) => sum + product.total_sold,
                          0
                        );
                        const percentage =
                          totalSold > 0 ? (item.total_sold / totalSold) * 100 : 0;
                        return (
                          <div key={i} className="mb-4">
                            <div className="flex items-center space-x-2 mb-1">
                              <span>{item.name}</span>
                              <span className="text-sm text-gray-500">
                                ({percentage.toFixed(1)}%)
                              </span>
                            </div>
                            <Progress value={percentage} className="h-2" />
                          </div>
                        );
                      })}
                    </div>
                  )}
                </>
              )}
            </CardContent>
          </Card>
        </motion.div>
      </main>
    </div>
  );
};

export default Home;