class SessionElevator < Apartment::Elevators::Generic
  def parse_tenant_name request
    # request is an instance of Rack::Request
    Account.from_request request
  end
end
