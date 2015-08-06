module DatabasesHelper
  def properties
    @database.properties.new if @database.properties.empty?

    @database.properties
  end
end
