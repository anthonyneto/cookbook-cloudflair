module CloudflairCookbook
  class CloudflairDns < CloudflairBase
    require_relative 'helpers_dns'

    resource_name :cloudflair_dns
    provides :cloudflair_dns

    include CloudflairHelpers::Dns

    property :dns_name, String, name_property: true
    property :zone, String
    property :type, String
    property :content, String
    property :ttl, Integer, default: 1
    property :proxied, Boolean, default: false

    default_action :create

    load_current_value do |desired|
      desired_fqdn = if desired.dns_name == desired.zone
                       desired.dns_name
                     else
                       "#{desired.dns_name}.#{desired.zone}"
                     end
      begin
        get_zone(desired.zone)
        get_record(zone_data.id, desired_fqdn, desired.type)
        node.run_state['zone_data'] = zone_data
        node.run_state['record_data'] = record_data
        raise if zone_data.nil? || record_data.nil?
      rescue
        current_value_does_not_exist!
      end
      dns_name desired.dns_name
      zone zone_data.name
      type record_data.type
      content record_data.content
      ttl record_data.ttl
      proxied record_data.proxied
    end

    declare_action_class.class_eval do
      def call_action(action)
        send("action_#{action}")
        load_current_resource
      end
    end

    action :create do
      zone_data = node.run_state['zone_data']
      record_data = node.run_state['record_data']
      converge_if_changed do
        options = {
          name: new_resource.fqdn,
          type: new_resource.type,
          content: new_resource.content,
          ttl: new_resource.ttl,
          proxied: new_resource.proxied,
        }
        if record_data.nil?
          create_record(zone_data.id, options)
        else
          update_record(zone_data.id, record_data.id, options.to_json)
        end
      end
    end

    action :delete do
      zone_data = node.run_state['zone_data']
      record_data = node.run_state['record_data']
      return unless record_data
      converge_by "deleting record #{record_data.name}" do
        delete_record(zone_data.id, record_data.id)
      end
    end
  end
end
