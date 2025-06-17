import { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import axios from "axios";
import Loader from "./Loader"; // Adjust the path based on your file structure

// Define the base URL for your API domain, consistent with Whishlist.js approach for images
const API_DOMAIN_BASE_URL = "https://olivedrab-llama-457480.hostingersite.com/";
const API_PUBLIC_PATH = "public/api/"; // Centralized public API path

function ProductDetail() {
  const { state } = useLocation(); // Expects state.product to be passed
  const navigate = useNavigate();
  const [comment, setComment] = useState("");
  const [comments, setComments] = useState([]);
  const [showAllComments, setShowAllComments] = useState(false); // State for toggling comments
  const [product, setProduct] = useState({
    name: "Loading...",
    price: "0.00 L.E",
    id: null,
    description: "", // Using 'description' as per API data
    image: "https://via.placeholder.com/300x200?text=Loading+Image",
  });
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch product data on component mount
  useEffect(() => {
    const fetchProduct = async () => {
      setIsLoading(true);
      setError(null);
      const productId = state?.product?.product_id;

      if (!productId) {
        console.error("ProductDetail: product_id not found in location state.");
        setError("Product information is missing. Please go back and select a product.");
        setIsLoading(false);
        return;
      }

      try {
        const response = await axios.get(
          `${API_DOMAIN_BASE_URL}${API_PUBLIC_PATH}get_products_byid/${productId}`
        );
        const data = response.data; // Assuming API returns product object directly

        // Construct image URL using the method from Whishlist.js
        const imagePathFromApi =
          Array.isArray(data.images) && data.images.length > 0
            ? data.images[0]?.image_path
            : null;

        const productImageUrl = imagePathFromApi
          ? `${API_DOMAIN_BASE_URL}${encodeURI(imagePathFromApi.replace(/^public\//, ""))}`
          : "https://via.placeholder.com/300x200?text=No+Image";

        console.log("Constructed Product Image URL:", productImageUrl);

        setProduct({
          name: data.name || "Unknown Product",
          price: data.price ? `${data.price} L.E` : "Price not available",
          id: data.product_id,
          description: data.description || "No description available.",
          image: productImageUrl,
        });
      } catch (err) {
        console.error("Error fetching product:", err);
        setError(`Failed to load product details: ${err.message}`);
        setProduct((prev) => ({
          ...prev,
          name: "Error loading product",
          image: "https://via.placeholder.com/300x200?text=Error",
        }));
      } finally {
        setIsLoading(false);
      }
    };

    if (state && state.product && state.product.product_id) {
      fetchProduct();
    } else {
      console.error("ProductDetail: Navigated without required product state or product_id.");
      setError(
        "No product selected or product data is incomplete. Please navigate from a product listing."
      );
      setIsLoading(false);
    }
  }, [state, navigate]);

  // Fetch comments
  const fetchComments = async () => {
    const productId = product?.id;
    if (!productId) return;

    try {
      const response = await axios.get(
        `${API_DOMAIN_BASE_URL}${API_PUBLIC_PATH}commet_product/${productId}`
      );
      const commentsArray = Array.isArray(response.data?.data)
        ? response.data.data
        : Array.isArray(response.data)
        ? response.data
        : [];
      setComments(commentsArray.map((item) => item.comment || ""));
    } catch (error) {
      console.error("Error fetching comments:", error);
    }
  };

  useEffect(() => {
    if (product?.id && !isLoading && !error) {
      fetchComments();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [product?.id, isLoading, error]);

  const handleSubmitComment = async (e) => {
    e.preventDefault();
    if (!comment.trim()) return;

    const productId = product?.id;
    const buyerIdString = localStorage.getItem("buyer_id");

    if (!buyerIdString) {
      alert("You must be logged in to comment.");
      console.error("buyer_id not found in localStorage for comment submission.");
      return;
    }
    const buyerId = parseInt(buyerIdString, 10);

    if (!productId) {
      alert("Cannot submit comment: Product ID is missing.");
      return;
    }

    const commentData = {
      product_id: productId,
      buyer_id: buyerId,
      comment: comment.trim(),
    };

    try {
      const response = await axios.post(
        `${API_DOMAIN_BASE_URL}${API_PUBLIC_PATH}creatcomments`,
        commentData
      );
      if (response.status === 200 || response.status === 201) {
        setComment("");
        fetchComments(); // Refetch comments
      } else {
        alert(
          `Comment submission may have failed: ${
            response.data?.message || "Server responded unexpectedly."
          }`
        );
      }
    } catch (err) {
      console.error("Error submitting comment:", err);
      alert(
        `Error submitting comment: ${
          err.response?.data?.message || err.message || "Please try again."
        }`
      );
    }
  };

  if (isLoading && !product?.id) {
    return <Loader />;
  }

  if (error && !product?.id) {
    return (
      <div className="min-h-screen bg-[#FBFBFB] flex flex-col items-center justify-center p-4 text-center">
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-bold text-red-500">Loading Error</h2>
          <p className="mt-2 text-gray-600">{error}</p>
          <button
            onClick={() => navigate(-1)}
            className="mt-6 bg-[#003664] text-white py-2 px-4 rounded-full hover:bg-opacity-80 transition-colors"
          >
            Go Back
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#FBFBFB] flex flex-col items-center p-4">
      <div className="bg-white rounded-lg shadow-lg p-6 mt-5 max-w-7xl w-full">
        {/* Flex container for image and details/comments */}
        <div className="flex flex-col md:flex-row gap-6">
          {/* Left: Product Image */}
          <div className="md:w-1/2">
            <img
              src={product.image}
              alt={product.name}
              className="w-full h-96 object-contain rounded-lg border border-gray-200"
              onError={(e) => {
                e.target.onerror = null; // Prevent infinite loop
                e.target.src =
                  "https://via.placeholder.com/300x200?text=Image+Not+Available";
              }}
            />
          </div>
          {/* Right: Product Details and Comments */}
          <div className="md:w-1/2 flex flex-col">
            <h2 className="text-2xl font-bold text-gray-800">{product.name}</h2>
            {error && product?.id && (
              <p className="text-sm text-red-500 mt-1">{error}</p>
            )}{" "}
            {/* Show non-critical fetch errors */}
            <p className="text-xl text-[#201A23] font-semibold mt-2">
              {product.price}
            </p>
            <div className="mt-3">
              <h4 className="text-md font-semibold text-gray-700">Description:</h4>
              <p className="text-sm text-gray-600 mt-1">
                {product.description || "No description provided."}
              </p>
            </div>

            {/* Comment Section */}
            <div className="mt-6 flex flex-col">
              <form onSubmit={handleSubmitComment}>
                <textarea
                  value={comment}
                  onChange={(e) => setComment(e.target.value)}
                  placeholder="Add a Comment..."
                  rows="2"
                  className="w-full p-3 border border-gray-300 rounded-lg mb-3 focus:outline-none focus:ring-2 focus:ring-[#003664] focus:border-transparent transition-shadow"
                />
                <button
                  type="submit"
                  className="w-full bg-[#003664] text-white p-3 rounded-full hover:bg-opacity-90 transition-colors font-semibold focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#003664]"
                >
                  Submit Comment
                </button>
              </form>

              <div className="mt-6 flex flex-col max-h-[400px]">
                <h3 className="text-xl font-semibold text-gray-800 mb-3">
                  Comments:
                </h3>
                {comments.length === 0 ? (
                  <p className="text-gray-500">
                    No comments yet. Be the first to comment!
                  </p>
                ) : (
                  <div className="flex flex-col">
                    <ul
                      className={`space-y-3 ${
                        showAllComments && comments.length > 6
                          ? "max-h-64 overflow-y-auto pr-2"
                          : "max-h-64"
                      }`}
                    >
                      {(showAllComments ? comments : comments.slice(0, 3)).map(
                        (c, i) => (
                          <li
                            key={i}
                            className="text-sm text-gray-700 border-b border-gray-200 pb-2"
                          >
                            {c}
                          </li>
                        )
                      )}
                    </ul>
                    <div className="mt-3">
                      {comments.length > 3 && !showAllComments && (
                        <button
                          onClick={() => setShowAllComments(true)}
                          className="text-[#003664] font-semibold hover:underline focus:outline-none"
                        >
                          View All ({comments.length} comments)
                        </button>
                      )}
                      {comments.length > 3 && showAllComments && (
                        <button
                          onClick={() => setShowAllComments(false)}
                          className="text-[#003664] font-semibold hover:underline focus:outline-none"
                        >
                          Show Less
                        </button>
                      )}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default ProductDetail;