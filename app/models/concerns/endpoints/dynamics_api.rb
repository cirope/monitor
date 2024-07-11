module Endpoints::DynamicsApi
  extend ActiveSupport::Concern

  def dynamics_process
    process_companies
  end

  def get_client
    @client ||= client.client_credentials.get_token(
      scope: 'https://api.businesscentral.dynamics.com/.default'
    )
  end

  def process_companies
    response = get_client.get(
      "https://api.businesscentral.dynamics.com/v2.0/#{directory_id}/Production/api/v2.0/companies"
    )

    if body = JSON.parse(response.body)
      account_name = Account.current.take.name.parameterize
      account_path = File.join "#{Rails.root}/endpoints/#{account_name}"
      csv_path     = File.join account_path, 'companies.csv'
      companies    = body.fetch 'value'

      FileUtils.mkdir_p account_path

      companies.each do |company|
        company_name = company.fetch 'name'
        company_path = File.join account_path, company_name

        FileUtils.mkdir_p company_path
      end

      CSV.open(csv_path, 'w') do |csv|
        companies.each_with_index do |hash, idx|
          csv << hash.keys   if idx == 0
          csv << hash.values
        end
      end
    end
  end

  private

    def client
      OAuth2::Client.new(
        client_id,
        client_secret,
        site: 'https://login.microsoftonline.com/',
        token_url: "/#{directory_id}/oauth2/v2.0/token"
      )
    end
end
