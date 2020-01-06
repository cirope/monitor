require 'test_helper'

class ExportableTest < ActiveSupport::TestCase
  setup do
    @exportable = Class.new { include Exportable }
  end

  test 'hash to zip' do
    a_csv          = CSV.generate { |csv| csv << ['test a'] }
    b_csv          = CSV.generate { |csv| csv << ['test b'] }
    hash_to_export = {
      'a.csv' => a_csv,
      'b.csv' => b_csv
    }

    path        = @exportable.hash_to_zip hash_to_export
    zipped_hash = Zip::File.open path, Zip::File::CREATE

    assert_equal 2, zipped_hash.entries.size
    assert_equal %w[a.csv b.csv], zipped_hash.entries.map(&:name).sort

    assert_equal a_csv, zipped_hash.read('a.csv')
    assert_equal b_csv, zipped_hash.read('b.csv')

    FileUtils.rm_f path
  end
end
