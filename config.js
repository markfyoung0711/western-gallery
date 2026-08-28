/* Supabase connection.
   Both values are safe to commit — the anon key is a public client key, and
   every table is guarded by row-level security (see supabase/schema.sql).
   Leave them empty and the site runs in local mode off collection.json. */
window.SUPABASE_URL = '';
window.SUPABASE_ANON_KEY = '';
