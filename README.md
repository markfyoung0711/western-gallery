# western-gallery

A gallery site for a working artist. Two modes, one file, no backend.

- **Viewer** — `index.html` — what visitors see: the collection arranged the way you arranged it.
- **Designer** — `index.html#admin` — where you upload artwork, arrange it, and export.

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

## Designer

Open `#admin`. Left rail is the work list and inspector, right side is a live
preview of the actual site — edits appear there as you type.

- **Upload** — drop images on the panel, or click to choose. Dimensions in inches
  are guessed from the photo's proportions; correct them in the inspector.
- **Arrange** — drag rows in the work list. That order is the order visitors see.
- **Edit** — title, subject, medium, size, year, price, status, show flag, and the
  story paragraph that appears in Show Preview.
- **Gallery tab** — gallery name, tagline, inquiry email, the format the site opens
  in, and the next show's name, booth and dates.
- **Export for the repo** — downloads `gallery-export.zip`.

Work in progress is saved to this browser as you go (metadata in `localStorage`,
images in IndexedDB), so you can close the tab and come back. Nothing is published
until you export and commit.

## Publishing

1. In the designer, click **Export for the repo**.
2. Unzip `gallery-export.zip` into the repo root. It contains `collection.json` and
   a `photos/` folder.
3. Commit and push. GitHub Pages serves the update in a minute or so.

`collection.json` is the published collection; the viewer fetches it on load. Until
it exists, the site shows generated stand-in paintings so the layouts are visible.

A local draft takes priority over `collection.json` in your own browser, with a
banner saying so — that is your unpublished work, not what visitors see. **Discard
draft** in the Gallery tab clears it.

## Notes

`#admin` is a convenience, not a lock. The site is static, so anyone can open that
URL — but they are only editing their own browser's copy, and the published site
contains exactly what you committed. Nothing a visitor does can change it.

Inquiries currently hand the composed message to the visitor's email client. To
collect them properly, point the form at a form service (Formspree, Basin, Netlify
Forms) and replace the `mailto:` line in the submit handler with a `fetch()` POST.
