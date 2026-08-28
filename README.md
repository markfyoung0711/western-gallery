# western-gallery

A gallery site for a working artist. Static front end on GitHub Pages, Supabase
behind it for artwork, content and sign-in.

- **Viewer** — `index.html` — what visitors see.
- **Designer** — `index.html#admin` — upload artwork, arrange it, publish. Editing
  requires a signed-in account on the editor list; everyone else gets a sign-in card.

**Live:** https://markfyoung0711.github.io/western-gallery/

## Viewer

Visitors browse by subject (animals, people, buildings, landscapes) and switch the
same works between five hang formats:

| Format | Best for |
| --- | --- |
| Salon Hang | First impressions — framed works on a wall, varied sizes |
| Masonry | Instagram traffic — true proportions, endless scroll |
| Catalog Grid | Buyers — uniform tiles with price and status |
| Show Preview | Pre-show emails — one work large, story beside it |
| Price List | Collectors and galleries — medium, size, year, price |

Every work opens a detail sheet with three inquiry paths: purchase, hold it for the
next show, or commission. Light and dark themes both ship.

## Setup

Four steps, once.

**1. Create the Supabase project.** At supabase.com, new project, any region near you.

**2. Run the schema.** Open `supabase/schema.sql`, change the email on the line
marked `>>> EDIT THIS LINE <<<` to whichever address should be able to edit, then
paste the whole file into the SQL editor and run it. That creates the `works` and
`gallery_settings` tables, the `artwork` storage bucket, and the row-level security
policies. To add another editor later:

```sql
insert into public.admin_emails (email) values ('her@example.com');
```

**3. Point the site at it.** In `config.js`:

```js
window.SUPABASE_URL      = 'https://xxxxxxxx.supabase.co';
window.SUPABASE_ANON_KEY = 'eyJ...';
```

Both come from Settings → API in the Supabase dashboard. Both are safe to commit —
the anon key is a public client key, and every table is guarded by RLS. Commit and
push; Pages redeploys.

Then in Supabase, under Authentication → URL Configuration, set the site URL to
`https://markfyoung0711.github.io/western-gallery/` and add it to the redirect
allowlist, so sign-in links come back to the right place.

**4. Close public signup.** Authentication → Providers → Email, turn off *Allow new
users to sign up*. Then add each editor by hand under Authentication → Users → Add
user, with auto-confirm on. After that a sign-in request for any address that is not
already a user simply fails, so the magic-link endpoint cannot be used to mail links
to strangers. `admin_emails` still governs who can write — two independent gates.

Leave `config.js` empty and the site runs in local mode instead — a browser-only
draft plus an export button, no accounts. That is the fallback if Supabase is
unreachable, so the gallery never goes blank.

## Using the designer

Open `#admin`, enter your email, click the link that arrives. Sessions persist, so
that is a once-in-a-while thing.

- **Upload** — drop images on the panel. Each one is resized in the browser to a
  2000px web version and a 600px thumbnail before upload, so pages stay fast.
  Dimensions in inches are guessed from the photo's proportions; correct them.
- **Arrange** — drag rows in the work list. That order is the order visitors see.
- **Edit** — title, subject, medium, size, year, price, status, show flag, and the
  story paragraph that appears in Show Preview. Saves as you type.
- **Visible on the site** — new uploads start hidden so you can get the details
  right first. Tick it, or use **Publish n hidden** in the top bar, to go live.
- **Gallery tab** — gallery name, tagline, inquiry email, opening format, and the
  next show's name, booth and dates.

Changes are live the moment they save. No commit, no deploy, and it works from any
device she is signed in on.

## Security

- The anon key is public by design. Everything is enforced server-side by RLS:
  visitors can read published works and the settings row, and nothing else. Writes
  require a signed-in user whose email is in `admin_emails`.
- Unpublished works are invisible to visitors at the database level, not just hidden
  in the UI.
- `#admin` is reachable by anyone — it shows a sign-in card. Without an editor
  account there is nothing to see and nothing to change.

## Inquiries

Currently the composed message is handed to the visitor's email client. To collect
them properly, either point the form at a form service (Formspree, Basin) or add an
`inquiries` table with an insert-only RLS policy and write them straight to Supabase.
