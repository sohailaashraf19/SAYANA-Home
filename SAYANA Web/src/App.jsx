import React from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";


// Seller Pages
import SellerHome from "./components/Pages/Seller/HomePage/SellerHome.jsx";
import AddProduct from "./components/Pages/Seller/Products/AddProduct.jsx";
import Product from "./components/Pages/Seller/Products/Products.jsx";
import ProductsUpdate from "./components/Pages/Seller/Products/Products_update.jsx";
import Login from "./components/Pages/Authentication/Seller/Login/SellerLogin.jsx";
import Signup from "./components/Pages/Authentication/Seller/Signup/SellerSignup.jsx";
import Orders from "./components/Pages/Seller/Orders/Orders.jsx";
import SplashScreen from "./components/Pages/SplashScreen/SplashScreen.jsx";
import Profile from "./components/Pages/Seller/Profile/Profile.jsx";
import ForgotPassSeller from "./components/Pages/Authentication/Seller/SellerForgotPass/ForgotPassSeller.jsx";
import OtpSeller from "./components/Pages/Authentication/Seller/OtpconfirmSeller/OtpSeller.jsx";
import SellerResetPass from "./components/Pages/Authentication/Seller/SellerResetPass/SellerResetPass.jsx";
import OffersPage from "./components/Pages/Seller/Offers/Offers.jsx";
import SupportPage from "./components/Pages/Seller/Help/Help.jsx";
// Buyer Pages
import BuyerHome from "./components/Pages/Buyer/Home/BuyerHome.jsx";
import Layout from "./components/Layout/Layout";
import ProductDetail from "./components/Pages/Buyer/Home/ProductDetail.jsx";
import GoogleCallback from "./components/Pages/Authentication/Buyer/GoogleCallback.jsx";
import BuyerSignup from "./components/Pages/Authentication/Buyer/Signup/BuyerSignup.jsx";
import BuyerLogin from "./components/Pages/Authentication/Buyer/Login/BuyerLogin.jsx";
import BuyerForgotPassword from "./components/Pages/Authentication/Buyer/ForgotPassword/BuyerForgotPassword.jsx";
import ProfilePage from "./components/Pages/Buyer/Home/Navbar/Profile/ProfilePage.jsx";
import OrderDetails from "./components/Pages/Buyer/Home/Navbar/Profile/OrderDetails.jsx"
import Whishlist from "./components/Pages/Buyer/Home/Navbar/Wishlist/Wishlist.jsx";
import Cart from "./components/Pages/Buyer/Home/Navbar/Cart/Cart.jsx";
import CategoryPage from "./components/Pages/Buyer/Home/Category/CategoryPage.jsx";
import Categories from "./components/Pages/Buyer/Home/Category/Categories.jsx";
import Chatbot from "./components/Pages/Buyer/Home/ChatBot/ChatBot.jsx";
import Checkout from "./components/Pages/Buyer/Home/Navbar/Cart/Checkout.jsx";
import Layout1 from "./components/Layout1/Layout1.jsx";
import ContactUs from "./components/Pages/Buyer/ChatIcon/ContactUs.jsx";
import EmailUs from "./components/Pages/Buyer/ChatIcon/EmailUs.jsx";
import OTPInput from "./components/Pages/Authentication/Buyer/otpConfirm/OtpConfirm.jsx";
import ResetPass from "./components/Pages/Authentication/Buyer/ResetPass/ResetPass.jsx";




const router = createBrowserRouter([
  // Splash screen
  { path: "/", element: <SplashScreen /> },

  // Seller Routes
  { path: "/home", element: <SellerHome /> },
  { path: "/add-product", element: <AddProduct/> },
  { path: "/products", element: <Product /> },
  { path: "/products-update/:id", element: <ProductsUpdate /> },
  { path: "/login", element: <Login /> },
  { path: "/signup", element: <Signup /> },
  { path: "/orders", element: <Orders /> },
  { path: "/profile", element: <Profile/>},
  { path: "/seller-forgotpassword", element: <ForgotPassSeller/>},
  { path: "/seller-otp", element: <OtpSeller/>},
  { path: "/seller-ResetPass", element: <SellerResetPass/>},
  { path: "/offers", element: <OffersPage/>},
  { path: "/help", element: <SupportPage/>},
  // Buyer Routes (with layout wrapper)
  {
    path: "/buyer",
    element: <Layout />,
    children: [
      { index: true, element: <BuyerHome /> }, // "/buyer"
      { path: "product-detail", element: <ProductDetail /> },
      { path: "profile", element: <ProfilePage /> }, 
      { path: "order/:orderId", element: <OrderDetails/>}, 
      { path: "category/:categoryName", element: <CategoryPage /> },
      { path: "categories", element: <Categories /> },
      { path: "wishlist", element: <Whishlist /> },
      { path: "contactus", element: <ContactUs/>},
      { path: "emailus", element: <EmailUs/>},
      
    ],
  },

  {
    path: "/buyer",
    element: <Layout1 />,
    children: [
      { path: "cart", element: <Cart /> },
      { path: "checkout", element: <Checkout />},
    ],
  },

  // Buyer authentication
  { path: "/buyer-signup", element: <BuyerSignup /> },
  { path: "/buyer-login", element: <BuyerLogin /> },
  { path: "/buyer-forgotpassword", element: <BuyerForgotPassword/>},
  { path: "/chatbot", element: <Chatbot/>},
  { path: "/auth/callback", element: <GoogleCallback/>},
  { path: "/buyer-forgotpassword", element: <BuyerForgotPassword/>},
  { path: "/buyer-Otp", element: <OTPInput/>},
  { path: "/buyer-ResetPass", element: <ResetPass/>},

]);

function App() {
  return (
    <div>
      <RouterProvider router={router} />
    </div>
  );
}

export default App;