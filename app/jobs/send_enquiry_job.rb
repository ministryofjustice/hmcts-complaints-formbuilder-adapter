class SendEnquiryJob < ApplicationJob
  queue_as :send_enquiries

  def perform(form_builder_payload:)
    presenter = Presenter::Enquiry.new(form_builder_payload:)

    Usecase::Optics::CreateCase.new(
      optics_gateway: gateway,
      presenter:,
      get_bearer_token: bearer_token
    ).execute

    record_successful_submission(form_builder_payload[:submissionId])
  end
end
