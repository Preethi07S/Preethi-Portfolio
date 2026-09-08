-- Preethi Sree — Portfolio database schema
-- Every table below maps to one section of the site. Adding a row to any
-- of these tables is enough to make it appear on the page — no code
-- changes needed, EXCEPT where a table's comment says otherwise
-- (concepts and projects rely on a fixed set of hand-built animations/
-- icons; see README.md "Adding content" for exactly what that means).

DROP TABLE IF EXISTS certifications CASCADE;
DROP TABLE IF EXISTS education CASCADE;
DROP TABLE IF EXISTS experience CASCADE;
DROP TABLE IF EXISTS stack_items CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS concepts CASCADE;
DROP TABLE IF EXISTS stats CASCADE;
DROP TABLE IF EXISTS hero_facts CASCADE;
DROP TABLE IF EXISTS profile CASCADE;

-- Single-row table: identity, hero headline, and contact info.
CREATE TABLE profile (
  id             SERIAL PRIMARY KEY,
  name           TEXT NOT NULL,
  headline       TEXT NOT NULL,          -- big italic H1, e.g. "I make messy data usable."
  lede           TEXT NOT NULL,          -- paragraph under the headline
  email          TEXT,
  phone          TEXT,
  github_url     TEXT,
  linkedin_url   TEXT,
  location       TEXT,
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- The "Right now" box in the hero. Add/remove/reorder rows freely.
CREATE TABLE hero_facts (
  id          SERIAL PRIMARY KEY,
  label       TEXT NOT NULL,     -- e.g. "Role"
  value       TEXT NOT NULL,     -- e.g. "Program Coordinator, Connect & Heal — Bengaluru, 2025–present"
  sort_order  INTEGER NOT NULL DEFAULT 0
);

-- The animated counters strip. Add/remove/reorder rows freely.
CREATE TABLE stats (
  id          SERIAL PRIMARY KEY,
  count       INTEGER NOT NULL,
  suffix      TEXT NOT NULL DEFAULT '',
  label       TEXT NOT NULL,
  sort_order  INTEGER NOT NULL DEFAULT 0
);

-- The rotating "concept explainer" widget in the hero.
-- IMPORTANT: `anim_key` selects which hand-built animation is shown.
-- The 11 built-in keys are:
--   rag, embed, cnn, prompt, queue, asr, ocr, auth, etl, augment, tuning
-- Any other value (or one you make up) falls back to a generic pulsing
-- placeholder animation — the concept still appears with its own title
-- and text, it just won't have a bespoke animation until one is coded.
CREATE TABLE concepts (
  id          SERIAL PRIMARY KEY,
  anim_key    TEXT NOT NULL,
  title       TEXT NOT NULL,
  blurb       TEXT NOT NULL,
  active      BOOLEAN NOT NULL DEFAULT true,
  sort_order  INTEGER NOT NULL DEFAULT 0
);

-- Work section cards.
-- `color_key` picks the accent colour: cat-llm, cat-llm2, cat-ops, cat-nlp,
-- cat-research (or anything else, which falls back to the default teal).
-- `icon_key` picks the hand-drawn icon: medisort, mediassist, gochart,
-- nlp, brain (anything else falls back to a generic code-bracket icon —
-- see README.md for what "falls back" means in practice).
-- `link_status` is one of: 'live', 'internal', 'soon' — controls what
-- the card shows in place of a link.
CREATE TABLE projects (
  id               SERIAL PRIMARY KEY,
  name             TEXT NOT NULL,
  tag              TEXT NOT NULL,             -- small label under the name, e.g. "Full-stack · shipped internally"
  category         TEXT NOT NULL,             -- filter bucket: llm / automation / nlp / research / ...
  color_key        TEXT NOT NULL DEFAULT 'cat-llm',
  icon_key         TEXT NOT NULL DEFAULT 'generic',
  github_url       TEXT,
  live_url         TEXT,
  link_status      TEXT NOT NULL DEFAULT 'soon',
  description      TEXT NOT NULL,
  engineering_note TEXT,                      -- nullable; omit for no expandable note
  stack            TEXT[] NOT NULL DEFAULT '{}',
  sort_order       INTEGER NOT NULL DEFAULT 0
);

-- Stack / skills section. group_name clusters items under a heading;
-- group_order controls which group appears first (independent of the
-- alphabetical order group_name would otherwise sort into).
CREATE TABLE stack_items (
  id          SERIAL PRIMARY KEY,
  group_name  TEXT NOT NULL,      -- e.g. "AI / LLM"
  group_order INTEGER NOT NULL DEFAULT 0,
  item_name   TEXT NOT NULL,      -- e.g. "Gemini API"
  sort_order  INTEGER NOT NULL DEFAULT 0
);

-- Experience section. bullets is a plain text array — one entry per bullet.
CREATE TABLE experience (
  id          SERIAL PRIMARY KEY,
  role        TEXT NOT NULL,
  company     TEXT NOT NULL,
  date_range  TEXT NOT NULL,
  location    TEXT,
  bullets     TEXT[] NOT NULL DEFAULT '{}',
  sort_order  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE education (
  id          SERIAL PRIMARY KEY,
  degree      TEXT NOT NULL,
  institution TEXT NOT NULL,
  date_range  TEXT NOT NULL,
  note        TEXT,               -- e.g. "CGPA 8.5"
  sort_order  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE certifications (
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  issuer      TEXT NOT NULL,
  sort_order  INTEGER NOT NULL DEFAULT 0
);
