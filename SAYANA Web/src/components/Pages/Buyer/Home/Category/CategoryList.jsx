import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import axios from "axios";

function CategoryList() {
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    const fetchCategories = async () => {
      try {
        const response = await axios.get("https://olivedrab-llama-457480.hostingersite.com/public/api/getAllCategories");
        console.log("Categories API Response:", response.data); // Log for debugging
        // Assuming the API returns an array of objects like [{id: 1, name: "Electronics"}, ...]
        setCategories(response.data);
      } catch (error) {
        console.error("Error fetching categories:", error);
        setCategories([]);
      }
    };

    fetchCategories();
  }, []);

  return (
    <div className="w-1/4 bg-white p-4 rounded-lg shadow-md">
      <h2 className="text-xl font-bold mb-4">Categories</h2>
      {categories.length > 0 ? (
        <ul>
          {categories.map((category) => (
            <li key={category.id} className="mb-2">
              <Link
                to={`/category/${category.name.replace(/\s+/g, "-").toLowerCase()}`}
                className="block p-2 rounded-lg transition-colors hover:bg-gray-200"
              >
                {category.name}
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-gray-500">No categories available.</p>
      )}
    </div>
  );
}

export default CategoryList;