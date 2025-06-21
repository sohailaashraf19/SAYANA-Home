import { useState } from "react";
import { Outlet, Link } from "react-router-dom";
import { FaFacebookF, FaInstagram, FaLinkedinIn } from "react-icons/fa";
import InstaPayIconSeller from "../Pages/Seller/Footer/InstaPayIcon";
import Sidebar from "../Pages/Seller/Sidebar/Sidebar"; 

function LayoutForSeller() {
  const [searchQuery, setSearchQuery] = useState("");
  const [wishlist, setWishlist] = useState([]);
  const [cart, setCart] = useState([]);

  const currentYear = new Date().getFullYear();
  const chatIconColor = "#003664";
  const darkGray = "#4B5563";

  return (
    <div className="flex flex-col min-h-screen bg-[#FBFBFB]">
      {/* Sidebar + Content */}
      <div className="flex flex-1">
        {/* Sidebar on the left */}
        <div className="flex-shrink-0">
          <Sidebar />
        </div>
        {/* Main content */}
        <main className="flex-1">
          <Outlet
            context={{ searchQuery, setSearchQuery, wishlist, setWishlist, cart, setCart }}
          />
        </main>
      </div>

      {/* Footer */}
      <footer className="bg-white text-xs sm:text-sm border-t border-gray-200">
        <div className="max-w-screen-xl mx-auto px-6 py-10 grid grid-cols-2 md:grid-cols-4 gap-8 text-left">
          {/* Useful links */}
          <div>
            <h3 className="font-semibold mb-4" style={{ color: chatIconColor }}>Useful links</h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li><a href="syana-shopping-app-seller" className="hover:underline" style={{ color: darkGray }}>SYANA shopping app</a></li>
              <li><a href="planning-tools-seller" className="hover:underline" style={{ color: darkGray }}>Planning tools</a></li>
              <li><a href="stores-seller" className="hover:underline" style={{ color: darkGray }}>Stores</a></li>
              <li><a href="syana-family-seller" className="hover:underline" style={{ color: darkGray }}>SYANA Family</a></li>
            </ul>
          </div>
          {/* Customer service */}
          <div>
            <h3 className="font-semibold mb-4" style={{ color: chatIconColor }}>Customer service</h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li><a href="terms-seller" className="hover:underline" style={{ color: darkGray }}>Terms and conditions</a></li>
              <li><a href="guarantees-warranties-seller" className="hover:underline" style={{ color: darkGray }}>Guarantees & warranties</a></li>
              <li><a href="spareparts-seller" className="hover:underline" style={{ color: darkGray }}>Spare parts</a></li>
              <li><a href="about-services-seller" className="hover:underline" style={{ color: darkGray }}>About services</a></li>
              <li><a href="about-shopping-seller" className="hover:underline" style={{ color: darkGray }}>About shopping</a></li>
              <li><a href="return-policy-seller" className="hover:underline" style={{ color: darkGray }}>Return policy</a></li>
              <li><a href="contactus-seller" className="hover:underline" style={{ color: darkGray }}>Contact us</a></li>
              <li><a href="FAQ-seller" className="hover:underline" style={{ color: darkGray }}>FAQ</a></li>
            </ul>
          </div>
          {/* This is SAYANA */}
          <div>
            <h3 className="font-semibold mb-4" style={{ color: chatIconColor }}>This is SYANA</h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li><a href="about-syana-seller" className="hover:underline" style={{ color: darkGray }}>About SYANA</a></li>
              <li><a href="democratic-design-seller" className="hover:underline" style={{ color: darkGray }}>Democratic design</a></li>
              <li><a href="sustainable-everyday-seller" className="hover:underline" style={{ color: darkGray }}>Sustainable everyday</a></li>
              <li><a href="community-engagement-seller" className="hover:underline" style={{ color: darkGray }}>Community engagement</a></li>
              <li><a href="working-at-syana-seller" className="hover:underline" style={{ color: darkGray }}>Working at SYANA</a></li>
            </ul>
          </div>
          {/* General information */}
          <div>
            <h3 className="font-semibold mb-4" style={{ color: chatIconColor }}>General information</h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li><a href="product-recall-seller" className="hover:underline" style={{ color: darkGray }}>Product recalls</a></li>
              <li><a href="instapay-seller" className="hover:underline" style={{ color: darkGray }}>InstaPay</a></li>
            </ul>
          </div>
        </div>
        {/* Social + Bottom */}
        <div className="border-t border-gray-200 py-4 px-6 flex flex-col md:flex-row justify-between items-center space-y-3 md:space-y-0">
          {/* Social */}
          <div className="flex space-x-4">
            <a href="https://facebook.com" target="_blank" rel="noopener noreferrer" className="hover:text-gray-500 transition flex items-center justify-center rounded-full bg-gray-200 w-8 h-8">
              <FaFacebookF size={16} />
            </a>
            <a href="https://instagram.com" target="_blank" rel="noopener noreferrer" className="hover:text-gray-500 transition flex items-center justify-center rounded-full bg-gray-200 w-8 h-8">
              <FaInstagram size={16} />
            </a>
            <a href="https://linkedin.com" target="_blank" rel="noopener noreferrer" className="hover:text-gray-500 transition flex items-center justify-center rounded-full bg-gray-200 w-8 h-8">
              <FaLinkedinIn size={16} />
            </a>
          </div>
          {/* أيقونة InstaPay فقط */}
          <div className="flex space-x-4 items-center">
            <InstaPayIconSeller width={90} height={42} />
          </div>
          {/* Bottom Links */}
          <div className="flex flex-col md:flex-row items-center space-y-2 md:space-y-0 md:space-x-4 text-center text-xs" style={{ color: darkGray }}>
            <span>EG | English</span>
            <span>© SAYANA Home {currentYear}</span>
            <Link to="privacy-policy-seller" className="hover:underline" style={{ color: darkGray }}>
              Privacy policy
            </Link>
            <a href="cookie-policy-seller" className="hover:underline" style={{ color: darkGray }}>
              Cookie policy
            </a>
            <a href="terms-seller" className="hover:underline" style={{ color: darkGray }}>
              Terms and conditions
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default LayoutForSeller;