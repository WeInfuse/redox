module RedoxEngine
  # RedoxEngine API client
  class Client
    include RequestHelpers

    attr_reader(
      :source, :destinations, :test,
      :access_token, :refresh_token, :response
    )
    # Instantiates a new RedoxEngine Client object
    #
    # @param [Hash] source source information
    # @param [Array<Hash>] destinations list of destinations
    # @param [Boolean] test_mode whether to use test mode
    # @param [String] access_token Optional param to provide an existing Access
    #                 Token
    # @param [String] refresh_token Optional param to provide an existing
    #                 Refresh Token
    # @example
    #   redox = RedoxEngine::Client.new(
    #     source: source,
    #     destinations: destinations,
    #     test_mode: true,
    #     OPTIONAL: (If tokens/refresh_tokens are being persisted elsewhere)
    #     token: (existing access token),
    #     refresh_token: (existing refresh token)
    #   )
    def initialize(
      source:, destinations:, test_mode: true, token: nil, refresh_token: nil
    )
      if [RedoxEngine.api_key, RedoxEngine.secret].any?(&:nil?)
        raise APIKeyError
      end
      @refresh_token = refresh_token
      @access_token = token || fetch_access_token

      @source = source
      @destinations = destinations
      @test = test_mode
    end

    # Send PatientAdmin#NewPatient message
    #
    # @param [Hash] patient_params data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   RedoxEngine::Client.new(*connection_params).add_patient(
    #     Identifiers: [{
    #       ID: string
    #       IDType: string
    #     }*],
    #     Demographics: {
    #       FirstName: string
    #       ...
    #     }
    #   )
    def add_patient(patient_params)
      request_body = request_meta(
        data_model: 'PatientAdmin',
        event_type: 'NewPatient'
      ).merge(Patient: patient_params.redoxify_keys)
      handle_request(request_body, 'Error in Patient New.')
    end

    # Send PatientAdmin#PatientUpdate message
    #
    # @param [Hash] <Patient> patient_params data to send in the
    #               Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   RedoxEngine::Client.new(*connection_params).update_patient(
    #     Identifiers: [{
    #       ID: string
    #       IDType: string
    #     }*],
    #     Demographics: {
    #       FirstName: string
    #       ...
    #     }
    #   )
    def update_patient(patient_params)
      request_body = request_meta(
        data_model: 'PatientAdmin',
        event_type: 'PatientUpdate'
      ).merge(Patient: patient_params.redoxify_keys)
      handle_request(request_body, 'Error updating Patient.')
    end

    # Send PatientSearch#Query message
    #
    # @param [Hash] <Patient> data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   RedoxEngine::Client.new(*connection_params).search_patient(
    #     demographics: {
    #       FirstName: string
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
    # @param [Hash] <Patient> data to send in the Patient JSON object
    # @return [Hash] parsed response object
    # @example
    #   RedoxEngine::Client.new(*connection_params).search_patient(
    #     identifiers: [
    #       {
    #         id: string
    #         id_type: string
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
    # NOTE: Endpoint not supported by all Health Systems, talk to your
    # redox rep for more information
    # @param [Hash] query_data to send in the <Visit>/<Patient> JSON objects
    # @param [String|Time] start_time datetime to search from
    # @params [String|Time] end_time datetime to search until
    # @return [Hash] parsed response object
    # @example
    #   RedoxEngine::Client.new(*connection_params).get_booked_slots(
    #     query_data: {
    #       visit: <Visit>
    #       patient: <Patient>
    #    }
    #    start_time?: Time | String (ISO-8601 Time String)
    #    end_time?: Time | String (ISO-8601 Time String)
    # )
    def get_booked_slots(visit:, patient: nil, start_time: nil, end_time: nil)
      request_body = scheduling_query(
        query_data: { visit: visit, patient: patient },
        start_time: start_time,
        end_time: end_time,
        type: 'Booked'
      )
      handle_request(
        request_body,
        'Error fetching Booked Slots.'
      )
    end

    # Send Scheduling#AvailableSlots message
    #
    # NOTE: Endpoint not supported by all Health Systems, talk to your
    # redox rep for more information
    # @param [Hash] query_data to send in the <Visit>/<Patient> JSON objects
    # @param [String|Time] start_time datetime to search from
    # @params [String|Time] end_time datetime to search until
    # @return [Hash] parsed response object
    # @example
    #   RedoxEngine::Client.new(*connection_params).get_available_slots(
    #     query_data: {
    #       visit: <Visit>
    #       patient: <Patient>
    #    }
    #    start_time?: Time | String (ISO-8601 Time String)
    #    end_time?: Time | String (ISO-8601 Time String)
    # )
    def get_available_slots(
      visit:, patient: nil, start_time: nil, end_time: nil
    )
      request_body = scheduling_query(
        query_data: { visit: visit, patient: patient },
        start_time: start_time,
        end_time: end_time,
        type: 'AvailableSlots'
      )
      handle_request(
        request_body,
        'Error fetching Available Slots.'
      )
    end
  end
end
