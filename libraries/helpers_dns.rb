module CloudflairCookbook
  module CloudflairHelpers
    module Dns
      require 'faraday'
      def action_type(x = :create)
        x
      end

      def fqdn
        if dns_name == zone
          dns_name
        else
          "#{dns_name}.#{zone}"
        end
      end

      def zone_data
        @zone_data
      end

      def record_data
        @record_data
      end

      def get_zone(zone_name)
        @zone_data = Cloudflair.zones(name: zone_name).first
      end

      def get_record(zone_id, fqdn, type)
        @record_data = Cloudflair.zone(zone_id).dns_records(name: fqdn, type: type).first
      end

      def create_record(zone_id, options)
        Cloudflair.zone(zone_id).new_dns_record(options)
      end

      def delete_record(zone_id, record_id)
        Cloudflair.zone(zone_id).dns_record(record_id).delete
      end

      def update_record(zone_id, record_id, data)
        Faraday.new(url: Cloudflair.config.cloudflare.api_base_url).put do |f|
          f.url "/client/v4/zones/#{zone_id}/dns_records/#{record_id}"
          f.headers['X-Auth-Key'] = Cloudflair.config.cloudflare.auth.key
          f.headers['X-Auth-Email'] = Cloudflair.config.cloudflare.auth.email
          f.headers['Content-Type'] = 'application/json'
          f.body = data
        end
      end
    end
  end
end
