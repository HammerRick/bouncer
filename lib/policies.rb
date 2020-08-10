module Policies
  include HTTParty

  # add a new policy method name here to it runs on every polices check
  @@policies_list = %i[age_policy score_policy commitment_policy]

  def run_policies
    @@policies_list.map do |policy|
      method(policy).call
    end

    self.status = 'completed'
    self.result = refused_policy.nil? ? 'approved' : 'refused'
  end

  def age_policy
    self.refused_policy = 'age' if age < 18
  end

  def score_policy
    self.refused_policy = 'score' if score < 600
  end

  def commitment_policy
    possible_terms = terms

    while possible_terms <= 12
      self.monthly_installment = monthly_installment_calculator(possible_terms)
      if monthly_installment < income * (1 - commitment)
        self.approved_terms = possible_terms
        break
      end

      possible_terms += 3
    end
    self.refused_policy = 'commitment' unless approved_terms
  end

  def age
    today = Date.today
    birthday_has_passed = today.month > birthdate.month || (today.month == birthdate.month && today.day >= birthdate.day)
    today.year - birthdate.year - (birthday_has_passed ? 0 : 1)
  end

  private

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

  def interest_rate_ranges
    case score
    when 900..1000
      { 6 => 3.9, 9 => 4.2, 12 => 4.5 }
    when 800..899
      { 6 => 4.7, 9 => 5.0, 12 => 5.3 }
    when 700..799
      { 6 => 5.5, 9 => 5.8, 12 => 6.1 }
    when 600..699
      { 6 => 6.4, 9 => 6.6, 12 => 6.9 }
    end
  end

  def monthly_installment_calculator(terms_count)
    return nil unless interest_rate_ranges

    i = interest_rate_ranges[terms_count] / 100
    full_rate = (1 + i)**terms_count
    installment = amount * (full_rate * i) / (full_rate - 1)
    installment.round(2)
  end
end
