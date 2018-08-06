# encoding: utf-8


class TxtMatchWriter

DE_WEEKDAY = {
  1 => 'Mo',
  2 => 'Di',
  3 => 'Mi',
  4 => 'Do',
  5 => 'Fr',
  6 => 'Sa',
  7 => 'So',
}


def self.write( path, matches, title:, round:, lang: nil)

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exists?( File.dirname( path ))


  out = File.new( path, 'w:utf-8' )


  out << "###################################\n"
  out << "# #{title}\n"# '


  last_round = nil
  last_date  = nil

  matches.each do |match|
     if match.round != last_round
       out << "\n\n"
       out << "#{round} #{match.round}\n"
     end

     if match.round != last_round || match.date != last_date

       date = Date.strptime( match.date, '%Y-%m-%d' )

       date_buf = ''
       date_buf << DE_WEEKDAY[date.cwday]
       date_buf << ' '
       date_buf << date.strftime( '%-d.%-m.' )

       out << "[#{date_buf}]\n"
     end

     out << '  '
     out << "%-23s" % match.team1    ## note: use %-s for left-align
     out << ' - '
     out << ("%-23s" % match.team2).strip    ## remove trailing spaces (w7 strip)
     out << "\n"

     last_round = match.round
     last_date  = match.date
  end
end # method self.write


end # class TxtMatchWriter
