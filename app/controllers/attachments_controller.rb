class AttachmentsController < ActionController::API
  def show
    attachment = Attachment.find_by(identifier: params.fetch(:id))
    decrypted_file_data = Cryptography.new(
      encryption_key: Base64.strict_decode64(attachment.encryption_key),
      encryption_iv: Base64.strict_decode64(attachment.encryption_iv)
    ).decrypt(file: fetch_file(attachment.url))

    send_data decrypted_file_data, type: attachment.mimetype,
                                   disposition: "attachment; filename=#{attachment.filename}"
  end

  private

  def fetch_file(url)
    HTTParty.get(url).body
  end
end
