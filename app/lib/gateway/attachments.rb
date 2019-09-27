module Gateway
  class Attachments
    def delete_data_since(time_ago)
      attachments = Attachment.where("created_at < ?", time_ago).destroy_all
    end
  end
end
