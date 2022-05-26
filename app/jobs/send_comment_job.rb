class SendCommentJob < ApplicationJob
  queue_as :send_comments

  def perform(form_builder_payload:)
    presenter = Presenter::Comment.new(
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