import React from 'react';
import type { Consumer } from '../types';

interface NavBarProps {
  consumer: Consumer;
}

const NavBar: React.FC<NavBarProps> = ({ consumer }) => {
  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light fixed-top">
      <div className="container">
        <a className="navbar-brand" href="#">CyStore</a>
        <div className="collapse navbar-collapse" id="navbarResponsive">
          <ul className="navbar-nav ml-auto">
            <li className="nav-item">
              <a className="nav-link" href="#">Shop</a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="#">Cart</a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="#">Checkout</a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="#">{consumer.firstname} {consumer.surname}</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;