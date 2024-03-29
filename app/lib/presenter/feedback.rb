module Presenter
  class Feedback < BasePresenter
    REQUEST_METHOD = 'Online form'.freeze
    TYPE = 'UF144908'.freeze
    PARTY_CONTEXT = 'Main'.freeze

    def optics_payload
      {
        Type: TYPE,
        RequestDate: request_date,
        RequestMethod: REQUEST_METHOD,
        'External.RequestDate': request_date,
        'External.RequestMethod': REQUEST_METHOD,
        PartyContext: PARTY_CONTEXT,
        AssignedTeam: submission_answers.fetch(:whichpartofhmctswereyouincontactwith_autocomplete_1, ''),
        Details: submission_answers.fetch(:telluswhatwedidwell_textarea_1, '')
      }
    end
  end
end
