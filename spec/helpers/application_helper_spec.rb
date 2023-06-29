require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe ".sort_button" do
    subject(:sort_button) { helper.sort_button field, path, label: }
    let(:field) { :foo }
    let(:path) { root_path }
    let(:label) { "Bar" }
    let(:html) { Nokogiri::HTML(sort_button) }

    it "creates a button_to form" do
      expect(html.at("form")[:class]).to eq("button_to")
    end

    it "has an action matching the path" do
      expect(html.at("form")[:action]).to eq(path)
    end

    it "has a button labelled with the label text" do
      expect(html.at("button").inner_html).to eq(label)
    end

    it "has a sort_by attribute matching the field" do
      expect(html.at("input[name=sort_by][value=#{field}]")).to be_present
    end

    it "has a direction attribute set as ascending" do
      expect(html.at("input[name=direction][value=ascending]")).to be_present
    end

    context "when no label given" do
      let(:label) { nil }
      it "has uses the name for the label" do
        expect(html.at("button").inner_html).to eq(field.to_s.humanize)
      end
    end

    context "when the current direction for the field is ascending" do
      before do
        controller.params[:sort_by] = field.to_s
        controller.params[:direction] = "ascending"
      end

      it "does not have a direction attribute set as ascending" do
        expect(html.at("input[name=direction][value=ascending]")).not_to be_present
      end

      it "has a direction attribute set as descending" do
        expect(html.at("input[name=direction][value=descending]")).to be_present
      end
    end

    context "when the current direction for the field is descending" do
      before do
        controller.params[:sort_by] = field.to_s
        controller.params[:direction] = "descending"
      end

      it "does not have a direction attribute set as descending" do
        expect(html.at("input[name=direction][value=descending]")).not_to be_present
      end

      it "has a direction attribute set as ascending" do
        expect(html.at("input[name=direction][value=ascending]")).to be_present
      end
    end
  end

  describe ".sort_direction_for" do
    subject(:sort_direction_for) { helper.sort_direction_for field }
    let(:field) { :foo }
    let(:direction) { %w[ascending descending].sample }

    it "returns the direction as none" do
      expect(sort_direction_for).to eq(:none)
    end

    context "when sort direction is set for the field" do
      before do
        controller.params[:sort_by] = field.to_s
        controller.params[:direction] = direction
      end

      it "returns the direction" do
        expect(sort_direction_for).to eq(direction)
      end
    end
  end
end
