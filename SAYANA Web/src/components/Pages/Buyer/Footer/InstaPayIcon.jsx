import React from "react";
const InstaPayIcon = ({ width = 90, height = 42 }) => (
  <svg width={width} height={height} viewBox="0 0 320 150" fill="none" xmlns="http://www.w3.org/2000/svg">
    {/* الحروف I و P */}
    <g>
      <path d="M29 97L57 33H78L50 97H29Z" fill="#5F2580"/>
      <path d="M174 33H207C222 33 232 41 232 54C232 67 222 75 207 75H183L174 97H154L174 33ZM207 59C213 59 217 56 217 51C217 46 213 44 207 44H192L187 59H207Z" fill="#5F2580"/>
    </g>
    {/* السهم البرتقالي المزدوج */}
    <svg width="250" height="97" viewBox="0 -19 180 120">
  <g>
    {/* السهم الكبير الأول */}
    {/* فوق */}
    <polygon points="40,20 60,20 90,60 70,60" fill="#F37539"/>
    {/* تحت */}
    <polygon points="40,100 60,100 90,60 70,60" fill="#F37539"/>
    
    {/* السهم الكبير الثاني (بعد مسافة) */}
    {/* فوق */}
    <polygon points="80,20 100,20 130,60 110,60" fill="#F37539"/>
    {/* تحت */}
    <polygon points="80,100 100,100 130,60 110,60" fill="#F37539"/>
  </g>
</svg>
    {/* نص INSTA PAY */}
    <g>
      <text x="30" y="135" fontFamily="Arial Black, Arial, sans-serif" fontWeight="bold" fontSize="40" fill="#5F2580" letterSpacing="-4">
        INSTA
      </text>
      <text x="155" y="135" fontFamily="Arial Black, Arial, sans-serif" fontWeight="bold" fontSize="40" fill="#A782C1" letterSpacing="2">
        PAY
      </text>
    </g>
  </svg>
);

export default InstaPayIcon;