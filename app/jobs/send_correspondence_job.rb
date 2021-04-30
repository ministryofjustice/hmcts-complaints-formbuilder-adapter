class SendCorrespondenceJob < ApplicationJob
  queue_as :send_correspondences

  def perform(form_builder_payload:)
    Rails.logger.info('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7')
    Rails.logger.info('submitter payload')
    Rails.logger.info(form_builder_payload)
    Rails.logger.info('submitter payload')
    Rails.logger.info('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7')
    presenter = Presenter::Correspondence.new(
      form_builder_payload: form_builder_payload
    )

    Usecase::Optics::CreateCase.new(
      optics_gateway: gateway,
      presenter: presenter,
      get_bearer_token: bearer_token
    ).execute

    record_successful_submission(form_builder_payload[:submissionId])
  end
end
