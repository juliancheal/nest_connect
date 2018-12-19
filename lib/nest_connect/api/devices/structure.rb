module NestConnect
  class API
    class Devices
      class Structure < API
        def initialize(structure_id)
          @structure_id = structure_id
        end

        def put(body)
          connection.put do |request|
            request.url(url)
            request.headers.merge!(headers)
            request.body = body
          end
        end

        def get
          connection.get do |request|
            request.url(url)
            request.headers.merge!(headers)
          end
        end

        private

          attr_reader :structure_id

          def url
            "devices/structures/#{structure_id}"
          end

          def headers
            {
              'Content-Type' => 'application/json',
              'Authorization' => "Bearer #{access_token}"
            }
          end
      end
    end
  end
end