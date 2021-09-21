# Cloudflair
*This cookbook is not really maintained and so is the [cloudflair gem](https://github.com/ninech/cloudflair).*
Cookbook used to manage cloudflare dns.
Updated and tested to work with chef `15.17.4`

## Usage
The `cloudflair_credentials` resource has to be set before calling `cloudflair_dns` otherwise it will fail without a very descriptive error.
```
cloudflair_credentials 'CF_API_USER' do
  key 'CF_API_TOKEN'
end

cloudflair_dns 'example.com' do
  zone 'example.com'
  type 'CNAME'
  content 'subdomain.example.com'
  proxied false
end
```
