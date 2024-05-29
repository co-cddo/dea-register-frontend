require "rails_helper"

RSpec.describe LogUpdates, type: :service do
  subject { described_class.new(time:) }
  let(:time) { Time.zone.now }
  let(:agreement) { create :agreement }

  describe ".after" do
    it "returns nil if no changes" do
      expect(described_class.after(time)).to be_nil
    end

    it "returns an update_log if changes occurred" do
      time
      agreement
      expect { described_class.after(time) }.to change(UpdateLog, :count).by(1)
    end
  end

  describe "#update_log" do
    it "returns nil if no changes" do
      expect(subject.update_log).to be_nil
    end

    it "creates a new update log is a change is made" do
      subject
      agreement
      expect { subject.update_log }.to change(UpdateLog, :count).by(1)
    end

    it "records the report and time in the update log" do
      subject
      agreement
      update_log = subject.update_log
      expect(update_log.comment).to eq(subject.report)
      expect(update_log.updated_on).to eq(time.to_date)
    end
  end

  describe "#report" do
    it "is absent if no changes" do
      expect(subject.report).to be_nil
    end

    it "gives number of created arguments" do
      subject
      agreement
      expect(subject.report).to eq("1 Agreement created.")
    end

    it 'pluralizes "Agreements" if more than one created' do
      subject
      number = (2..10).to_a.sample
      create_list :agreement, number
      expect(subject.report).to eq("#{number} Agreements created.")
    end

    it "gives ids of updated agreements" do
      agreement
      subject # initialize after agreement creation
      agreement.update!(name: "Foo")
      expect(subject.report).to eq("0 Agreements created. Additionally, entries with the following ID numbers have been updated: #{agreement.fields['ID']}")
    end

    it 'lists ids with "and" if multiple updated' do
      agreements = create_list :agreement, 3
      subject
      agreements.each_with_index { |a, i| a.update(name: "Foo #{i}") }
      expect(subject.report).to include(agreements.last.fields["ID"].to_s)
      expect(subject.report).to match(/updated:\s\d+,\s\d+,\sand\s\d+/)
    end

    it "gives ids of updated agreements as well as number of created agreements" do
      agreement
      subject # initialize after creation of agreement to be updated
      create :agreement
      agreement.update!(name: "Foo")
      expect(subject.report).to eq("1 Agreement created. Additionally, entries with the following ID numbers have been updated: #{agreement.fields['ID']}")
    end
  end

  describe "#changes?" do
    it "is false if nothing has changed" do
      expect(subject.changes?).to be_falsey
    end

    context "with changes" do
      it "is true if an agreement is created" do
        subject # initialize to set time
        agreement
        expect(subject.changes?).to be_truthy
      end

      it "is true if agreement is updated" do
        agreement
        subject # initialize after agreement creation
        agreement.update!(name: "Foo")
        expect(subject.changes?).to be_truthy
      end
    end
  end

  describe "#number_created" do
    it "is zero if none created" do
      expect(subject.number_created).to be_zero
    end

    it "is the number created" do
      subject
      create_list :agreement, 3
      expect(subject.number_created).to eq(3)
    end
  end

  describe "#updated_ids" do
    it "is empty if none updated" do
      expect(subject.updated_ids).to be_empty
    end

    it "is empty if some created but not updated" do
      subject
      agreement
      expect(subject.updated_ids).to be_empty
    end

    it "contains ID of updated agreements" do
      agreement
      subject # initialize after agreement creation
      agreement.update!(name: "Foo")
      expect(subject.updated_ids).to contain_exactly(agreement.fields["ID"])
    end
  end
end
