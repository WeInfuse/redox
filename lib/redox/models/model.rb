# frozen_string_literal: true

module Redox
  module Models
    def self.format_datetime(date)
      if date.respond_to?(:strftime)
        date.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT)
      else
        date
      end
    end

    class AbstractModel < Hashie::Trash
      include Hashie::Extensions::IgnoreUndeclared
      include Hashie::Extensions::IndifferentAccess

      HIGH_LEVEL_KEYS = %w[Meta Patient Visit PotentialMatches].freeze

      property :Meta, from: :meta, required: false
      property :Patient, from: :patient, required: false
      property :Visit, from: :visit, required: false
      property :PotentialMatches, from: :potential_matches, required: false
      property :Extensions, from: :extensions, required: false
      property :response, required: false

      alias potential_matches PotentialMatches
      alias patient Patient
      alias visit Visit
      alias meta Meta

      def to_json(_args = {})
        to_h.to_json
      end

      def insurances
        (patient&.insurances || []) + (visit&.insurances || [])
      end

      def self.from_response(response)
        model = Model.new
        model.response = response

        # rubocop:disable Lint/SuppressedException
        HIGH_LEVEL_KEYS.each do |k|
          model.send("#{k}=", Module.const_get("Redox::Models::#{k}").new(response[k])) if response[k]
        rescue StandardError
        end
        # rubocop:enable Lint/SuppressedException

        model
      end

      def self.from_response_inflected(response)
        model = from_response(response)

        return model unless model.response.ok?

        data = model.response.parsed_response

        return model unless data.respond_to?(:keys)

        add_helpers(model, data)
      end

      def self.get_inflected_class(data_model)
        return if data_model.nil?

        model_class = "Redox::Models::#{data_model}"

        begin
          Object.const_get(model_class)
        rescue NameError
          nil
        end
      end

      # rubocop:disable Metrics/AbcSize
      def self.add_helpers(model, data)
        model_class = get_inflected_class(model.meta&.data_model)

        data.each_key do |key|
          next if HIGH_LEVEL_KEYS.include?(key.to_s)

          helper_name = key.to_s.downcase.to_sym

          if model_class.nil?
            model.define_singleton_method(helper_name) { data[key] }
          elsif data[key].is_a?(Array)
            model.define_singleton_method(helper_name) { data[key].map { |obj| model_class.new(obj) } }
          else
            model.define_singleton_method(helper_name) { model_class.new(data[key]) }
          end
        end

        model
      end
      # rubocop:enable Metrics/AbcSize
    end

    class Model < AbstractModel
      def initialize(data = {})
        if data.is_a?(Hash)
          if data.include?(key)
            data = data[key]
          elsif data.include?(key.to_sym)
            data = data[key.to_sym]
          end
        end

        super
      end

      def to_h
        { key => super.to_h }
      end

      private

      def key
        self.class.to_s.split('::').last.to_s
      end
    end
  end
end
