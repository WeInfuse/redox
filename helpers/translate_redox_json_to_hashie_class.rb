# frozen_string_literal: true

require 'active_support/inflector'
require 'json'

data = {
  Plan: {
    ID: '31572',
    IDType: 'Payor ID',
    Name: 'HMO Deductable Plan',
    Type: nil
  },
  MemberNumber: nil,
  Company: {
    ID: '60054',
    IDType: nil,
    Name: 'aetna (60054 0131)',
    Address: {
      StreetAddress: 'PO Box 14080',
      City: 'Lexington',
      State: 'KY',
      ZIP: '40512-4079',
      County: 'Fayette',
      Country: 'US'
    },
    PhoneNumber: '+18089541123'
  },
  GroupNumber: '847025-024-0009',
  GroupName: 'Accelerator Labs',
  EffectiveDate: '2015-01-01',
  ExpirationDate: '2020-12-31',
  PolicyNumber: '9140860055',
  AgreementType: nil,
  CoverageType: nil,
  Insured: {
    Identifiers: [],
    LastName: nil,
    FirstName: nil,
    SSN: nil,
    Relationship: nil,
    DOB: nil,
    Sex: nil,
    Address: {
      StreetAddress: nil,
      City: nil,
      State: nil,
      ZIP: nil,
      County: nil,
      Country: nil
    }
  }
}

props = []
aliases = []

data.each do |k, v|
  props << "property :#{k.to_sym}, required: false, from: :#{k.to_s.underscore.to_sym}"
  props.last << ', default: {}' if v.is_a?(Hash)
  props.last << ', default: []' if v.is_a?(Array)

  aliases << "alias_method :#{k.to_s.underscore.to_sym}, :#{k.to_sym}"
end

(props | [nil] | aliases).each do |v|
  puts "#{' ' * 6}#{v}"
end
