import "./globals.css";

export const metadata = {
  title: "Sample User App",
  description: "A beginner-friendly Next.js, Express, and MySQL application",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
