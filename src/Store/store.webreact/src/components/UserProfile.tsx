import React from 'react';

interface Consumer {
  id: number;
  firstname: string;
  surname: string;
  age: number;
}

interface UserProfileProps {
  user: Consumer | null;
}

const UserProfile: React.FC<UserProfileProps> = ({ user }) => {
  if (!user) {
    return (
      <section className="user-profile">
        <h2>Welcome, Guest!</h2>
        <p>Please sign in to continue shopping</p>
      </section>
    );
  }

  return (
    <section className="user-profile">
      <h2>Welcome, {user.firstname}!</h2>
      <div className="user-info">
        <p>Name: {user.firstname} {user.surname}</p>
        <p>Customer ID: {user.id}</p>
      </div>
    </section>
  );
};

export default UserProfile;