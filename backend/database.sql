-- Run this file once in MySQL before starting the application.
CREATE DATABASE IF NOT EXISTS sample_app;

USE sample_app;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);
