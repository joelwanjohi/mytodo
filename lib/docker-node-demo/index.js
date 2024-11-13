// index.js
const express = require('express');
const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Basic route for the home page
app.get('/', (req, res) => {
  res.send(`
    <h1>Welcome to My First Docker App! 🐳</h1>
    <p>This is a simple Node.js application running in a Docker container.</p>
    <ul>
      <li>Try our /hello endpoint</li>
      <li>Check server time at /time</li>
    </ul>
  `);
});

// Additional routes to demonstrate functionality
app.get('/hello', (req, res) => {
  res.json({ message: 'Hello from the containerized app! 🚀' });
});

app.get('/time', (req, res) => {
  res.json({ 
    serverTime: new Date().toLocaleString(),
    timezone: process.env.TZ || 'UTC'
  });
});

// Start the server
app.listen(port, () => {
  console.log(`
    🚀 Server is running!
    📝 App listening at http://localhost:${port}
    🔥 Try accessing different endpoints:
       - http://localhost:${port}/
       - http://localhost:${port}/hello
       - http://localhost:${port}/time
  `);
});