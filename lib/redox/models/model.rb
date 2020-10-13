module Redox
  module Models
    def self.format_datetime(d)
      if d.respond_to?(:strftime)
        d.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT)
      else
        d
      end
    end

    class AbstractModel < Hashie::Trash
      include Hashie::Extensions::IgnoreUndeclared
      include Hashie::Extensions::IndifferentAccess

      HIGH_LEVEL_KEYS = %w[Meta Patient Visit PotentialMatches]

      property :Meta, from: :meta, required: false
      property :Patient, from: :patient, required: false
      property :Visit, from: :visit, required: false
      property :PotentialMatches, from: :potential_matches, required: false
      property :Extensions, from: :extensions, required: false
      property :response, required: false

      alias_method :potential_matches, :PotentialMatches
      alias_method :patient, :Patient
      alias_method :visit, :Visit
      alias_method :meta, :Meta

      def to_json(args = {})
        return self.to_h.to_json
      end

      def insurances
        (self.patient&.insurances || []) + (self.visit&.insurances || [])
      end

      def self.from_response(response)
        model = Model.new
        model.response = response

        HIGH_LEVEL_KEYS.each do |k|
          begin
            model.send("#{k}=", Module.const_get("Redox::Models::#{k}").new(response[k])) if response[k]
          rescue
          end
        end

        return model
      end

      def self.from_response_inflected(response)
        model = self.from_response(response)

        if (model.response.ok?)
          data = model.response.parsed_response

          if data.respond_to?(:keys)
            model_class = nil

            if model.meta&.data_model
              model_class = "Redox::Models::#{model.meta.data_model}"

              begin
                model_class = Object.const_get(model_class)
              rescue NameError
                model_class = nil
              end
            end

            data.keys.each do |key|
              next if HIGH_LEVEL_KEYS.include?(key.to_s)

              helper_name = key.to_s.downcase.to_sym

              if model_class.nil?
                model.define_singleton_method(helper_name) { data[key] }
              else
                if data[key].is_a?(Array)
                  model.define_singleton_method(helper_name) { data[key].map {|obj| model_class.new(obj) } }
                else
                  model.define_singleton_method(helper_name) { model_class.new(data[key]) }
                end
              end
            end
          end
        end

        return model
      end
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

        super(data)
      end

      def to_h
        return { key => super.to_h }
      end

      private
      def key
        return self.class.to_s.split('::').last.to_s
      end
    end
  end
end
