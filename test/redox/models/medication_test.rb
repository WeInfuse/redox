require 'test_helper'

class MedicationTest < Minitest::Test
  describe 'medications' do
    let(:med_data) {{
      order: {"ID": 1},
      lot_number: nil,
      start_date: nil,
      dose: { "Quantity": 1, "Units": 1 },
      route: { "Code": 1, "Name": "route_name" },
      components: [{ "Type": "Base", "Code": 1, "Name": "component_name", "Dose": { "Quantity": 1, "Units": 1} }],
      product: { "Code": 1, "Name": "product_name" },
      indications: [{ "Code": 1, "Codeset": "ICD-10" }],
      ordered_by: { "ID": 1 },
      administering_provider: { "ID": 1, "NPI": 1 },
    }}

    describe 'default' do
      let(:med) { Redox::Models::Medication.new(med_data) }

      it 'builds order' do
        assert_equal(1, med["Order"]["ID"])
      end

      it 'builds route' do
        assert_equal(1, med["Route"]["Code"])
        assert_equal("route_name", med["Route"]["Name"])
      end

      it 'builds dose' do
        assert_equal(1, med["Dose"]["Quantity"])
        assert_equal(1, med["Dose"]["Units"])
      end

      it 'builds components' do
        assert_equal("Base", med["Components"].first["Type"])
        assert_equal(1, med["Components"].first["Code"])
        assert_equal("component_name", med["Components"].first["Name"])
        assert_equal(1, med["Components"].first["Dose"]["Quantity"])
        assert_equal(1, med["Components"].first["Dose"]["Units"])
      end

      it 'builds ordered_by' do
        assert_equal(1, med["OrderedBy"]["ID"])
      end

      it 'builds indications' do
        assert_equal(1, med["Indications"].first["Code"])
        assert_equal("ICD-10", med["Indications"].first["Codeset"])
      end

      it 'builds administering_provider' do
        assert_equal(1, med["AdministeringProvider"]["ID"])
        assert_equal(1, med["AdministeringProvider"]["NPI"])
      end

    end
  end
end
