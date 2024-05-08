module Scripts::Cores
  extend ActiveSupport::Concern

  def is_core?
    ruby? || python?
  end

  module ClassMethods
    def cores language
      where language: language, core: true
    end
  end

  private

    def add_cores_code_for language
      StringIO.new.tap do |buffer|
        self.class.cores(language).where.not(id: id).distinct.each do |script|
          buffer << script.body('core inclusion')
        end
      end.string
    end
end
