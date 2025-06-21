import React from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";


// Seller Pages
import LayoutForSeller from "./components/Layout for seller/LayoutForSeller.jsx"; 
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
import Feedback from "./components/Pages/Seller/Feedback/Feedback.jsx";
import PrivacyPolicySeller from "./components/Pages/seller/Footer/Privacy Policy/PrivacyPolicy.jsx";
import ComingSoonSeller from "./components/Pages/seller/Footer/Comming soon/CommingSoon.jsx";
import TermsAndConditionsSeller from "./components/Pages/seller/Footer/Customer Service/Terms and conditions/Terms&conditions.jsx";
import GuaranteesWarrantiesSeller from "./components/Pages/seller/Footer/Customer Service/ Guarantees and warranties/ Guarantees&warranties.jsx";
import SparePartsSeller from "./components/Pages/seller/Footer/Customer Service/Spare parts/Spareparts.jsx";
import AboutServicesSeller from "./components/Pages/seller/Footer/Customer Service/About services/AboutService.jsx";
import AboutShoppingSeller from "./components/Pages/seller/Footer/Customer Service/About Shopping/AboutShopping.jsx";
import ReturnPolicySeller from "./components/Pages/seller/Footer/Customer Service/Return policy/ReturnPolicy.jsx";
import FAQSeller from "./components/Pages/seller/Footer/Customer Service/FAQ/FAQ.jsx";
import ProductRecallsSeller from "./components/Pages/seller/Footer/General information/Product recalls/ProductRecalls.jsx";
import InstaPaySeller from "./components/Pages/seller/Footer/General information/InstaPay/InstaPay.jsx";
import AboutSYANASeller from "./components/Pages/seller/Footer/This is SYANA/About SYANA/AboutSYANA.jsx";
import DemocraticDesignSeller from "./components/Pages/seller/Footer/This is SYANA/Democratic design/DemocraticDesign.jsx";
import SustainableEverydaySeller from "./components/Pages/seller/Footer/This is SYANA/Sustainable everyday/SustainableEveryday.jsx";
import CommunityEngagementSeller from "./components/Pages/seller/Footer/This is SYANA/Community engagement/CommunityEngagement.jsx";
import WorkingAtSYANASeller from "./components/Pages/seller/Footer/This is SYANA/Working at SYANA/WorkingAtSYANA.jsx";
import SYANAShoppingAppSeller from "./components/Pages/seller/Footer/Useful links/SYANA Shopping App/SYANAShoppingApp.jsx";
import SYANAFamilySeller from "./components/Pages/seller/Footer/Useful links/SYANA Family/SYANAFamily.jsx";
import StoresSeller from "./components/Pages/seller/Footer/Useful links/Stores/Stores.jsx";
import PlanningToolsSeller from "./components/Pages/seller/Footer/Useful links/Planning tools/PlanningTools.jsx";
import CookiePolicySeller from "./components/Pages/seller/Footer/Cookie Policy/Cookies.jsx";



// Buyer Pages
import BuyerHome from "./components/Pages/Buyer/Home/BuyerHome.jsx";
import Layout from "./components/Layout for buyer/LayoutForBuyer.jsx";
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
import OrderDetailsPage from "./components/Pages/Buyer/Home/Navbar/Cart/OrderDetail.jsx";
import Layout1 from "./components/Layout for cart/LayoutForCart.jsx";
import ContactUs from "./components/Pages/Buyer/ChatIcon/ContactUs.jsx";
import EmailUs from "./components/Pages/Buyer/ChatIcon/EmailUs.jsx";
import OTPInput from "./components/Pages/Authentication/Buyer/otpConfirm/OtpConfirm.jsx";
import ResetPass from "./components/Pages/Authentication/Buyer/ResetPass/ResetPass.jsx";
import PrivacyPolicy from "./components/Pages/buyer/Footer/Privacy Policy/PrivacyPolicy.jsx";
import ComingSoon from "./components/Pages/buyer/Footer/Comming soon/CommingSoon.jsx";
import TermsAndConditions from "./components/Pages/buyer/Footer/Customer Service/Terms and conditions/Terms&conditions.jsx";
import GuaranteesWarranties from "./components/Pages/buyer/Footer/Customer Service/ Guarantees and warranties/ Guarantees&warranties.jsx";
import SpareParts from "./components/Pages/buyer/Footer/Customer Service/Spare parts/Spareparts.jsx";
import AboutServices from "./components/Pages/buyer/Footer/Customer Service/About services/AboutService.jsx";
import AboutShopping from "./components/Pages/buyer/Footer/Customer Service/About Shopping/AboutShopping.jsx";
import ReturnPolicy from "./components/Pages/buyer/Footer/Customer Service/Return policy/ReturnPolicy.jsx";
import FAQ from "./components/Pages/buyer/Footer/Customer Service/FAQ/FAQ.jsx";
import ProductRecalls from "./components/Pages/buyer/Footer/General information/Product recalls/ProductRecalls.jsx";
import InstaPay from "./components/Pages/buyer/Footer/General information/InstaPay/InstaPay.jsx";
import AboutSYANA from "./components/Pages/buyer/Footer/This is SYANA/About SYANA/AboutSYANA.jsx";
import DemocraticDesign from "./components/Pages/buyer/Footer/This is SYANA/Democratic design/DemocraticDesign.jsx";
import SustainableEveryday from "./components/Pages/buyer/Footer/This is SYANA/Sustainable everyday/SustainableEveryday.jsx";
import CommunityEngagement from "./components/Pages/buyer/Footer/This is SYANA/Community engagement/CommunityEngagement.jsx";
import WorkingAtSYANA from "./components/Pages/buyer/Footer/This is SYANA/Working at SYANA/WorkingAtSYANA.jsx";
import SYANAShoppingApp from "./components/Pages/buyer/Footer/Useful links/SYANA Shopping App/SYANAShoppingApp.jsx";
import SYANAFamily from "./components/Pages/buyer/Footer/Useful links/SYANA Family/SYANAFamily.jsx";
import Stores from "./components/Pages/buyer/Footer/Useful links/Stores/Stores.jsx";
import PlanningTools from "./components/Pages/buyer/Footer/Useful links/Planning tools/PlanningTools.jsx";
import CookiePolicy from "./components/Pages/buyer/Footer/Cookie Policy/Cookies.jsx";

const router = createBrowserRouter([
  // Splash screen
  { path: "/", element: <SplashScreen /> },

  // Seller Routes
  {
    path: "",
    element: <LayoutForSeller/>,
    children: [
    { path: "/home", element: <SellerHome /> },
    { path: "/add-product", element: <AddProduct/> },
    { path: "/products", element: <Product /> },
    { path: "/products-update/:id", element: <ProductsUpdate /> },
    { path: "/orders", element: <Orders /> },
    { path: "/profile", element: <Profile/>},
    { path: "/seller-otp", element: <OtpSeller/>},
    { path: "/seller-ResetPass", element: <SellerResetPass/>},
    { path: "/offers", element: <OffersPage/>},
    { path: "/help", element: <SupportPage/>},
    { path: "/feedback", element: <Feedback/>},
    { path: "privacy-policy-seller", element: <PrivacyPolicySeller/>},
    { path: "cooming-soon-seller", element: <ComingSoonSeller/>},
    { path: "terms-seller", element: <TermsAndConditionsSeller/>},
    { path: "guarantees-warranties-seller", element: <GuaranteesWarrantiesSeller/>},
    { path: "spareparts-seller", element: <SparePartsSeller/>},
    { path: "about-services-seller", element: <AboutServicesSeller/>},
    { path: "about-shopping-seller", element: <AboutShoppingSeller/>},
    { path: "return-policy-seller", element: <ReturnPolicySeller/>},
    { path: "FAQ-seller", element: <FAQSeller/>},
    { path: "product-recall-seller", element: <ProductRecallsSeller/>},
    { path: "instapay-seller", element: <InstaPaySeller/>},
    { path: "about-syana-seller", element: <AboutSYANASeller/>},
    { path: "democratic-design-seller", element: <DemocraticDesignSeller/>},
    { path: "sustainable-everyday-seller", element: <SustainableEverydaySeller/>},
    { path: "community-engagement-seller", element: <CommunityEngagementSeller/>},
    { path: "working-at-syana-seller", element: <WorkingAtSYANASeller/>},
    { path: "syana-shopping-app-seller", element: <SYANAShoppingAppSeller/>},
    { path: "syana-family-seller", element: <SYANAFamilySeller/>},
    { path: "stores-seller", element: <StoresSeller/>},
    { path: "planning-tools-seller", element: <PlanningToolsSeller/>},
    { path: "cookie-policy-seller", element: <CookiePolicySeller/>},

      
      ],
  },
  
  // Seller authentication
  { path: "/login", element: <Login /> },
  { path: "/signup", element: <Signup /> },
  { path: "/seller-forgotpassword", element: <ForgotPassSeller/>},
  { path: "/seller-otp", element: <OtpSeller/>},
  { path: "/seller-ResetPass", element: <SellerResetPass/>},


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
      { path: "privacy-policy", element: <PrivacyPolicy/>},
      { path: "cooming-soon", element: <ComingSoon/>},
      { path: "terms", element: <TermsAndConditions/>},
      { path: "guarantees-warranties", element: <GuaranteesWarranties/>},
      { path: "spareparts", element: <SpareParts/>},
      { path: "about-services", element: <AboutServices/>},
      { path: "about-shopping", element: <AboutShopping/>},
      { path: "return-policy", element: <ReturnPolicy/>},
      { path: "FAQ", element: <FAQ/>},
      { path: "product-recall", element: <ProductRecalls/>},
      { path: "instapay", element: <InstaPay/>},
      { path: "about-syana", element: <AboutSYANA/>},
      { path: "democratic-design", element: <DemocraticDesign/>},
      { path: "sustainable-everyday", element: <SustainableEveryday/>},
      { path: "community-engagement", element: <CommunityEngagement/>},
      { path: "working-at-syana", element: <WorkingAtSYANA/>},
      { path: "syana-shopping-app", element: <SYANAShoppingApp/>},
      { path: "syana-family", element: <SYANAFamily/>},
      { path: "stores", element: <Stores/>},
      { path: "planning-tools", element: <PlanningTools/>},
      { path: "cookie-policy", element: <CookiePolicy/>},
    ],
  },

  {
    path: "/buyer",
    element: <Layout1 />,
    children: [
      { path: "cart", element: <Cart /> },
      { path: "checkout", element: <Checkout />},
      { path: "order-summary", element: <OrderDetailsPage /> },
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