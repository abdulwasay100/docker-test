const express = require("express");
const cors = require("cors");
const mysql = require("mysql2/promise");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 5000;

// Allow the Next.js frontend to call this API.
app.use(cors());
// Convert incoming JSON request bodies into JavaScript objects.
app.use(express.json());

// A connection pool reuses database connections between requests.
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

// Return every user, newest users first.
app.get("/users", async (req, res) => {
  try {
    const [users] = await pool.query(
      "SELECT id, name, email FROM users ORDER BY id DESC"
    );
    res.json(users);
  } catch (error) {
    console.error("Could not get users:", error.message);
    res.status(500).json({ message: "Could not get users." });
  }
});

// Create a user from the name and email sent by the frontend.
app.post("/users", async (req, res) => {
  const name = req.body.name?.trim();
  const email = req.body.email?.trim();

  if (!name || !email) {
    return res.status(400).json({ message: "Name and email are required." });
  }

  try {
    // Placeholders keep user input separate from the SQL statement.
    const [result] = await pool.execute(
      "INSERT INTO users (name, email) VALUES (?, ?)",
      [name, email]
    );

    res.status(201).json({ id: result.insertId, name, email });
  } catch (error) {
    console.error("Could not create user:", error.message);
    res.status(500).json({ message: "Could not create user." });
  }
});

app.listen(PORT, () => {
  console.log(`Backend running at http://localhost:${PORT}`);
});
