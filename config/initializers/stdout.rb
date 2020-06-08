# frozen_string_literal: true

class ThreadedStringIO < StringIO
  def write string
    out.write string
  end

  private

    def out
      RequestStore.store[:stdout] || STDOUT
    end
end

$stdout = ThreadedStringIO.new
