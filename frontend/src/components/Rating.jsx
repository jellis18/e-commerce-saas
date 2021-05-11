import React from 'react';

export const Star = ({ value, color, full, half }) => {
  return (
    <span>
      <i
        style={{ color }}
        className={
          value >= full
            ? 'fas fa-star'
            : value >= half
            ? 'fas fa-star-half-alt'
            : 'far fa-star'
        }
      ></i>
    </span>
  );
};

const Rating = ({ value, text, color }) => {
  return (
    <div className="rating">
      <Star value={value} color={color} full={1} half={0.5} />
      <Star value={value} color={color} full={2} half={1.5} />
      <Star value={value} color={color} full={3} half={2.5} />
      <Star value={value} color={color} full={4} half={3.5} />
      <Star value={value} color={color} full={5} half={4.5} />
      <span>{text && text}</span>
    </div>
  );
};

export default Rating;
