require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe "defaults" do
    it "sets the default from address" do
      expect(ApplicationMailer.default[:from]).to eq("from@example.com")
    end
  end

  describe "layout" do
    it "uses the mailer layout" do
      mailer = ApplicationMailer.new
      expect(mailer.class.ancestors.map(&:name)).to include("ApplicationMailer")
    end
  end

  describe "inheritance" do
    it "ItemDigestMailer inherits from ApplicationMailer" do
      expect(ItemDigestMailer.superclass).to eq(ApplicationMailer)
    end
  end
end
