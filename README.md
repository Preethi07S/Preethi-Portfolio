# Preethi Sree — Portfolio (full-stack)

A small Node/Express + PostgreSQL API backing a static HTML/CSS/JS
frontend. Work, Stack, Experience, Education, Certifications, the "Right
now" facts, the animated stats, and the rotating concept-explainer text
all come from the database. Add a row, refresh the page, it's there —
no code changes for ordinary content.

Built with plain PostgreSQL + node-postgres rather than an ORM, so
there's nothing to generate or compile — just SQL files and one
Express server. Editing data means opening a normal Postgres GUI and
adding a row, the same way you'd work in a spreadsheet.

## Structure
```
backend/
  sql/schema.sql   — table definitions (run once)
  sql/seed.sql     — current content, as INSERT statements (safe to re-run any time)
  server.js        — the Express API
  db.js            — the Postgres connection pool
  .env.example     — copy to .env and fill in DATABASE_URL
frontend/
  index.html       — the whole site: fetches from the API and renders itself
```

## 1. Set up the database

Pick one:

- **Supabase** (recommended — you've already used it on MediSort AI, so
  the workflow will be familiar). Create a free project, then go to
  Project Settings → Database → Connection string for your
  `DATABASE_URL`. Supabase's **Table Editor** gives you exactly the
  rows-and-columns view you're after, with nothing to install.
- **Local Postgres** — `postgresql://user:password@localhost:5432/dbname`.
- Render, Railway, or Neon also work — any standard Postgres connection
  string is fine.

Then load the schema and starting content (replace `"$DATABASE_URL"` with
your real connection string, or `export DATABASE_URL=...` first so the
variable resolves):
```bash
cd backend
psql "$DATABASE_URL" -f sql/schema.sql
psql "$DATABASE_URL" -f sql/seed.sql
```
`seed.sql` clears each table before inserting, so re-running it always
resets everything back to this known-good state — handy if you want to
start over.

## 2. Run the backend
```bash
cd backend
cp .env.example .env      # then edit DATABASE_URL
npm install
npm start
```
Visit `http://localhost:4000/api/health` — you should see
`{"ok":true, ...}`. `GET /api/portfolio` returns everything the
frontend needs in one call; there are also separate endpoints per
section (`/api/projects`, `/api/stack`, `/api/experience`, etc.) if you
ever want them.

## 3. Point the frontend at the backend
Near the top of `frontend/index.html`:
```html
<script>window.API_BASE = "http://localhost:4000";</script>
```
Change this to wherever the backend ends up living (e.g.
`https://your-api.onrender.com`), then just open the file in a browser
— it's a single static file, no build step.

## 4. Deploying for real
- **Backend** — Render, Railway, or Fly.io all have a small free/cheap
  tier that's plenty for this. Set `DATABASE_URL` as an environment
  variable there (and `ALLOWED_ORIGIN`, once step 5 applies).
- **Database** — Supabase's free tier is enough for a portfolio site.
- **Frontend** — any static host: Vercel, Netlify, GitHub Pages. Just
  make sure `API_BASE` in `index.html` points at the deployed backend
  first.

## 5. Adding content — the actual point of all this

Open whichever Postgres GUI you're using (Supabase's Table Editor,
TablePlus, pgAdmin, DBeaver — anything) and add a row:

| Table            | Shows up as                                  |
|------------------|-----------------------------------------------|
| `projects`       | A card in the Work section                    |
| `stack_items`    | A chip in the Stack section                   |
| `experience`     | A role in Experience                          |
| `education`      | A degree                                      |
| `certifications` | A certificate                                 |
| `hero_facts`     | A line in the "Right now" box                 |
| `stats`          | One of the four animated counters             |
| `concepts`       | A topic in the rotating hero widget           |
| `profile`        | Single row — name, headline, bio, contact info|

Refresh the page. That's the whole workflow — no deploy, no code
change, for anything above.

### The few things worth knowing before you add a row

- **`projects.icon_key`** picks a hand-drawn icon: `medisort`,
  `mediassist`, `gochart`, `nlp`, or `brain`. Use whichever fits
  closest — anything else (including leaving it blank) falls back to a
  generic bracket icon rather than breaking.
- **`concepts.anim_key`** picks a hand-built animation: `rag`, `embed`,
  `cnn`, `prompt`, `queue`, `asr`, `ocr`, `auth`, `etl`, `augment`,
  `tuning`. A new key still shows up with its own title and
  explanation text — it just gets a plain pulsing-dot animation instead
  of a bespoke one, until one gets built for it. Ask me any time you
  want a new one hand-drawn.
- **`stack_items.group_order`** decides which group section comes
  first (e.g. "AI / LLM" before "ML / DL"). A brand-new group name
  needs a `group_order` number too, or it defaults to 0 and jumps to
  the front.
- **`projects.category`** drives the filter tabs in Work. Any value
  works — a new category gets its own filter button automatically,
  labelled from whatever you typed.
- **`projects.link_status`** should be `'live'`, `'internal'`, or
  `'soon'` — it controls what shows in place of a link when there's no
  `live_url`.

## Notes
- CORS is wide open by default. Once both sides are deployed, set
  `ALLOWED_ORIGIN` in the backend's environment to your frontend's
  exact URL to lock it down.
- There's no login on the API — anyone with the URL can *read* your
  portfolio data (same as any live website), but nothing can *write*
  to it remotely. Writes only happen through direct database access,
  which is the intended editing workflow.
- If the frontend can't reach the API, it shows a banner explaining
  why instead of rendering a blank page.
