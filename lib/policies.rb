module Policies
  include HTTParty

  def age_policy
    self.refused_policy = 'age' if age < 18
  end

  def score_policy
    # interest rate = commitment
    self.refused_policy = 'score' if score < 600
  end

  def commitment_policy
    self.refused_policy = 'commitment' if monthly_installment > income * commitment
  end

  def score
    response = HTTParty.post(
      ENV.fetch('API_URL') + + '/score',
      headers: {
        "x-api-key": ENV.fetch('API_KEY')
      },
      body: {
        "cpf": cpf
      }.to_json
    )

    return nil if response.code != 200

    JSON.parse(response.body)['score']
  end

  def commitment
    response = HTTParty.post(
      ENV.fetch('API_URL') + + '/commitment',
      headers: {
        'x-api-key' => ENV.fetch('API_KEY')
      },
      body: { cpf: cpf }.to_json
    )

    return nil if response.code != 200

    JSON.parse(response.body)['commitment']
  end
end
