module Scripts::Cores
  extend ActiveSupport::Concern

  def support_cores?
    ruby? || python?
  end

  module ClassMethods
    def cores language
      where language: language, core: true
    end
  end

  private

    def add_cores_code
      StringIO.new.tap do |buffer|
        self.class.cores(language).where.not(id: id).distinct.each do |script|
          buffer << script.body('core inclusion')
        end
      end.string
    end
end
