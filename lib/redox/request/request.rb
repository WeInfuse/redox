module Redox
  module Request
    def self.build_body(params, meta)
      meta = Redox::Models::Meta.new.merge(meta)

      return meta.to_h.merge(params.to_h)
    end
  end
end
