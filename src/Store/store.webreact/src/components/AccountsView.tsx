import React from 'react';

interface Consumer {
  id: number;
  firstname: string;
  surname: string;
  age: number;
}

interface AccountsViewProps {
  consumers: Consumer[];
}

const AccountsView: React.FC<AccountsViewProps> = ({ consumers }) => {
  return (
    <div className="service-view">
      <h2>Account Service</h2>
      <p className="service-description">Manage customer accounts and profiles</p>
      <div className="service-grid">
        {consumers.map(consumer => (
          <div key={consumer.id} className="service-card">
            <h3>{consumer.firstname} {consumer.surname}</h3>
            <p>ID: {consumer.id}</p>
            <p>Age: {consumer.age}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default AccountsView;