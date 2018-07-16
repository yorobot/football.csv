# encoding: utf-8


class CsvSummaryReport   ## change to CsvPackageSummaryReport - why? why not?

def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end

def build_summary
  buf = ''
  buf << "# Summary\n\n"
  buf << CsvPyramidReport.new( @pack ).build_summary
  buf << "\n\n"
  buf << CsvTeamsReport.new( @pack ).build_summary
  buf << "\n\n"
  buf
end


def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end



## convenience helper
def write
  ## use "default"  package root and filename for path e.g. ./SUMMARY.md
  root = @pack.expand_path( '.' )
  path = "#{root}/SUMMARY.md"
  save( path )
end


end # class CsvSummaryReport
