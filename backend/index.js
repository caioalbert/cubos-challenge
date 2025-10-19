import http from 'http';
import PG from 'pg';

const port = Number(process.env.PORT) || 3000;
const user = process.env.DB_USER || 'postgres';
const pass = process.env.DB_PASS || 'password';
const host = process.env.DB_HOST || 'localhost';
const db_port = process.env.DB_PORT || 5432;
const database = process.env.DB_NAME || 'postgres';

let client;
let successfulConnection = false;

let metrics = {
  requests_total: 0,
  requests_success: 0,
  requests_error: 0,
  db_queries_total: 0,
  uptime_start: Date.now()
};

const connectWithRetry = async (retries = 10, delay = 1000) => {
  for (let i = 0; i < retries; i++) {
    try {
      client = new PG.Client({
        user,
        password: pass,
        host,
        port: db_port,
        database
      });
      
      await client.connect();
      successfulConnection = true;
      console.log('Database connected successfully');
      return;
    } catch (err) {
      console.log(`Database connection attempt ${i + 1}/${retries} failed:`, err.message);
      if (client) {
        try { await client.end(); } catch {}
        client = null;
      }
      if (i === retries - 1) {
        console.error('Failed to connect to database after all retries');
        process.exit(1);
      }
      await new Promise(resolve => setTimeout(resolve, delay));
      delay = Math.min(delay * 1.5, 10000);
    }
  }
};

connectWithRetry();

http.createServer(async (req, res) => {
  console.log(`Request: ${req.url}`);
  metrics.requests_total++;

  if (req.url === "/metrics") {
    res.setHeader("Content-Type", "text/plain");
    res.writeHead(200);
    
    const uptime = Math.floor((Date.now() - metrics.uptime_start) / 1000);
    const metricsText = `
# HELP http_requests_total Total HTTP requests
# TYPE http_requests_total counter
http_requests_total ${metrics.requests_total}

# HELP http_requests_success Successful HTTP requests
# TYPE http_requests_success counter
http_requests_success ${metrics.requests_success}

# HELP http_requests_error Failed HTTP requests
# TYPE http_requests_error counter
http_requests_error ${metrics.requests_error}

# HELP db_queries_total Total database queries
# TYPE db_queries_total counter
db_queries_total ${metrics.db_queries_total}

# HELP app_uptime_seconds Application uptime in seconds
# TYPE app_uptime_seconds gauge
app_uptime_seconds ${uptime}

# HELP db_connection_status Database connection status (1=connected, 0=disconnected)
# TYPE db_connection_status gauge
db_connection_status ${successfulConnection ? 1 : 0}
`.trim();
    
    res.end(metricsText);
    metrics.requests_success++;
    return;
  }

  if (req.url === "/api") {
    res.setHeader("Content-Type", "application/json");
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.writeHead(200);

    let result;

    try {
      if (successfulConnection && client) {
        metrics.db_queries_total++;
        result = (await client.query("SELECT * FROM users")).rows[0];
      }
      metrics.requests_success++;
    } catch (error) {
      console.error(error);
      metrics.requests_error++;
    }

    const data = {
      database: successfulConnection,
      userAdmin: result?.role === "admin"
    }

    res.end(JSON.stringify(data));
    return;
  }
  
  res.writeHead(404);
  res.end("Not Found");
  metrics.requests_error++;

}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});