# Sample App

A beginner-friendly full-stack application that lists users and creates new
users. The frontend uses Next.js, the backend uses Express, and data is stored
in MySQL.

## Project structure

```text
sample-app/
├── frontend/          # Next.js frontend and Dockerfile
├── backend/           # Express API, database setup, and Dockerfile
├── docker-compose.yml
└── README.md
```

## Prerequisites

- Node.js 20.9 or newer
- npm
- MySQL Server

## 1. Create the database

Start MySQL, then run the SQL setup file:

```bash
mysql -u root -p < backend/database.sql
```

You can also copy the contents of `backend/database.sql` into MySQL Workbench
and run it there. It creates the `sample_app` database and the `users` table.

## 2. Configure and start the backend

Inside the `backend` folder, copy `.env.example` to `.env`:

```bash
cd backend
cp .env.example .env
```

On Windows PowerShell, use:

```powershell
Copy-Item .env.example .env
```

Open `.env` and enter your MySQL username and password. Then install packages
and start the API:

```bash
npm install
npm run dev
```

The backend runs at `http://localhost:5000`.

### API endpoints

- `GET /users` returns all users.
- `POST /users` creates a user. Send JSON such as:

```json
{
  "name": "Jane Doe",
  "email": "jane@example.com"
}
```

## 3. Start the frontend

Open a second terminal:

```bash
cd frontend
npm install
npm run dev
```

Visit `http://localhost:3000`. The frontend uses
`http://localhost:5000` as the API URL by default. To change it, copy
`.env.local.example` to `.env.local` and edit `NEXT_PUBLIC_API_URL`.

## Production build check

To verify that the frontend can create a production build:

```bash
cd frontend
npm run build
```

## Run everything with Docker

Docker Compose starts the frontend, backend, and a MySQL 8.4 container. The
database setup file runs automatically the first time the MySQL volume is
created.

From the `sample-app` folder, run:

```bash
docker compose up --build
```

Then open:

- Frontend: `http://localhost:3001`
- Backend API: `http://localhost:5000/users`

Stop the containers with:

```bash
docker compose down
```

To also delete the Docker database and start with an empty database next time:

```bash
docker compose down -v
```
