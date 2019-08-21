# sportdb-source-footballdata - download & import 22+ top football leagues from 25 seasons back to 1993/94 from Joseph Buchdahl's Football Data website (football-data.co.uk) up and running since 2001 (and updated twice a week)


* home  :: [github.com/yorobot/football.csv](https://github.com/yorobot/football.csv)
* bugs  :: [github.com/yorobot/football.csv/issues](https://github.com/yorobot/football.csv/issues)
* gem   :: [rubygems.org/gems/sportdb-source-footballdata](https://rubygems.org/gems/sportdb-source-footballdata)
* rdoc  :: [rubydoc.info/gems/sportdb-source-footballdata](http://rubydoc.info/gems/sportdb-source-footballdata)
* forum :: [opensport](http://groups.google.com/group/opensport)


## What's Joseph Buchdahl's Football Data?

[Joseph Buchdahl](https://twitter.com/12Xpert) has been publishing football data
at the [`football-data.co.uk`](https://www.football-data.co.uk/data.php) website
in the world's most popular tabular data interchange format in text, that is,
comma-separated value (.csv) records for (bulk) download (and offline usage) since 2001 (!).

The main top football leagues include:

- England (`E0`, `E1`, `E2`, `E3` & `EC`) - Premiership & Divs 1, 2, 3 & Conference
- Scotland  (`SC0`, `SC1`, `SC2` & `SC3`) - Premiership & Divs 1, 2 & 3
- Germany (`D1` & `D2`) - Bundesligas 1 & 2
- Italy (`I1` & `I2`) - Serie A & B
- Spain (`SP1` & `SP2`) - La Liga (Primera & Segunda)
- France (`F1` & `F2`) -  Le Championnat & Division 2
- Netherlands (`N1`) - Eredivisie
- Belgium (`B1`) - Pro League
- Portugal (`P1`) - Liga I
- Turkey (`T1`) - Ligi 1
- Greece (`G1`) -  Ethniki Katigoria

And the extra leagues include:

- Argentina (`ARG`) - Primera Division
- Austria (`AUT`) -  Bundesliga
- Brazil (`BRA`) -  Serie A
- China (`CHN`) - Super League
- Denmark (`DNK`) -  Superliga
- Finland (`FIN`) -  Veikkausliiga
- Ireland (`IRL`) - Premier Division
- Japan (`JPN`) -  J-League
- Mexico (`MEX`) -  Liga MX
- Norway (`NOR`) -  Eliteserien
- Poland (`POL`)-  Ekstraklasa
- Romania (`ROU`) -  Liga 1
- Russia (`RUS`) - Premier League
- Sweden (`SWE`) -   Allsvenskan
- Switzerland (`SWZ`) -  Super League
- USA (`USA`) -  Major League Soccer (MLS)


The top football leagues include 25 seasons back to 1993/94
and get at least updated twice weekly
(Sunday nights and Wednesday nights).

## Usage

Let's download all datasets (about 570+) for offline usage into the `./dl` directory:

``` ruby
require 'sportdb/source/footballdata'

Footballdata.download
```

Stand back ten feet. Resulting in:

```
./dl
│   ARG.csv
│   AUT.csv
│   BRA.csv
│   CHN.csv
│   DNK.csv
│   FIN.csv
│   IRL.csv
│   JPN.csv
│   MEX.csv
│   NOR.csv
│   POL.csv
│   ROU.csv
│   RUS.csv
│   SWE.csv
│   SWZ.csv
│   USA.csv
│
├───1993-94
│       D1.csv
│       D2.csv
│       E0.csv
│       E1.csv
│       E2.csv
│       E3.csv
│       F1.csv
│       I1.csv
│       N1.csv
│       SP1.csv
│
├───1994-95
│       D1.csv
│       D2.csv
│       E0.csv
│       E1.csv
│       E2.csv
│       E3.csv
│       F1.csv
│       G1.csv
│       I1.csv
│       N1.csv
│       P1.csv
│       SC0.csv
│       SC1.csv
│       SP1.csv
│       T1.csv
...
├───2018-19
│       B1.csv
│       D1.csv
│       D2.csv
│       E0.csv
│       E1.csv
│       E2.csv
│       E3.csv
│       EC.csv
│       F1.csv
│       F2.csv
│       G1.csv
│       I1.csv
│       I2.csv
│       N1.csv
│       P1.csv
│       SC0.csv
│       SC1.csv
│       SC2.csv
│       SC3.csv
│       SP1.csv
│       SP2.csv
│       T1.csv
│
└───2019-20
        B1.csv
        D1.csv
        D2.csv
        E0.csv
        E1.csv
        E2.csv
        E3.csv
        EC.csv
        F1.csv
        F2.csv
        N1.csv
        P1.csv
        SC0.csv
        SC1.csv
        SC2.csv
        SC3.csv
        SP1.csv
        SP2.csv
        T1.csv
```

The football datasets come in two flavors / formats.
The main leagues use season-by-season datafiles.
For example, `E0.csv`, `E1.csv`, `E2.csv`, `E3.csv` & `E4.csv` in the `2019-20`
season directory hold the matches for the English Premiership & Divs 1, 2, 3 & Conference;
`D1.csv` & `D2.csv` for the Bundesligas 1 & 2 and so on.

The extra leagues use an all-seasons-in-one datafile.
For example, `ARG.csv`
holds all seasons of the Argentinian Primera Division;
`AUT.csv` for the Austrian Bundesliga and so on.


Note: The datasets character encoding gets converted from
ISO-8859-1 (Windows-1252) to UTF-8 (Unicode).


Less is More?

You can download datasets for selected countries only. Pass in
the country keys as symbols. Let's download only England (`eng`)'s leagues:

``` ruby
Footballdata.download( :eng )
```

Or let's download only the top five leagues, that is,
England (`eng`), Spain (`es`), Germany (`de`), France (`fr`)
and Italy (`it`):

``` ruby
Footballdata.download( :eng, :es, :de, :fr, :it )
```

Now what? Let's import all football datasets (in the `./dl` directory)
into an SQL database.


``` ruby
SportDb.connect( adapter:  'sqlite3',
                 database: './football.db' )

## build database schema / tables
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

Footballdata.import
```

That's it. Enjoy the beautiful game.




## License

The `sportdb-source-footballdata` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!

