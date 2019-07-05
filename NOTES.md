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



## Argentina

has "mixed" seasons - switching between formats

FIX: do NOT auto-convert single-year season EVER to double-year season!!!

```
2012–13 2013–14 2014 2015 2016 2016–17 2017–18 2018–19 2019–20
```
see https://en.wikipedia.org/wiki/Template:Argentine_Primera_Divisi%C3%B3n
andd https://en.wikipedia.org/wiki/Argentine_Primera_Divisi%C3%B3n#History



##  Kicker 

Try double check / download match schedule

```
require 'nokogiri'

html = File.open( './at.html', 'r:utf8' ) { |f| f.read }

doc = Nokogiri::HTML( html )

https://www.kicker.de/eredivisie/spieltag/2019-20/-1                 ## nl
https://www.kicker.de/barclays-premier-league/spieltag/2019-20/-1    ## eng
https://www.kicker.de/liga-bbva/spieltag/2019-20/-1                  ## es
https://www.kicker.de/tipp3-bundesliga/spieltag/2019-20/-1           ## at
https://www.kicker.de/1-bundesliga/spieltag/2019-20/-1               ## de


##################################################################
- search for div with class="kick__v100-gameList"
   - h3 1. Spieltag
   - div class="kick__v100-gameList__gameRow__gameCell"

     <a class="kick__v100-gameCell__team
      <div class="kick__v100-gameCell__team__name">Rapid Wien</div>
      <div class="kick__v100-gameCell__team__shortname">Rapid Wien</div>

     <div class="kick__dateboard">
        <div class="kick__v100-scoreBoard__dateHolder">26.07.</div>
        <div class="kick__v100-scoreBoard__dateHolder">20:45</div>
     </div>

     <a class="kick__v100-gameCell__team
       <div class="kick__v100-gameCell__team__name">RB Salzburg</div>
       <div class="kick__v100-gameCell__team__shortname">Salzburg</div>
```

