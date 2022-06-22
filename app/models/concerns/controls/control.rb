module Controls::Control
  extend ActiveSupport::Concern

  MESS = 'SYSTEM ERROR: method missing'

  def control
    raise MESS
  end
end
