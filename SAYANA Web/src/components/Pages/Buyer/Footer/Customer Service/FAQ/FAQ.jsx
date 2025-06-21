import React from "react";

function FAQ() {
  return (
    <div className="max-w-3xl mx-auto p-8 bg-white rounded-xl shadow mt-8">
      <h1 className="text-2xl font-bold mb-4">Frequently Asked Questions (FAQ)</h1>
      <div className="space-y-6 text-gray-800">
        <div>
          <h2 className="font-semibold mb-2">How can I place an order?</h2>
          <p>
            You can easily place an order through our website by browsing products, adding your selections to the cart, and completing the checkout process. If you need help, our customer service team is happy to assist you.
          </p>
        </div>
        <div>
          <h2 className="font-semibold mb-2">What payment methods do you accept?</h2>
          <p>
            We accept Cash, InstaPay, and other secure payment options displayed at checkout.
          </p>
        </div>
        <div>
          <h2 className="font-semibold mb-2">How do I track my order?</h2>
          <p>
            After placing an order, you will receive a confirmation email with a tracking link. You can also log in to your account to check your order status.
          </p>
        </div>
        <div>
          <h2 className="font-semibold mb-2">What is your return policy?</h2>
          <p>
            Most items can be returned within 14 days of receipt if they are unused and in original packaging. Please read our <a href="/buyer/return-policy" className="text-[#003664] underline">Return Policy</a> for full details.
          </p>
        </div>
        <div>
          <h2 className="font-semibold mb-2">How long does delivery take?</h2>
          <p>
            Delivery times vary based on your location and the items ordered. Most orders are delivered within 3-7 business days.
          </p>
        </div>
        <div>
          <h2 className="font-semibold mb-2">Can I change or cancel my order?</h2>
          <p>
            If your order hasn’t been shipped yet, please contact us as soon as possible at <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">support@sayanahome.com</a> or call <a href="tel:1234567890" className="text-[#003664] underline">123-456-7890</a>.
          </p>
        </div>
        <div>
          <h2 className="font-semibold mb-2">How do I contact customer support?</h2>
          <p>
            You can email us at <a href="mailto:support@sayanahome.com" className="text-[#003664] underline">support@sayanahome.com</a> or call <a href="tel:1234567890" className="text-[#003664] underline">123-456-7890</a>. We’re here to help!
          </p>
        </div>
      </div>
    </div>
  );
}

export default FAQ;