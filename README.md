# Our First Million — team morale board

A live tracker toward $1,000,000. The page reads `data.csv` from this
repo and renders the total, beaker, milestone ribbon, and stream pie.
No external services, no database — the CSV is the source of truth.

## Files
- `index.html` — the board (open in a browser via a served URL, not file://)
- `data.csv` — the data. Edit this to update the board.

## Go live on GitHub Pages
1. Put both files in a repo.
2. Settings → Pages → deploy from branch `main`, root folder.
3. Visit the Pages URL. Bookmark it for the team.

The board re-reads `data.csv` on every page load, so updating the file
+ reloading = updated board.

## The data format
`data.csv` has exactly three columns:

```
stream,amount,label
Embedded Leadership,30000,Client B
Meta,1.47,First payout
```

- **stream** — must be one of, spelled exactly:
  `Embedded Leadership`, `Handover Plan`, `Continuity Kit`,
  `Speaking & Services`, `Meta`
- **amount** — a number. `$` and commas are fine (`$30,000` works).
- **label** — a short note so you can spot double-entries. Commas OK
  if the label is wrapped in "quotes".

One row per payment received.

## Four ways to update the numbers
1. **GitHub web UI** — click `data.csv` → pencil icon → edit → commit.
   (Easiest for non-technical folks. Commit to a branch + merge, or
   straight to main.)
2. **Ask Claude Code** — "add a $10k Embedded Leadership payment to
   data.csv and push" — it'll handle the edit + commit.
3. **git** — edit locally, `git commit`, `git push`.
4. **curl** — run `./update-data.sh new-data.csv` (see that file for
   one-time token setup). Does the get-sha + put in one command.

## If the board says "no data"
It means `index.html` couldn't read `data.csv`. Check the file exists
in the repo and is named exactly `data.csv`. The board is intentionally
live-only: no file, no board (no fake fallback numbers).

## Editing gifs / colors
Open `index.html`. Near the top of the `<script>` you'll find
`CELEBRATION_GIFS`, `ENCOURAGEMENT_GIFS`, and `FALLBACK_GIF` — swap the
URLs. Colors are all hex values in the `<style>` block (see the palette
list you were given).
