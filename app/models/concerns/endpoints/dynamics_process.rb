module Endpoints::DynamicsProcess
  extend ActiveSupport::Concern

  def dynamics_process
    process_companies

    [:vendors, :customers, :salesInvoices].each do |entity|
      process_entity entity
    end
  end

  def client
    @client ||= oauth2_client.client_credentials.get_token(
      scope: 'https://api.businesscentral.dynamics.com/.default'
    )
  end

  def base_url
    "https://api.businesscentral.dynamics.com/v2.0/#{directory_id}/Production/api/v2.0"
  end

  def process_companies
    response = client.get "#{base_url}/companies"

    if body = JSON.parse(response.body)
      csv_path  = File.join account_path, 'companies.csv'
      companies = body.fetch 'value'
      session   = { companies: [] }

      companies.each do |company|
        company_id   = company.fetch 'id'
        company_name = company.fetch 'name'

        FileUtils.mkdir_p company_path(company_name)

        session[:companies] << { id: company_id, name: company_name }
      end

      update session: session

      CSV.open(csv_path, 'w') do |csv|
        companies.each_with_index do |hash, idx|
          csv << hash.keys   if idx == 0
          csv << hash.values
        end
      end
    end
  end

  def process_entity entity
    Array(session['companies']).each do |company|
      csv_path = File.join company_path(company['name']), "#{entity}.csv"
      response = client.get "#{base_url}/companies\(#{company['id']}\)/#{entity}"

      if body = JSON.parse(response.body)
        vendors = body.fetch 'value'

        CSV.open(csv_path, 'w') do |csv|
          vendors.each_with_index do |hash, idx|
            csv << hash.keys   if idx == 0
            csv << hash.values
          end
        end
      end
    end
  end

  private

    def oauth2_client
      OAuth2::Client.new(
        client_id,
        client_secret,
        site: 'https://login.microsoftonline.com/',
        token_url: "/#{directory_id}/oauth2/v2.0/token"
      )
    end

    def account_path
      @account_path ||= create_account_path
    end

    def company_path company_name
      File.join account_path, company_name.parameterize
    end

    def create_account_path
      account_name = Account.current.take.name.parameterize
      account_path = File.join "#{Rails.root}/endpoints/#{account_name}/#{name.parameterize}"

      FileUtils.mkdir_p account_path

      account_path
    end
end
