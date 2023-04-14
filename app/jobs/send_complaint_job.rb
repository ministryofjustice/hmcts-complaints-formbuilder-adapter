class SendComplaintJob < ApplicationJob
  queue_as :send_complaints

  def perform(form_builder_payload:)
    Rails.logger.info("Working on job_id: #{job_id}")

    attachments = Usecase::SpawnAttachments.new(
      form_builder_payload:
    ).call
    presenter = Presenter::Complaint.new(
      form_builder_payload:,
      attachments:
    )

    Usecase::Optics::CreateCase.new(
      optics_gateway: gateway,
      presenter:,
      get_bearer_token: bearer_token
    ).execute

    record_successful_submission(form_builder_payload[:submissionId])
  end
end
