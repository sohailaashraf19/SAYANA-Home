import React from 'react';

const SupportPage = () => {
  return (
    <div className="bg-gradient-to-r from-blue-50 to-blue-100 min-h-screen flex flex-col items-center justify-center">

      <div className="text-center mt-10">
        <img src="https://via.placeholder.com/200x200" alt="Support" className="mx-auto" />
        <h1 className="text-3xl font-bold mt-4">Are you facing any problem?</h1>
        <p className="text-gray-600 mt-2">If you need instant support then use live chat option or quickly. Our support will reply as soon as possible after you send us a message.</p>
        <div className="mt-6 space-x-4">
          <button className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-700">Start Live Chat</button>
          <button className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-700">Open a Ticket</button>
        </div>
        <p className="text-gray-600 mt-4">Or you can contact at</p>
        <p className="text-gray-600">Email: support@mydomain.com</p>
        <p className="text-gray-600">Phone: +88 123 456 789</p>
        <p className="text-gray-600 mt-4">May be we have already the solution</p>
      </div>
    </div>
  );
};

export default SupportPage;