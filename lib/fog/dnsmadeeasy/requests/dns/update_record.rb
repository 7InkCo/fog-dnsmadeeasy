module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Update the given record for the given domain.
        #
        # ==== Parameters
        # * domain<~String> - domain numeric ID
        # * record_id<~String>
        # * options<~Hash> - optional
        #   * type<~String>
        #   * content<~String>
        #   * priority<~Integer>
        #   * ttl<~Integer>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'record'<~Hash> The representation of the record.
        def update_record(domain, record_id, options)
          body = options

          request(
            :body     => Fog::JSON.encode(body),
            :expects  => 200,
            :method   => "PUT",
            :path     => "/V2.0/dns/managed/#{domain}/records/#{record_id}"
          )
        end
      end

      class Mock
        def update_record(domain, record_id, options)
          record = self.data[domain].find { |record| record["id"] == record_id }
          response = Excon::Response.new

          if record.nil?
            response.status = 400
          else
            response.status = 200
            record.merge!(options)
            response.body = record
          end

          response
        end
      end
    end
  end
end
