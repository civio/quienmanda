# TODO: Configure search. See https://github.com/casecommons/pg_search

PgSearch.multisearch_options = {
  # Do we want to use :trigram and allow some typos? Not for now
  # :using => [:tsearch, :trigram],
  :ignoring => :accents
}