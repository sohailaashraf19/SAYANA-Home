import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";

const GoogleCallback = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // هنا هتيجي البيانات من جوجل في ال URL (query params)
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get("code");
    const error = urlParams.get("error");

    if (error) {
      console.error("Google Login Error:", error);
      navigate("/buyer-login"); // لو حصل خطأ نرجّع للصفحة
    } else if (code) {
      console.log("Google Auth Code:", code);

      // هنا المفروض تبعتي الكود للسيرفر عشان يبدلوه بـ access token
      // مثال بسيط (لو عندك endpoint في الـ backend):

      // axios.post("https://your-backend.com/api/auth/google", { code })
      //   .then(response => {
      //     // Save token, navigate, etc.
      //     navigate("/buyer"); // مثال
      //   })
      //   .catch(err => {
      //     console.error("Error exchanging code:", err);
      //     navigate("/buyer-login");
      //   });

      // مؤقتًا نرجّع للداشبورد أو أي مكان
      navigate("/buyer");
    }
  }, [navigate]);

  return (
    <div className="flex items-center justify-center h-screen">
      <p className="text-lg text-gray-700">Processing Google login...</p>
    </div>
  );
};

export default GoogleCallback;
