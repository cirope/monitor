class ThreadedErrorStringIO < StringIO
  def write string
    out.write string
  end

  private

    def out
      RequestStore.store[:stderr] || STDERR
    end
end

$stderr = ThreadedErrorStringIO.new
