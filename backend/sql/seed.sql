-- Seed data matching the current live content of the portfolio.
-- Re-run this any time with: psql "$DATABASE_URL" -f sql/seed.sql
-- (it clears each table first, so it's safe to re-run)

TRUNCATE profile, hero_facts, stats, concepts, projects, stack_items, experience, education, certifications RESTART IDENTITY;

INSERT INTO profile (name, headline, lede, email, phone, github_url, linkedin_url, location) VALUES (
  'Preethi Sree',
  'I make messy data usable.',
  'I hold an M.Sc. in Data Science and work as a Program Coordinator at Connect & Heal in Bengaluru. Alongside that role, I design and ship production LLM, RAG, and automation systems — five projects so far, spanning live AI applications, an internal automation tool, and ongoing medical imaging research.',
  'preethisree53@gmail.com',
  '+91 88673 56007',
  'https://github.com/Preethi07S',
  'https://www.linkedin.com/in/its-preethi-sree',
  'Bengaluru, India'
);

INSERT INTO hero_facts (label, value, sort_order) VALUES
  ('Role', 'Program Coordinator, Connect & Heal — Bengaluru, 2025–present', 1),
  ('Education', 'M.Sc. Data Science, Christ University — 2023–2025, CGPA 8.5', 2),
  ('Open to', 'AI Engineer, ML Engineer, Data Scientist roles', 3),
  ('Core stack', 'Gemini · OpenAI · Groq · FAISS · React · Node.js · PostgreSQL', 4);

INSERT INTO stats (count, suffix, label, sort_order) VALUES
  (5, '', 'AI / ML projects shipped', 1),
  (3, '', 'LLM providers orchestrated in one app', 2),
  (39, '', 'tools & frameworks across the stack', 3),
  (3, '', 'certifications completed', 4);

INSERT INTO concepts (anim_key, title, blurb, sort_order) VALUES
  ('rag', 'Retrieval-Augmented Generation', 'A question doesn''t go straight to the model. It''s used to search a knowledge base first — the closest chunks come back, and the model answers using only what it retrieved, not what it ''remembers''.', 1),
  ('embed', 'Vector embeddings', 'Every piece of text becomes a point in space. Similar meanings land close together, so ''blood sugar'' and ''glucose test'' end up as near neighbours even without sharing a single word.', 2),
  ('cnn', 'Convolutional neural networks', 'A small filter slides across an image checking for one pattern at a time — an edge, a curve. Stack enough of these and the network builds up from edges to shapes to whole structures.', 3),
  ('prompt', 'Prompt engineering', 'The same question can get a vague answer or a precise one, depending only on how it''s asked. Giving the model role, format, and constraints up front does more than a bigger model would alone.', 4),
  ('queue', 'Async job queues', 'Large files don''t get processed inline — they''re dropped into a queue, picked up by a worker one at a time, and the user gets notified when it''s done instead of watching a spinner.', 5),
  ('asr', 'Speech-to-text (ASR)', 'Audio comes in as a waveform and goes out as a transcript, word by word — the same transcript that then gets scored, word by word, for anything that needs to be muted.', 6),
  ('ocr', 'Optical Character Recognition', 'A scanner doesn''t need to understand a document to read it — it just needs to find where the characters are and match each shape to a letter, line by line, before anything downstream can treat it as text.', 7),
  ('auth', 'OAuth & SSO', 'The app never sees a password. An identity provider verifies who you are and hands back a short-lived token — the app trusts the token, not you directly, which is what lets one login work across every connected tool.', 8),
  ('etl', 'ETL pipelines', 'Data rarely arrives ready to use. It gets pulled from wherever it lives, reshaped into a consistent structure, and only then loaded somewhere a report or a model can actually query it.', 9),
  ('augment', 'Data augmentation', 'Flip an image, rotate it, crop it slightly — the tumour is still a tumour, but the model now sees it from four angles instead of one. On a small medical dataset, that''s often worth more than a bigger network.', 10),
  ('tuning', 'Hyperparameter tuning', 'The architecture rarely changes as much as people expect — most of the gain comes from patiently sweeping learning rate, batch size, and regularisation until the model lands in the zone that generalises instead of memorising.', 11);

INSERT INTO projects (name, tag, category, color_key, icon_key, github_url, live_url, link_status, description, engineering_note, stack, sort_order) VALUES
(
  'MediSort AI', 'Full-stack · shipped internally', 'llm', 'cat-llm', 'medisort',
  'https://github.com/Preethi07S/MediSort-AI', NULL, 'soon',
  'Connect & Heal receives medical test package files from many labs, each in its own inconsistent Excel layout — different headers, orderings, and category labels for the same tests. MediSort AI reads the raw file, uses Gemini to infer the mapping, and outputs it in the standard template the ops team needs, gated behind Google OAuth with a Supabase archive (180-day retention) so every conversion is auditable.',
  'What''s actually running: the production version is a React single-page app calling Gemini client-side. It was originally designed as a full Node/Express/Prisma/BullMQ system with async job queues for large files — then simplified to client-side calls to get something into internal use faster; the queue-backed version is still on the list. Also hit a Gemini quirk worth knowing: the API rejects a conversation history that opens on an assistant turn, which silently broke multi-turn chat until leading assistant messages were stripped before every call.',
  ARRAY['React','Gemini API','Node.js','PostgreSQL','Supabase','Vercel'], 1
),
(
  'MediAssist AI', 'RAG · live', 'llm', 'cat-llm2', 'mediassist',
  NULL, 'https://mediassist-ai.streamlit.app', 'live',
  'A medical knowledge chatbot built around a proper RAG pipeline rather than an open-ended model. A medical knowledge base is chunked and embedded with sentence-transformers, indexed in FAISS, and every answer is grounded in a retrieved, cited source instead of the model free-associating.',
  'Why three providers: the app orchestrates OpenAI, Groq, and Gemini with adaptive response modes rather than hardcoding one model, and falls back to live web search when a query falls outside what''s in the FAISS index — so it degrades gracefully instead of confidently answering from nothing.',
  ARRAY['Python','FAISS','Sentence Transformers','OpenAI','Groq','Gemini','Streamlit'], 2
),
(
  'Go Lives Tracker', 'Internal tool · Connect & Heal', 'automation', 'cat-ops', 'gochart',
  NULL, NULL, 'internal',
  'Replaced a fully manual weekly reporting process covering 100+ client go-lives with an automated pipeline running straight off the source sheet: 11 summary tables and 9 charts regenerated on demand, a Sunday-aware notification system firing three times a day, and a Slides export that turns raw data into a branded 9-slide stakeholder deck without anyone opening Slides by hand.',
  'The part that''s not in the spec: scheduling had to account for real client behaviour, not just a fixed cron — notifications skip Sundays, and the ageing logic freezes for accounts already marked Live or LWA, so the dashboard stops counting days against an account that''s already resolved instead of quietly overstating how overdue it is.',
  ARRAY['Google Apps Script','Sheets API v4'], 3
),
(
  'Offensive Language Detection', 'NLP pipeline', 'nlp', 'cat-nlp', 'nlp',
  NULL, NULL, 'soon',
  'An end-to-end pipeline for video: Whisper transcribes the audio, a transformer-based classifier scores each word for toxicity, and only the words that cross a threshold get masked — the rest of the clip plays untouched — before the censored audio is merged back into the video.',
  'No blocklist, on purpose: masking is threshold-driven — each word gets a toxicity score from a Detoxify-based classifier, and only the ones crossing the threshold get muted. That means the pipeline adapts as the underlying model improves instead of needing a maintained list of banned words.',
  ARRAY['Python','Whisper','HuggingFace Transformers'], 4
),
(
  'Brain Tumor Detection', 'Research', 'research', 'cat-research', 'brain',
  NULL, NULL, 'soon',
  'A CNN trained to classify brain tumors from MRI scans, tuned through data augmentation and hyperparameter search. A paper based on this work is currently in preparation for publication.',
  'What actually moved the needle: most of the gain came from augmentation and hyperparameter tuning rather than architecture changes — on a small medical imaging dataset, how carefully you regularize tends to matter more than how deep the network is.',
  ARRAY['TensorFlow','CNN','Medical Imaging'], 5
);

INSERT INTO stack_items (group_name, group_order, item_name, sort_order) VALUES
('AI / LLM', 1, 'Gemini API', 1), ('AI / LLM', 1, 'OpenAI API', 2), ('AI / LLM', 1, 'Groq', 3), ('AI / LLM', 1, 'LangChain', 4),
('AI / LLM', 1, 'FAISS', 5), ('AI / LLM', 1, 'Sentence Transformers', 6), ('AI / LLM', 1, 'RAG pipelines', 7), ('AI / LLM', 1, 'Prompt engineering', 8),
('ML / DL', 2, 'TensorFlow', 1), ('ML / DL', 2, 'Scikit-learn', 2), ('ML / DL', 2, 'HuggingFace Transformers', 3), ('ML / DL', 2, 'CNNs', 4),
('ML / DL', 2, 'NLP', 5), ('ML / DL', 2, 'Text classification', 6), ('ML / DL', 2, 'OCR', 7),
('Data engineering', 3, 'Python (Pandas, NumPy)', 1), ('Data engineering', 3, 'SQL', 2), ('Data engineering', 3, 'PostgreSQL', 3),
('Data engineering', 3, 'Supabase', 4), ('Data engineering', 3, 'ETL workflows', 5), ('Data engineering', 3, 'BullMQ', 6), ('Data engineering', 3, 'Large-scale data cleaning', 7),
('Backend & cloud', 4, 'Node.js', 1), ('Backend & cloud', 4, 'Express.js', 2), ('Backend & cloud', 4, 'FastAPI', 3), ('Backend & cloud', 4, 'REST APIs', 4),
('Backend & cloud', 4, 'Prisma ORM', 5), ('Backend & cloud', 4, 'Google Apps Script', 6), ('Backend & cloud', 4, 'Vercel', 7),
('Backend & cloud', 4, 'Google OAuth 2.0', 8), ('Backend & cloud', 4, 'SAML SSO', 9),
('Frontend & tools', 5, 'React', 1), ('Frontend & tools', 5, 'Vite', 2), ('Frontend & tools', 5, 'TypeScript', 3), ('Frontend & tools', 5, 'Tailwind CSS', 4),
('Frontend & tools', 5, 'Zustand', 5), ('Frontend & tools', 5, 'Git', 6), ('Frontend & tools', 5, 'Postman', 7), ('Frontend & tools', 5, 'Power BI', 8);

INSERT INTO experience (role, company, date_range, location, bullets, sort_order) VALUES
(
  'Program Coordinator', 'Connect & Heal', '2025 – Present', 'Bengaluru',
  ARRAY[
    'Built a Go Lives Tracker — an automated data pipeline and ops dashboard in Google Apps Script processing 100+ client records, with 11 BI summary tables and 9 dynamically-generated charts, replacing a fully manual reporting process.',
    'Engineered a multi-trigger automated notification system (3× daily, Sunday-aware) and integrated Sheets API v4 for structured email extraction.',
    'Built an automated Google Slides export pipeline generating branded 9-slide stakeholder presentations end to end from raw data.',
    'Automated large-scale data cleaning in Python — extracted, parsed, and normalised city/state across 10,000+ address records; delivered SQL-style analysis supporting cross-functional decisions.',
    'Worked on SAML SSO integration, gaining applied exposure to enterprise authentication and identity flows.'
  ], 1
),
(
  'Data Analyst Intern', 'National Institute of Technology, Tiruchirappalli', '2023 · 2–3 months', 'Tiruchirappalli',
  ARRAY[
    'Designed a Power BI dashboard visualising departmental academic performance metrics for faculty and administrative stakeholders.',
    'Performed data cleaning and preparation in Excel and Python — standardised inconsistent formats and restructured raw records into analysis-ready datasets.'
  ], 2
);

INSERT INTO education (degree, institution, date_range, note, sort_order) VALUES
('M.Sc. Data Science', 'Christ (Deemed to be University), Bangalore', '2023–2025', 'CGPA 8.5', 1),
('B.Sc. Mathematics, Electronics & Computer Science', 'Jyoti Nivas College, Bangalore', '2020–2023', 'CGPA 8.5', 2);

INSERT INTO certifications (name, issuer, sort_order) VALUES
('Google ML Crash Course', 'Google', 1),
('Deep Learning', 'Infosys Springboard', 2),
('Introduction to Unix', 'Linux Foundation', 3);
