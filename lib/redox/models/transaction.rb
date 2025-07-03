# frozen_string_literal: true

module Redox
  module Models
    class Transaction < AbstractModel
      property :Chargeable, required: false, from: :chargeable, default: {}
      property :DateTimeOfService, required: false, from: :start
      property :Department, required: false, from: :department, default: {}
      property :Diagnoses, required: false, from: :diagnoses, default: []
      property :EndDateTime, required: false, from: :end
      property :Extensions, required: false, from: :extensions, default: {}
      property :ID, required: false, from: :id
      property :NDC, required: false, from: :ndc, default: {}
      property :OrderID, required: false, from: :order_id
      property :OrderingProviders, required: false, from: :ordering_providers, default: []
      property :Performers, required: false, from: :performers, default: []
      property :Procedure, required: false, from: :procedure, default: {}
      property :Type, required: false, from: :type

      alias chargeable Chargeable
      alias start DateTimeOfService
      alias department Department
      alias diagnoses Diagnoses
      alias end EndDateTime
      alias extensions Extensions
      alias id ID
      alias ndc NDC
      alias order_id OrderID
      alias ordering_providers OrderingProviders
      alias performers Performers
      alias procedure Procedure
      alias type Type

      def add_medication(ndc_code: nil, quantity: nil, magnitude: nil, unit: nil, description: nil)
        self[:NDC] = { Code: ndc_code, Description: description }
        self[:Extensions] = {
          'ndc-quantity' => {
            integer: quantity&.to_s
          },
          'ndc-units-measure' => {
            coding: {
              code: magnitude&.to_s,
              display: unit
            }
          }
        }
        self
      end

      def add_ordering_provider(**kwargs)
        self[:OrderingProviders] ||= []
        self[:OrderingProviders] << OrderingProvider.new(kwargs)
        self
      end

      def add_performer(**kwargs)
        self[:Performers] ||= []
        self[:Performers] << OrderingProvider.new(kwargs)
        self
      end

      def to_h
        result = super.to_h

        %w[EndDateTime DateTimeOfService].each do |k|
          result[k] = Redox::Models.format_datetime(result[k])
        end

        result
      end

      def as_json(_args)
        to_h
      end
    end
  end
end
