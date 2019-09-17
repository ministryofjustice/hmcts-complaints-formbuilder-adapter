class SendComplaintJob < ApplicationJob
  queue_as :send_complaints

  def perform(form_builder_payload:)
    Usecase::Optics::CreateCase.new(
      optics_gateway: gateway,
      presenter: Presenter::Complaint.new(form_builder_payload: form_builder_payload),
      get_bearer_token: bearer_token
    ).execute
  end

  private

  def bearer_token
    Usecase::Optics::GetBearerToken.new(
      optics_gateway: gateway,
      generate_jwt_token: generate_token
    )
  end

  def generate_token
    Usecase::Optics::GenerateJwtToken.new(
      endpoint: Rails.configuration.x.optics.endpoint,
      api_key: Rails.configuration.x.optics.api_key,
      hmac_secret: Rails.configuration.x.optics.secret_key
    )
  end

  def gateway
    @gateway ||= Gateway::Optics.new(endpoint: Rails.configuration.x.optics.endpoint)
  end
end