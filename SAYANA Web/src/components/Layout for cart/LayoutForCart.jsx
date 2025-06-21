import { useState } from "react";
import { Outlet } from "react-router-dom";
import SayanaNav from "../Pages/Buyer/Home/Navbar/Navbar.jsx";

function Layout1() {
  // State to manage search query
  const [searchQuery, setSearchQuery] = useState("");
  const [wishlist, setWishlist] = useState([]);
  const [cart, setCart] = useState([]);

  return (
    <div>
      {/* Pass searchQuery, setSearchQuery, wishlist, setWishlist, cart, and setCart to SayanaNav */}
      <SayanaNav 
        searchQuery={searchQuery} 
        setSearchQuery={setSearchQuery} 
      />
      <div className="mt-16 p-4">
        {/* Pass all state values to the Outlet (Home component or any other components) */}
        <Outlet context={{ searchQuery, setSearchQuery, wishlist, setWishlist, cart, setCart }} />
      </div>
    </div>
  );
}

export default Layout1;