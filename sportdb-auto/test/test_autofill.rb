# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_autofill.rb


require 'helper'


class TestAutoFill < MiniTest::Test

  def test_fr
txt  =<<TXT
=====================================
= French Ligue 1 2014/15
=====================================

# Matches Retour


Journée 19

[Ven 19. Déc]
  20h30  RC Lens  -  OGC Nice
[Sam 20. Déc]
  17h00  Paris SG    0-0  Montpellier Hérault SC
  20h00  SM Caen     1-1  SC Bastia
         FC Lorient  1-2  FC Nantes
         FC Metz     0-1  AS Monaco FC
         Stade Rennais FC  1-3  Stade de Reims
         Toulouse FC  1-1  EA Guingamp
[Dim 21. Déc]
  14h00  Olympique de Marseille  2-1  LOSC Lille
  17h00  AS Saint-Étienne  3-0  Évian TG
  21h00  Girondins de Bordeaux  0-5  Olympique Lyonnais


Journée 38

[Sam 23. Mai]
  20h00  Girondins de Bordeaux - Montpellier Hérault SC
  20h00  SM Caen - Évian TG
  20h00  RC Lens - FC Nantes
  20h00  FC Lorient - AS Monaco FC
  20h00  Olympique de Marseille - SC Bastia
  20h00  FC Metz - LOSC Lille
  20h00  Paris SG - Stade de Reims
  20h00  Stade Rennais FC - Olympique Lyonnais
  20h00  AS Saint-Étienne - EA Guingamp
  20h00  Toulouse FC - OGC Nice
TXT

txt_exp =<<TXT
=====================================
= French Ligue 1 2014/15
=====================================

# Matches Retour


Journée 19

[Ven 19. Déc]
  20h30  RC Lens  2-0  OGC Nice
[Sam 20. Déc]
  17h00  Paris SG    0-0  Montpellier Hérault SC
  20h00  SM Caen     1-1  SC Bastia
         FC Lorient  1-2  FC Nantes
         FC Metz     0-1  AS Monaco FC
         Stade Rennais FC  1-3  Stade de Reims
         Toulouse FC  1-1  EA Guingamp
[Dim 21. Déc]
  14h00  Olympique de Marseille  2-1  LOSC Lille
  17h00  AS Saint-Étienne  3-0  Évian TG
  21h00  Girondins de Bordeaux  0-5  Olympique Lyonnais


Journée 38

[Sam 23. Mai]
  20h00  Girondins de Bordeaux  2-1  Montpellier Hérault SC
  20h00  SM Caen  3-2  Évian TG
  20h00  RC Lens  1-0  FC Nantes
  20h00  FC Lorient  0-1  AS Monaco FC
  20h00  Olympique de Marseille  3-0  SC Bastia
  20h00  FC Metz  1-4  LOSC Lille
  20h00  Paris SG  3-2  Stade de Reims
  20h00  Stade Rennais FC  0-1  Olympique Lyonnais
  20h00  AS Saint-Étienne  2-1  EA Guingamp
  20h00  Toulouse FC  2-3  OGC Nice
TXT

    SportDb.connect( adapter:  'sqlite3',
                     database: '../build/fr_csv.db' )
    SportDb.tables


    filler = SportDb::AutoFiller.new( txt )
    txt_up, changelog = filler.autofill

    pp changelog
    ## puts txt_up

    assert_equal txt_up, txt_exp
  end
end # class TestAutoFill
