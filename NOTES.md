# Notes

## Todos

- [ ] remove CountryUtils.key from sportdb-text - no longer used? - why? why not?


deutschland

- [ ]  add a new csv (in-place) updater - double checks results and dates AND updates spieltag /rounds   or half-time results if missing (using ? for missing)


all / general

- [ ]  on import flag teams as clubs (!) and NOT the default as national teams

- fix/todo: change all level keys to (always) numbers/integers !!! e.g. 1,2,3, etc.
  - do NOT use strings (anywhere/anymore) !!!
  - use division for a string version e.g. "1", "2", "3", "3a", "3b", etc.

- matches.csv format
  - check auto-added week number - add plus one (+1!!!) Jan 2 is week 1 (not 0)

- summary writer seasons
  - check missing seasons if more than one level (and level for lower leagues are missing in the last seasons) e.g. check france, espana, ...

- add option for adjusting date (w/ hour) by timezone (offset)
  - see mx-mexico !!! (uses UTC by default e.g. 1:00am, 23:00, etc. ??)
