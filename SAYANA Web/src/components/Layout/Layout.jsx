import { useState } from "react";
import { Outlet } from "react-router-dom";
import SayanaNav from "../Pages/Buyer/Home/Navbar/Navbar.jsx";
import ChatIcon from "../Pages/Buyer/ChatIcon/ChatIcon.jsx";
import { FaFacebookF, FaInstagram, FaLinkedinIn } from "react-icons/fa";

// أيقونات فيزا وماستر كارد بألوانهم الرسمية
const VisaIcon = () => (
  <svg
    width="40"
    height="24"
    viewBox="0 0 40 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className="inline-block"
  >
    <rect width="40" height="24" fill="#1A1F71" />
    <text
      x="20"
      y="17"
      fill="white"
      fontSize="14"
      fontWeight="bold"
      textAnchor="middle"
      fontFamily="Arial, sans-serif"
    >
      VISA
    </text>
  </svg>
);

const MasterCardIcon = () => (
  <svg
    width="40"
    height="24"
    viewBox="0 0 40 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className="inline-block"
  >
    <circle cx="14" cy="12" r="10" fill="#EB001B" />
    <circle cx="26" cy="12" r="10" fill="#F79E1B" fillOpacity="0.9" />
  </svg>
);

function Layout() {
  const [searchQuery, setSearchQuery] = useState("");
  const [wishlist, setWishlist] = useState([]);
  const [cart, setCart] = useState([]);

  const currentYear = new Date().getFullYear();

  // اللون الجديد بدل النص الأسود
  const chatIconColor = "#003664";
  // لون رمادي أغمق من السابق
  const darkGray = "#4B5563";

  return (
    <div className="flex flex-col min-h-screen">
      <SayanaNav searchQuery={searchQuery} setSearchQuery={setSearchQuery} />

      <main className="flex-grow mt-16 p-4">
        <Outlet
          context={{ searchQuery, setSearchQuery, wishlist, setWishlist, cart, setCart }}
        />
      </main>

      <ChatIcon />

      {/* Footer - White background + multiple columns */}
      <footer className="bg-white text-xs sm:text-sm border-t border-gray-200">
        <div className="max-w-screen-xl mx-auto px-6 py-10 grid grid-cols-2 md:grid-cols-4 gap-8 text-left">
          {/* Useful links */}
          <div>
            <h3
              className="font-semibold mb-4"
              style={{ color: chatIconColor }}
            >
              Useful links
            </h3>
            <ul className="space-y-2" style={{ color: darkGray }}>

              <li>
                <a href="#" className="hover:underline">
                  SAYANA shopping app
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Planning tools
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Stores
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  SAYANA Family
                </a>
              </li>
            </ul>
          </div>

          {/* Customer service */}
          <div>
            <h3
              className="font-semibold mb-4"
              style={{ color: chatIconColor }}
            >
              Customer service
            </h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li>
                <a href="#" className="hover:underline">
                  Terms and conditions
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Guarantees & warranties
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Spare parts
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  About services
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  About shopping
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Return policy
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Contact us
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  FAQ
                </a>
              </li>
            </ul>
          </div>

          {/* This is SAYANA */}
          <div>
            <h3
              className="font-semibold mb-4"
              style={{ color: chatIconColor }}
            >
              This is SAYANA
            </h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li>
                <a href="#" className="hover:underline">
                  About SAYANA
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Democratic design
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Sustainable everyday
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Community engagement
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  Working at SAYANA
                </a>
              </li>
            </ul>
          </div>

          {/* General information */}
          <div>
            <h3
              className="font-semibold mb-4"
              style={{ color: chatIconColor }}
            >
              General information
            </h3>
            <ul className="space-y-2" style={{ color: darkGray }}>
              <li>
                <a href="#" className="hover:underline">
                  Product recalls
                </a>
              </li>
             
              <li>
                <a href="#" className="hover:underline">
                  VISA
                </a>
              </li>
              <li>
                <a href="#" className="hover:underline">
                  MasterCard
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Social + Bottom */}
        <div className="border-t border-gray-200 py-4 px-6 flex flex-col md:flex-row justify-between items-center space-y-3 md:space-y-0">
          {/* Social */}
          <div className="flex space-x-4">
            <a
              href="https://facebook.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-gray-500 transition flex items-center justify-center rounded-full bg-gray-200 w-8 h-8"
            >
              <FaFacebookF size={16} />
            </a>
            <a
              href="https://instagram.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-gray-500 transition flex items-center justify-center rounded-full bg-gray-200 w-8 h-8"
            >
              <FaInstagram size={16} />
            </a>
            <a
              href="https://linkedin.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-gray-500 transition flex items-center justify-center rounded-full bg-gray-200 w-8 h-8"
            >
              <FaLinkedinIn size={16} />
            </a>
          </div>

          {/* أيقونات فيزا وماستر كارد */}
          <div className="flex space-x-4 items-center">
            <VisaIcon />
            <MasterCardIcon />
          </div>

          {/* Bottom Links */}
          <div
            className="flex flex-col md:flex-row items-center space-y-2 md:space-y-0 md:space-x-4 text-center text-xs"
            style={{ color: darkGray }}
          >
            <span>EG | English</span>
            <span>© SAYANA Home {currentYear}</span>
            <a href="/privacy" className="hover:underline" style={{ color: darkGray }}>
              Privacy policy
            </a>
            <a href="/cookie-policy" className="hover:underline" style={{ color: darkGray }}>
              Cookie policy
            </a>
            <a href="/terms" className="hover:underline" style={{ color: darkGray }}>
              Terms and conditions
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default Layout;
