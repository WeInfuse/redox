module Redox
  module Models
    class Patient < Model
      property :Identifiers, from: :identifiers, required: false, default: []
      property :Insurances, from: :insurances, required: false, default: []
      property :Demographics, from: :demographics, required: false
      property :Contacts, from: :contacts, required: false, default: []
      property :PCP, from: :primary_care_provider, required: false

      alias_method :identifiers, :Identifiers
      alias_method :insurances, :Insurances
      alias_method :contacts, :Contacts

      def demographics
        self[:Demographics] = Demographics.new(self[:Demographics]) unless self[:Demographics].is_a?(Redox::Models::Demographics)
        self[:Demographics] ||= Demographics.new
      end

      def insurances
        self[:Insurances] = self[:Insurances].map {|ins| ins.is_a?(Redox::Models::Insurance) ? ins : Insurance.new(ins) }
      end

      def primary_care_provider
        self[:PCP] ||= PCP.new
      end

      def contacts
        self[:Contacts] = self[:Contacts].map {|contact| contact.is_a?(Redox::Models::Contact) ? contact : Contact.new(contact)}
      end

      def add_identifier(type: , value: )
        self[:Identifiers] << Identifier.new({'ID' => value, 'IDType' => type})

        return self
      end

      def add_insurance(data = {})
        self[:Insurances] << Insurance.new(data)

        return self
      end

      def update(meta: Meta.new)
        Redox::Request::PatientAdmin.update(patient: self, meta: meta)
      end

      def create(meta: Meta.new)
        Redox::Request::PatientAdmin.create(patient: self, meta: meta)
      end

      class << self
        def query(params, meta: Meta.new)
          return Redox::Request::PatientSearch.query(params, meta: meta)
        end
      end
    end
  end
end
