class ::Metrics::User < ::Metrics

  def self.saracatunga(resultado)
    resultado.each { |row| add row }
  end

  def self.add(row)
    metrics_increment row['user_id'], row['amount']
  end
end
