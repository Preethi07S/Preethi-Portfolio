require('dotenv').config();
const express = require('express');
const cors = require('cors');
const pool = require('./db');

const app = express();
const PORT = process.env.PORT || 4000;

// Allow the frontend (wherever it's hosted) to call this API.
// For tighter security later, replace '*' with your actual frontend origin.
const allowedOrigins = (process.env.ALLOWED_ORIGIN || '')
  .split(',')
  .map(origin => origin.trim())
  .filter(Boolean);

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  }
}));
app.use(express.json());

// Small helper so every route doesn't repeat the same try/catch.
function route(handler) {
  return async (req, res) => {
    try {
      await handler(req, res);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Server error', detail: err.message });
    }
  };
}

app.get('/api/health', route(async (req, res) => {
  const { rows } = await pool.query('SELECT now()');
  res.json({ ok: true, dbTime: rows[0].now });
}));

app.get('/api/profile', route(async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM profile ORDER BY id LIMIT 1');
  res.json(rows[0] || null);
}));

app.get('/api/hero-facts', route(async (req, res) => {
  const { rows } = await pool.query('SELECT label, value FROM hero_facts ORDER BY sort_order, id');
  res.json(rows);
}));

app.get('/api/stats', route(async (req, res) => {
  const { rows } = await pool.query('SELECT count, suffix, label FROM stats ORDER BY sort_order, id');
  res.json(rows);
}));

app.get('/api/concepts', route(async (req, res) => {
  const { rows } = await pool.query(
    "SELECT anim_key AS key, title, blurb FROM concepts WHERE active = true ORDER BY sort_order, id"
  );
  res.json(rows);
}));

app.get('/api/projects', route(async (req, res) => {
  const { rows } = await pool.query(`
    SELECT name, tag, category, color_key, icon_key, github_url, live_url,
           link_status, description, engineering_note, stack
    FROM projects
    ORDER BY sort_order, id
  `);
  res.json(rows);
}));

app.get('/api/stack', route(async (req, res) => {
  const { rows } = await pool.query(
    'SELECT group_name, item_name FROM stack_items ORDER BY group_order, sort_order, id'
  );
  // Group into { "AI / LLM": ["Gemini API", ...], ... } so the frontend
  // doesn't need to do its own grouping logic.
  const grouped = {};
  for (const r of rows) {
    if (!grouped[r.group_name]) grouped[r.group_name] = [];
    grouped[r.group_name].push(r.item_name);
  }
  res.json(grouped);
}));

app.get('/api/experience', route(async (req, res) => {
  const { rows } = await pool.query(
    'SELECT role, company, date_range, location, bullets FROM experience ORDER BY sort_order, id'
  );
  res.json(rows);
}));

app.get('/api/education', route(async (req, res) => {
  const { rows } = await pool.query(
    'SELECT degree, institution, date_range, note FROM education ORDER BY sort_order, id'
  );
  res.json(rows);
}));

app.get('/api/certifications', route(async (req, res) => {
  const { rows } = await pool.query(
    'SELECT name, issuer FROM certifications ORDER BY sort_order, id'
  );
  res.json(rows);
}));

// Convenience endpoint: everything the site needs in one round trip.
app.get('/api/portfolio', route(async (req, res) => {
  const [profile, heroFacts, stats, concepts, projects, stackRows, experience, education, certifications] =
    await Promise.all([
      pool.query('SELECT * FROM profile ORDER BY id LIMIT 1'),
      pool.query('SELECT label, value FROM hero_facts ORDER BY sort_order, id'),
      pool.query('SELECT count, suffix, label FROM stats ORDER BY sort_order, id'),
      pool.query("SELECT anim_key AS key, title, blurb FROM concepts WHERE active = true ORDER BY sort_order, id"),
      pool.query(`SELECT name, tag, category, color_key, icon_key, github_url, live_url,
                         link_status, description, engineering_note, stack
                  FROM projects ORDER BY sort_order, id`),
      pool.query('SELECT group_name, item_name FROM stack_items ORDER BY group_order, sort_order, id'),
      pool.query('SELECT role, company, date_range, location, bullets FROM experience ORDER BY sort_order, id'),
      pool.query('SELECT degree, institution, date_range, note FROM education ORDER BY sort_order, id'),
      pool.query('SELECT name, issuer FROM certifications ORDER BY sort_order, id'),
    ]);

  const stack = {};
  for (const r of stackRows.rows) {
    if (!stack[r.group_name]) stack[r.group_name] = [];
    stack[r.group_name].push(r.item_name);
  }

  res.json({
    profile: profile.rows[0] || null,
    heroFacts: heroFacts.rows,
    stats: stats.rows,
    concepts: concepts.rows,
    projects: projects.rows,
    stack,
    experience: experience.rows,
    education: education.rows,
    certifications: certifications.rows,
  });
}));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Portfolio API listening on port ${PORT}`);
});
