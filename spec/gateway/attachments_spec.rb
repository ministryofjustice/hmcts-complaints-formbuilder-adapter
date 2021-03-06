describe Gateway::Attachments do
  subject(:attachments_gateway) { described_class.new }

  let(:one_day_ago) { 1.day.ago.to_date }

  before do
    create_list(:attachment, 7, created_at: 10.days.ago)
    create_list(:attachment, 2, created_at: one_day_ago)
  end

  describe '#delete_data_since' do
    it 'removes all attachments more than 7 days old' do
      attachments_gateway.delete_data_since(7.days.ago)
      expect(Attachment.all.map(&:created_at).uniq).to eq([one_day_ago])
    end

    it 'returns the number of deleted items' do
      expect(attachments_gateway.delete_data_since(7.days.ago)).to eq(7)
    end
  end
end
