# frozen_string_literal: true

module PackageManager
  class Docker < Base
    HAS_VERSIONS = true
    HAS_DEPENDENCIES = false
    BIBLIOTHECARY_SUPPORT = true
    URL = "https://hub.docker.com/"
    COLOR = "#099cec"

    def self.package_link(package, version = nil)
      "https://hub.docker.com/r/#{package.name}"
    end

    def self.package(name)
      get("https://hub.docker.com/v2/repositories/#{name}/")
    end

    def self.mapping(package)
      package_name = "#{package["namespace"]}/#{package["name"]}"
      {
        name: package_name,
        description: package["description"],
        repository_url: load_repository_url(package_name)
      }
    end

    def self.versions(package, _name)
      # TODO pagination
      tags = get("https://hub.docker.com/v2/repositories/#{_name}/tags")
      p tags['results']
      tags['results'].map do |version|
        p version
        next if version["name"].match?(/latest/)
        {
          number: version["name"],
          published_at: version["last_updated"]
        }
      end.compact
    end

    def self.load_repository_url(name)
      json = get("https://hub.docker.com/api/build/v1/source/?image=#{name}")
      return unless json['objects']
      o = json['objects'].first
      return unless o['provider'] == 'Github'
      "https://github.com/#{o['owner']}/#{o['repository']}"
    end
  end
end
