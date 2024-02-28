$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'redox'

require 'minitest/autorun'
require 'webmock/minitest'
require 'byebug'

Redox.configuration.api_key = '123'
Redox.configuration.secret = 'abc'
Redox.configuration.fhir_client_id = '123456' * 5
Redox.configuration.fhir_private_key = {
  "p": "7JnNtPpHFQtqRx25HuOAiyLcJ4B_Ol8pYytSitB2C24NJMm9DPV-rhG78c0Q1ZmU9QoPq_wo_QjlrLM35Pux6vOcbMNvqRl4zP5YJNJvSgvz4CGrmLsNqSBPryxOlNf1pnJ3XVFLlIJKy1A1EHJHFPFVVQ8gfXbFmdLQx0jwba8",
  "kty": "RSA",
  "q": "uup7I0MPcFjsonGFbaobTr1bmL_e5IxntmQUuwdn7eoNA-dUTcBlyzbHAV4Ar08Z-kU8DEuac7RGaN2OTXmeO94EBwYs9L2RK0YWZEvZT47ziAno5GsHGIL-JyTjEiUzQGlUFCZy4djcnaL6_JBCrz_lyw5vdQPTbR1jzEnsI_s",
  "d": "rAmW1B9Zqwr4JwTg2nDW-rXP4u1sGr8kQ1G0NlZFfljdBYHRgx1mWk0Cs7GhOKmH1Ux-Sv9EjkiPcejjsYbbMTaUkfg5JMdpz8SFpM6T0gXW9ip3PqhyurtHiSVaGegBlqs9AKUha7nyQGPbwS5XAqkOnwyIggBPQi7PKV6qg2Pp8vTmDaDNDDd73f-AQzfrmRwuJuQ2v2h36hzWUXsN4zlFgHF7UZXxn9f9KN9r90sP_yW3Hijwl38PlbgLXLO4GjTQtBNToaoXHJBtSUB-VirGs9N4hwesJzbF5Hdcs63zrgri_rcumtQ3VHYDehAsee_Qik9EScRVjF3hmDKBGQ",
  "e": "AQAB",
  "use": "sig",
  "kid": "sig-1708984111",
  "qi": "VQTe48obuLv-NxRAfEBqdN_VOPLjbCAA2_y5xDqHW9hiryb5uAjOoRYVa_BZdSvWDe4XiYyBOnmuQPqC3kdB6Fo0yL2K0bkv5u4OvTN2E7oaq7iBzAukutkfA-Da5gvDSvabeUes_2bGc5mKdKgRSQT1Qzp1wn3qSuw0Sng6IQ",
  "dp": "Y5vQ7btch7CZmr0ZvbZb3LfdZcgESEfd_cE0a_qdZ-x6Hh3MuJL2NUSEEqWZy8Nv4cXNmUN84iKHxzBgfMe2PMs49NVGwjNWFz-RTldFwS_NCXRDcPZ3JtfSlFYb8zAEXIHeXOwn3KsJ4BSxcm4aHOgJW9kVfZyuTjdh7DR5_EM",
  "alg": "RS384",
  "dq": "pysQ6C-QvkT5lir7T2IkvB5Erm9jtHoSQ6Bsnfz4qWJ7M3OQBV2-bKnX_9QHvsJ7FEcZdlGjmDmyAxWrsITFzPs6FOIkENr923r6iccAWtQZ4CAkxy0lknmNPosR_meA1-mbxc3BT1X5sY5S9NE8oqn-JcYKTtgWHm97kvjGFkM",
  "n": "rMB12gIcA_DLKEF88Rf4s9p7Bn4oFnLsN5iaevgtlLEuPSNSRbRtw3eFDwoxqqzCtC5cfQlvgSdVNlemC4q5BzdiMh2mYnxt0wLidCq9tK44u9eKvXOBNXRjBNwDSrrspEIRWi8_5kA1svjen9asmwuXgeYoTQoR4Vm9_pBQFofWYJQIjNEzdPD0G9o2_haqOP0nto8kQtJXsYQAkyDZPoZXhCr7gIt4n5pq7DvUXzT39qHrdZ3b2pTBCmgcTrKBWwpMVOOKWXlCa0sPjb_xD83QC70UUAMuSMdJg-5rPzEy-A_Sn9DnIBny6V8KgfnS6t81pmYS6db5ltO9Zw53lQ"
}.to_json

# HTTParty has added a really annoying deprecation warning in 0.18.1
#  that flags even though we aren't using the method and is using
#  the Kernel.warn method. Turning it off for test environment
module HTTParty
  class Response < Object
    private

    def warn_about_nil_deprecation
    end
  end
end

def patient_admin_responses(event_type = :patient_update, parse: true)
  if (:patient_update == event_type)
    return load_sample('patient_search_single_result.response.json', parse: parse)
  else
    return load_sample("#{event_type}.response.json", parse: true)
  end
end

def load_sample(file, parse: false)
  file = File.join('test', 'samples', file)
  file_contents = nil

  if (false == File.exist?(file))
    raise "Can't find file '#{file}'."
  end

  file_contents = File.read(file)

  if (true == parse)
    if (true == file.end_with?('.json'))
      return JSON.parse(file_contents)
    end
  end

  return file_contents
end

def stub_redox(body:)
  body = body.to_json if body.is_a?(Hash)

  @auth_stub = stub_request(:post, /#{Redox::Authentication::AUTH_ENDPOINT}/)
    .to_return(status: 200, body: { access_token: 'let.me.in', expires_in: 300 }.to_json )

  @post_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Connection::DEFAULT_ENDPOINT))
    .to_return(status: 200, body: body)
end

def auth_stub
  @auth_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::Authentication::AUTH_ENDPOINT))
    .to_return(status: 200, body: { access_token: 'let.me.in', expires_in: 300, refreshToken: 'rtoken' }.to_json )
end

def legacy_stub_redox(status: 200, body:, endpoint: Redox::LegacyConnection::DEFAULT_ENDPOINT)
  body = body.to_json if body.is_a?(Hash)

  @legacy_auth_stub = stub_request(:post, /#{Redox::LegacyAuthentication::AUTH_ENDPOINT}/)
    .with(body: hash_including({ apiKey: '123', secret: 'abc' }))
    .to_return(status: 200,
               body: { accessToken: 'let.me.in',
                       expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT) }.to_json )

  @legacy_post_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::LegacyConnection::DEFAULT_ENDPOINT))
                 .with(headers: { 'Authorization' => 'Bearer let.me.in' })
                 .to_return(status: 200, body: body)
end

def legacy_auth_stub
  @legacy_auth_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::LegacyAuthentication::AUTH_ENDPOINT))
                 .with(body: { apiKey: '123', secret: 'abc' })
                 .to_return(status: 200,
                            body: { accessToken: 'let.me.in',
                                    expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT),
                                    refreshToken: 'rtoken' }.to_json )
end

def legacy_refresh_stub
  @legacy_refresh_stub = stub_request(:post, File.join(Redox.configuration.api_endpoint, Redox::LegacyAuthentication::REFRESH_ENDPOINT))
                    .with(body: { apiKey: '123', refreshToken: 'rtoken' })
                    .to_return(status: 200,
                               body: { accessToken: 'let.me.in.again',
                                       expires: (Time.now + 60).utc.strftime(Redox::Models::Meta::TO_DATETIME_FORMAT),
                                       refreshToken: 'rtoken' }.to_json )
end

class Minitest::Spec
  after do
    # clean stubbed requests
    remove_request_stub(@legacy_auth_stub) if @legacy_auth_stub
    remove_request_stub(@legacy_post_stub) if @legacy_post_stub
    remove_request_stub(@legacy_refresh_stub) if @legacy_refresh_stub

    remove_request_stub(@auth_stub) if @auth_stub
    remove_request_stub(@post_stub) if @post_stub
  end
end
