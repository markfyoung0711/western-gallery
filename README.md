# western-gallery

A single-file gallery site for a working artist. No build step, no backend —
`index.html` is the whole site.

**Live:** https://markfyoung0711.github.io/western-gallery/

## What it does

Visitors browse the collection by subject (animals, people, buildings,
landscapes) and switch the same works between five hang formats:

| Format | Best for |
| --- | --- |
| Salon Hang | First impressions — framed works on a wall, varied sizes |
| Masonry | Instagram traffic — true proportions, endless scroll |
| Catalog Grid | Buyers — uniform tiles with price and status |
| Show Preview | Pre-show emails — one work large, story beside it |
| Price List | Collectors and galleries — medium, size, year, price |

Three inquiry paths run off every work: purchase, hold it for the next show,
and commission. Light and dark themes both ship.

## Putting real work in it

Everything lives in the `works` array near the top of the `<script>` block:

```js
{id:1, t:'Morning Remuda', cat:'animals', motif:'horse',
 med:'Oil on linen', w:36, h:24, yr:2025, price:6800,
 status:'available', show:true}
```

- `cat` — one of `animals`, `people`, `buildings`, `landscapes`
- `w` / `h` — inches; drives both the printed size and the on-screen proportion
- `status` — `available` or `sold`; a sold piece offers a commission instead of a buy button
- `show` — `true` puts it in the Show Preview collection

Photographs replace the generated placeholders: add `img:'photos/morning-remuda.jpg'`
to a record and the `src()` function uses it instead of drawing one. Shoot the work
straight on, in consistent light, longest edge around 2000px.

Show details (name, booth, dates) are in the `SHOW` object just below `works`.

## Receiving inquiries

The demo hands the composed message to the visitor's email client, which works
but loses anything the visitor doesn't send. To collect them properly, point the
form at a form service (Formspree, Basin, Netlify Forms) and replace the
`mailto:` line in the submit handler with a `fetch()` POST.

Change `studio@example.com` to the real studio address either way.
