PaperTrail.config.serialized_attributes = false

# Monkey patch to prevent a
# ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  relation "versions" does not exist
# see: https://github.com/airblade/paper_trail/issues/125
PaperTrail::Version.module_eval do
  self.abstract_class = true
end