# encoding: utf-8


class SummaryReport   ## change to CsvPackageSummaryReport - why? why not?

def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end

def build_summary
  buf = ''
  buf << "# Summary\n\n"
  buf << SeasonsReport.new( @pack ).build_summary
  buf << "\n\n"
  buf << TeamsReport.new( @pack ).build_summary
  buf
end

def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end

end # class SummaryReport
