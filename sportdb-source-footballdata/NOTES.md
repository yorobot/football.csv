# Notes


## Mapping of CSV Fields

See <https://www.football-data.co.uk/notes.txt> for the official list.

```
Key to results data:

Div = League Division
Date = Match Date (dd/mm/yy)
HomeTeam = Home Team
AwayTeam = Away Team
FTHG and HG = Full Time Home Team Goals
FTAG and AG = Full Time Away Team Goals
FTR and Res = Full Time Result (H=Home Win, D=Draw, A=Away Win)
HTHG = Half Time Home Team Goals
HTAG = Half Time Away Team Goals
HTR = Half Time Result (H=Home Win, D=Draw, A=Away Win)
```

Note: Not all datafiles follow the key. The real usage is:

```
{"Date"=>570,
 "Time"=>35,
 "HomeTeam"=>549, "HT"=>5, "Home"=>16,
 "AwayTeam"=>549, "AT"=>5, "Away"=>16,
 "FTHG"=>554,  "HG"=>16,
 "FTAG"=>554,  "AG"=>16,
 "HTHG"=>488,
 "HTAG"=>488 }
```

e.g. 
- `HomeTeam` is `Home` in 16 datafiles and `HT` in 5
- `AwayTeam` is `Away` in 16 datafiles and `AT` in 5
- ...

