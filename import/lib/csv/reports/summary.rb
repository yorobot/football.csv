# encoding: utf-8


def build_summary_report( repo, path: )
  buf = ''
  buf << "# Summary\n\n"
  buf << build_seasons_report( repo, path: path )
  buf << "\n\n"
  buf << build_teams_report( repo, path: path)
  buf
end
