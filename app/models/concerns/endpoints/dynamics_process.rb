module Endpoints::DynamicsProcess
  extend ActiveSupport::Concern

  def dynamics_process
    process_companies

    entities = {
      customers:        {},
      purchaseInvoices: {},
      salesInvoices:    { '$expand': 'salesInvoiceLines' },
      vendors:          {}
    }

    entities.each do |entity, options|
      process_entity entity, options
    end
  end

  private

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
        json_path = File.join account_path, 'companies.json'
        companies = body.fetch 'value'
        session   = { companies: [] }

        companies.each do |company|
          company_id   = company.fetch 'id'
          company_name = company.fetch 'name'

          FileUtils.mkdir_p company_path(company_name)

          session[:companies] << { id: company_id, name: company_name }
        end
        update session: session

        write_json json_path, companies
      end
    end

    def process_entity entity, options
      Array(session['companies']).each do |company|
        json_path = File.join company_path(company['name']), "#{entity}.json"
        uri       = URI.parse "#{base_url}/companies\(#{company['id']}\)/#{entity}"
        uri.query = URI.encode_www_form(options) if options.present?

        response = client.get uri.to_s

        if body = JSON.parse(response.body)
          values = body.fetch 'value'

          write_json json_path, values
        end
      end
    end

    def write_json json_path, json_text
      File.open(json_path, 'w') do |f|
        f.write JSON.pretty_generate(json_text)
      end
    end

    def oauth2_client
      OAuth2::Client.new(
        client_id,
        client_secret,
        site:      'https://login.microsoftonline.com/',
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
