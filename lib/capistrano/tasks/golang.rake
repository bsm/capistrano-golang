namespace :go do

  desc "Prints the Go version on the target host"
  task :status do
    on roles(fetch(:go_roles)) do
      info capture(:go, "version")
    end
  end

  task :hook do
    target = File.join(fetch(:go_root), fetch(:go_version))

    on roles(fetch(:go_roles)) do
      SSHKit.config.command_map.prefix[:go].unshift "GOROOT=#{target} PATH=#{target}/bin:$PATH"
    end
  end

  task :check do
    target = File.join(fetch(:go_root), fetch(:go_version))

    on roles(fetch(:go_roles)) do
      if not test "[ -d #{target}/src ]"
        info "Downloading #{fetch :go_version}"
        execute :mkdir, "-p", target
        execute :curl, "-L #{fetch :go_source}/#{fetch :go_version}.tar.gz | tar xvz --strip-components=1 -C #{target}"
      end

      if not test "[ -f #{target}/bin/go ]"
        info "Installing #{fetch(:go_version)}"
        execute %(cd #{target}/src && ./make.bash)
      end
    end
  end

end

Capistrano::DSL.stages.each do |stage|
  after stage, 'go:hook'
end
after 'deploy:check', 'go:check'

namespace :load do
  task :defaults do
    set :go_version, "go1.4.1"
    set :go_root, "~/.gos"
    set :go_roles, :all
    set :go_source, "https://github.com/golang/go/archive"
  end
end
