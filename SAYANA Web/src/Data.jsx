import React from "react";
import sofa from "./assets/images/1.jpg";
import bath from "./assets/images/2.jpg";
import kitchen from "./assets/images/3.jpg";
import Outdoor from "./assets/images/4.jpg";
import Bedroom from "./assets/images/5.jpg";
import office from "./assets/images/8.jpg";

function Data() {
  return {
    Electronics: {
      items: [
        { name: "Smart TV", image: kitchen },
        { name: "Speaker", image: sofa },
      ],
      description: "Latest electronics for your home.",
    },
    Furniture: {
      items: [
        { name: "Sofa Set", image: bath },
        { name: "Bookshelf", image: Outdoor },
      ],
      description: "Comfortable and modern furniture.",
    },
    "House Decor": {
      items: [
        { name: "Vase", image: Bedroom },
        { name: "Painting", image: office },
      ],
      description: "Beautiful decor items for your space.",
    },
    Lighters: {
      items: [
        { name: "Ceiling Light", image: kitchen },
        { name: "Table Lamp", image: sofa },
      ],
      description: "Brighten up your rooms.",
    },
    Curtain: {
      items: [
        { name: "Silk Curtain", image: bath },
        { name: "Blackout Curtain", image: Outdoor },
      ],
      description: "Elegant curtains for privacy and style.",
    },
    Tables: {
      items: [
        { name: "Dining Table", image: Bedroom },
        { name: "Coffee Table", image: office },
      ],
      description: "Stylish tables for every room.",
    },
    Carpet: {
      items: [
        { name: "Area Rug", image: kitchen },
        { name: "Runner Rug", image: sofa },
      ],
      description: "Cozy carpets for your floors.",
    },
    "Dining Room": {
      items: [
        { name: "Dining Set", image: bath },
        { name: "Chandelier", image: Outdoor },
      ],
      description: "Elegant dining room essentials.",
    },
    Accessories: {
      items: [
        { name: "Cushions", image: Bedroom },
        { name: "Throw Blanket", image: office },
      ],
      description: "Add a touch of style with accessories.",
    },
    Ceramic: {
      items: [
        { name: "Ceramic Tiles", image: kitchen },
        { name: "Ceramic Vase", image: sofa },
      ],
      description: "Durable and beautiful ceramic products.",
    },
    Bathroom: {
      items: [
        { name: "Shower Set", image: bath },
        { name: "Sink", image: Outdoor },
      ],
      description: "Modern bathroom fixtures.",
    },
    Mirrors: {
      items: [
        { name: "Wall Mirror", image: Bedroom },
        { name: "Vanity Mirror", image: office },
      ],
      description: "Reflective elegance for your space.",
    },
    Outdoor: {
      items: [
        { name: "Patio Set", image: kitchen },
        { name: "Garden Lights", image: sofa },
      ],
      description: "Enhance your outdoor living.",
    },
    "Bed Room": {
      items: [
        { name: "King Bed", image: bath },
        { name: "Nightstand", image: Outdoor },
      ],
      description: "Cozy bedroom essentials.",
    },
    "Kids Room": {
      items: [
        { name: "Bunk Bed", image: Bedroom },
        { name: "Study Desk", image: office },
      ],
      description: "Fun and functional kids' furniture.",
    },
    Office: {
      items: [
        { name: "Office Chair", image: kitchen },
        { name: "Desk", image: sofa },
      ],
      description: "Ergonomic office solutions.",
    },
    Doors: {
      items: [
        { name: "Front Door", image: bath },
        { name: "Sliding Door", image: Outdoor },
      ],
      description: "Secure and stylish doors.",
    },
  };
}

export default Data;