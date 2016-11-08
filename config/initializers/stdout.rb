class ThreadedStringIO < StringIO
  def write string
    out.write string
  end

  private

    def out
      Thread.current[:stdout] || STDOUT
    end
end

$stdout = ThreadedStringIO.new
