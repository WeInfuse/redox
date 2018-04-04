module Redox
  # Redox API client
  class Client
    include RequestHelpers

    attr_reader(
      :source, :destinations, :test,
      :access_token, :refresh_token, :response
    )
    # Instantiates a new Redox Client object
    #
    # @param [Hash] source source information
    # @param [Array<Hash>] destinations list of destinations
    # @param [Boolean] test whether to use test mode
    # @param [String] Optional param to provide an existing Access Token
    # @param [String] Optional param to provide an existing Refresh Token
    # @example
    #   redox = Redox::Client.new(
    #     source: source,
    #     destinations: destinations,
    #     test: true,
    #     OPTIONAL: (If tokens/refresh_tokens are being persisted elsewhere)
    #     token: (existing access token),
    #     refresh_token: (existing refresh token)
    #   )
    def initialize(
      source:, destinations:, test: true, token: nil, refresh_token: nil
    )
      @refresh_token = refresh_token
      @access_token = token || fetch_access_token

      @source = source
      @destinations = destinations
      @test = test
    end

    # Send PatientAdmin#NewPatient message
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   Redox::Client.new(*connection_params).add_patient(
    #     Identifiers: [],
    #     Demographics: {
    #       FirstName: 'Joe'
    #     }
    #   )
    def add_patient(patient_params)
      request_body = request_meta(
        data_model: 'PatientAdmin',
        event_type: 'NewPatient'
      ).merge(Patient: patient_params.redoxify_keys)
      handle_request(request_body, 'Error in Patient New.')
    end

    def update_patient(patient_params)
      request_body = request_meta(
        data_model: 'PatientAdmin',
        event_type: 'PatientUpdate'
      ).merge(Patient: patient_params.redoxify_keys)
      handle_request(request_body, 'Error updating Patient.')
    end

    # Send PatientSearch#Query message
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   Redox::Client.new(*connection_params).search_patient(
    #     demographics: {
    #       FirstName: 'Joe'
    #       ...
    #     }
    #   )
    def search_patient(patient_params)
      request_body = request_meta(
        data_model: 'PatientSearch',
        event_type: 'Query'
      ).merge(Patient: patient_params.redoxify_keys)
      handle_request(request_body, 'Error in Patient Search.')
    end

    # Send ClinicalSummary#PatientQuery message
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   Redox::Client.new(*connection_params).search_patient(
    #     identifiers: [
    #       {
    #         id: '4681'
    #         id_type: 'AthenaNet Enterprise ID'
    #       }
    #     ]
    #   )
    def get_summary_for_patient(patient_params)
      request_body = request_meta(
        data_model: 'Clinical Summary',
        event_type: 'PatientQuery'
      ).merge(Patient: patient_params.redoxify_keys)
      handle_request(
        request_body,
        'Error fetching Patient Clinical Summary'
      )
    end

    # Send Scheduling#BookedSlots message
    #
    # @param [Hash] visit data to send in the Visit JSON object
    # @param [String|Time] start datetime to search from
    # @params [String|Time] end datetime to search until
    # @return [Hash] parsed response object
    # @example
    #   Redox::Client.new(*connection_params).get_booked_slots(
    #     visit: {
    #       reason?: string
    #       attending_providers: Provider[]
    #       location: {
    #         type: string
    #         facility: string
    #         department: string | number
    #         room: string | number
    #       }
    #     }
    #    start_time?: Time | String (ISO-8601 Time String)
    #    end_time?: Time | String (ISO-8601 Time String)
    # )
    def get_booked_slots(visit:, start_time: nil, end_time: nil)
      request_body = scheduling_query(
        visit: visit,
        start_time: start_time,
        end_time: end_time
      )
      handle_request(
        request_body,
        'Error fetching Booked Slots'
      )
    end
  end
end
