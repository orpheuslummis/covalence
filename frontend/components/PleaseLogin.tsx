import React from "react";

export const PleaseLogin = () => {
  return (
    <div>
      <h2>Please Login</h2>
      <p>You need to be logged in to access this page.</p>
      <a href="/" style={{ color: "blue", textDecoration: "none" }}>
        Go back to the frontpage
      </a>
    </div>
  );
};
