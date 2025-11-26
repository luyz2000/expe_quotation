require 'rails_helper'

RSpec.describe QuotationPdf, type: :report do
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:project) { create(:project, client: client, responsible: user) }
  let(:quotation) { create(:quotation, client: client, project: project, salesperson: user) }

  describe '#render' do
    it 'generates a PDF document' do
      pdf_generator = QuotationPdf.new(quotation)
      pdf_content = pdf_generator.render
      
      expect(pdf_content).to be_present
      expect(pdf_content).to be_a(String)
      expect(pdf_content.length).to be > 0
    end
  end
end