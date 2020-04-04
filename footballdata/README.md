# Football Data Updates

source <https://www.football-data.co.uk/data.php>

## Step 1

Download all datasets, use:

    ruby ./download.rb


## Step 2

Check all datasets for missing club names ?






## Todos

missing clubs:

```
8 errors:
["Berwick > Scotland",     ## in scottish league BUT in england!!
                           ## see https://en.wikipedia.org/wiki/Berwick_Rangers_F.C.
 "Heracles > Greece",  
 "Cabinteely > Ireland",
 "FC FC Voluntari > Romania",
 "Brage > Sweden",
 "Atlanta Utd > United States",
 "Inter Miami CF > United States",
 "Nashville SC > United States"]
```


fix error:

```
tr (turkey), eng (england)
*** !!!! wrong season format >>2019/20<<; exit; sorry
*** !!!! wrong season format >>2019/20<<; exit; sorry
```

```
ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/part_level.rb:46:in `build': undefined method `teams' for #<SportDb::Import::Configuration:0x3767bc8> (NoMethodError)
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/pyramid.rb:143:in `block in build'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/pyramid.rb:141:in `each'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/pyramid.rb:141:in `build'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/summary.rb:21:in `build'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/summary.rb:33:in `block in save'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/summary.rb:32:in `open'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/summary.rb:32:in `save'
        from ruby/gems/2.3.0/gems/sportdb-text-0.3.3/lib/sportdb/text/csv/reports/summary.rb:44:in `write'
        from ./convert.rb:78:in `write_summary'
        from ./convert.rb:85:in `<main>'
```


```
alphabets/0.1.2 on Ruby 2.3.3 (2016-11-21) 
date-formats/0.2.4 on Ruby 2.3.3 (2016-11-21) 
sportdb-langs/0.1.0 on Ruby 2.3.3 (2016-11-21) 
sportdb-formats/0.2.1 on Ruby 2.3.3 (2016-11-21) 
sportdb-countries/0.5.1 on Ruby 2.3.3 (2016-11-21) 
sportdb-clubs/0.4.3 on Ruby 2.3.3 (2016-11-21) 
sportdb-leagues/0.2.3 on Ruby 2.3.3 (2016-11-21) 
fifa/2019.11.27 on Ruby 2.3.3 (2016-11-21) 
footballdb-clubs/2019.12.16 on Ruby 2.3.3 (2016-11-21) 
footballdb-leagues/2019.12.16 on Ruby 2.3.3 (2016-11-21) 
sportdb-config/0.9.0 on Ruby 2.3.3 (2016-11-21) 
sportdb-text/0.3.3 on Ruby 2.3.3 (2016-11-21) 
  [TagDb.has_many_tags] adding taggings n tags has_many assocs to model >WorldDb::Model::Country<
  [TagDb.has_many_tags] adding taggings n tags has_many assocs to model >WorldDb::Model::StateBase<
  [TagDb.has_many_tags] adding taggings n tags has_many assocs to model >WorldDb::Model::CityBase<
ruby/gems/2.3.0/gems/sportdb-match-formats-0.1.0/lib/sportdb/match/formats/mapper.rb:19:in `<class:MapperV2>': undefined method `new' for SportDb::Struct:Module (NoMethodError)
        from ruby/gems/2.3.0/gems/sportdb-match-formats-0.1.0/lib/sportdb/match/formats/mapper.rb:9:in `<module:SportDb>'
        from ruby/gems/2.3.0/gems/sportdb-match-formats-0.1.0/lib/sportdb/match/formats/mapper.rb:3:in `<top (required)>'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/gems/2.3.0/gems/activesupport-5.2.4.1/lib/active_support/dependencies.rb:291:in `block in require'
        from ruby/gems/2.3.0/gems/activesupport-5.2.4.1/lib/active_support/dependencies.rb:257:in `load_dependency'
        from ruby/gems/2.3.0/gems/activesupport-5.2.4.1/lib/active_support/dependencies.rb:291:in `require'
        from ruby/gems/2.3.0/gems/sportdb-match-formats-0.1.0/lib/sportdb/match/formats.rb:9:in `<top (required)>'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/gems/2.3.0/gems/activesupport-5.2.4.1/lib/active_support/dependencies.rb:291:in `block in require'
        from ruby/gems/2.3.0/gems/activesupport-5.2.4.1/lib/active_support/dependencies.rb:257:in `load_dependency'
        from ruby/gems/2.3.0/gems/activesupport-5.2.4.1/lib/active_support/dependencies.rb:291:in `require'
        from ruby/gems/2.3.0/gems/sportdb-models-1.18.6/lib/sportdb/models.rb:9:in `<top (required)>'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/gems/2.3.0/gems/sportdb-import-0.2.4/lib/sportdb/import.rb:6:in `<top (required)>'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:68:in `require'
        from ruby/gems/2.3.0/gems/sportdb-source-footballdata-0.1.1/lib/sportdb/source/footballdata.rb:9:in `<top (required)>'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:127:in `require'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:127:in `rescue in require'
        from ruby/2.3.0/rubygems/core_ext/kernel_require.rb:40:in `require'
        from ./download.rb:6:in `<main>'
```