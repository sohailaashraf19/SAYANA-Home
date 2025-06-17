import React, { useState, useEffect } from 'react';
import axios from 'axios';

const OffersPage = () => {
  const [offers, setOffers] = useState([]);
  const [form, setForm] = useState({
    productName: '',
    originalPrice: '',
    discountedPrice: '',
    discountPercent: '',
    imageUrl: '',
  });
  const [editingOfferId, setEditingOfferId] = useState(null);

  useEffect(() => {
    fetchOffers();
  }, []);

  const fetchOffers = async () => {
    try {
      const res = await axios.get('https://your-api.com/api/seller-offers'); // ← غيّري ده حسب API بتاعك
      setOffers(res.data);
    } catch (err) {
      console.error('Error fetching offers:', err);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    let updatedForm = { ...form, [name]: value };

    // حساب discountedPrice تلقائيًا عند تغيير نسبة الخصم
    if (name === 'discountPercent' || name === 'originalPrice') {
      const original = parseFloat(
        name === 'originalPrice' ? value : form.originalPrice
      );
      const percent = parseFloat(
        name === 'discountPercent' ? value : form.discountPercent
      );

      if (!isNaN(original) && !isNaN(percent)) {
        const discounted = original - (original * percent) / 100;
        updatedForm.discountedPrice = discounted.toFixed(2);
      }
    }

    setForm(updatedForm);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      if (editingOfferId) {
        await axios.put(`https://your-api.com/api/offers/${editingOfferId}`, form);
      } else {
        await axios.post('https://your-api.com/api/offers', form);
      }

      setForm({
        productName: '',
        originalPrice: '',
        discountedPrice: '',
        discountPercent: '',
        imageUrl: '',
      });
      setEditingOfferId(null);
      fetchOffers();
    } catch (err) {
      console.error('Error saving offer:', err);
    }
  };

  const handleEdit = (offer) => {
    setForm({
      productName: offer.productName,
      originalPrice: offer.originalPrice,
      discountedPrice: offer.discountedPrice,
      discountPercent: offer.discountPercent,
      imageUrl: offer.imageUrl,
    });
    setEditingOfferId(offer.id);
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`https://your-api.com/api/offers/${id}`);
      fetchOffers();
    } catch (err) {
      console.error('Error deleting offer:', err);
    }
  };

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h2 className="text-2xl font-bold mb-4">
        {editingOfferId ? 'Edit Offer' : 'Add New Offer'}
      </h2>

      <form onSubmit={handleSubmit} className="bg-white shadow rounded-lg p-4 mb-6 space-y-4">
        <input
          type="text"
          name="productName"
          placeholder="Product Name"
          value={form.productName}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
          required
        />

        <input
          type="number"
          name="originalPrice"
          placeholder="Original Price"
          value={form.originalPrice}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
          required
        />

        <input
          type="number"
          name="discountPercent"
          placeholder="Discount Percentage"
          value={form.discountPercent}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
          required
        />

        <input
          type="number"
          name="discountedPrice"
          placeholder="Discounted Price"
          value={form.discountedPrice}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
          required
        />

        <input
          type="text"
          name="imageUrl"
          placeholder="Image URL"
          value={form.imageUrl}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />

        <button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded">
          {editingOfferId ? 'Update Offer' : 'Add Offer'}
        </button>
      </form>

      <h3 className="text-xl font-semibold mb-4">Your Offers</h3>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {offers.map((offer) => (
          <div key={offer.id} className="bg-white shadow rounded-lg p-4">
            <img
              src={offer.imageUrl}
              alt={offer.productName}
              className="w-full h-40 object-cover rounded mb-2"
            />
            <h4 className="text-lg font-semibold">{offer.productName}</h4>
            <p className="text-gray-600">Original Price: ${offer.originalPrice}</p>
            <p className="text-red-600">Discounted Price: ${offer.discountedPrice}</p>
            <p className="text-green-600 font-semibold">
              Discount: {offer.discountPercent}%
            </p>
            <div className="mt-3 space-x-2">
              <button
                onClick={() => handleEdit(offer)}
                className="bg-yellow-500 text-white px-3 py-1 rounded"
              >
                Edit
              </button>
              <button
                onClick={() => handleDelete(offer.id)}
                className="bg-red-600 text-white px-3 py-1 rounded"
              >
                Delete
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default OffersPage;
