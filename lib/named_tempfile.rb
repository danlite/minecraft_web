module NamedTempfile
  def self.open_tempfile(filename, file_opts)
    dir = Dir.mktmpdir

    begin
      yield File.new("#{dir}/#{filename}", file_opts)
    ensure
      FileUtils.remove_entry dir
    end
  end
end
