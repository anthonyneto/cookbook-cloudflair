module CloudflairCookbook
  class CloudflairCredentials < CloudflairBase
    property :email, String, name_property: true
    property :key, String

    default_action :set

    action :set do
      Cloudflair.configure do |config|
        config.cloudflare.auth.key = new_resource.key
        config.cloudflare.auth.email = new_resource.email
      end
    end
  end
end
