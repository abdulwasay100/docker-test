"use client";

import { useEffect, useState } from "react";

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:5000";

export default function Home() {
  const [users, setUsers] = useState([]);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  // Load the current users when the page first opens.
  useEffect(() => {
    async function loadUsers() {
      try {
        const response = await fetch(`${API_URL}/users`);
        if (!response.ok) throw new Error("Request failed");

        setUsers(await response.json());
      } catch {
        setMessage("Could not load users. Is the backend running?");
      }
    }

    loadUsers();
  }, []);

  async function handleSubmit(event) {
    event.preventDefault();
    setMessage("");

    try {
      const response = await fetch(`${API_URL}/users`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, email }),
      });
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Could not create user.");
      }

      // Put the newly created user at the top of the displayed list.
      setUsers((currentUsers) => [data, ...currentUsers]);
      setName("");
      setEmail("");
      setMessage("User created successfully.");
    } catch (error) {
      setMessage(error.message);
    }
  }

  return (
    <main>
      <section className="card">
        <h1>Users</h1>

        <form onSubmit={handleSubmit}>
          <label htmlFor="name">Name</label>
          <input
            id="name"
            value={name}
            onChange={(event) => setName(event.target.value)}
            placeholder="Jane Doe"
            required
          />

          <label htmlFor="email">Email</label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            placeholder="jane@example.com"
            required
          />

          <button type="submit">Add user</button>
        </form>

        {message && <p className="message">{message}</p>}

        <h2> The User list</h2>
        {users.length === 0 ? (
          <p>No users have been added yet.</p>
        ) : (
          <ul>
            {users.map((user) => (
              <li key={user.id}>
                <strong>{user.name}</strong>
                <span>{user.email}</span>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  );
}
