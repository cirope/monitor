class Version < PaperTrail::Version
  self.table_name    = :versions
  self.sequence_name = :versions_id_seq
end
