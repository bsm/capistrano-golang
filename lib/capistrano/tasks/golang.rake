namespace :go do

  desc "Prints the Go version on the target host"
  task :status do
    on roles(fetch(:go_roles)) do
      info capture(:go, "version")
    end
  end

  task :hook do
    goroot = fetch(:go_root)
    on roles(fetch(:go_roles)) do
      SSHKit.config.command_map.prefix[:go].unshift "GOROOT=#{goroot} PATH=#{goroot}/bin:$PATH"
    end
  end

  task :check do
    goroot = fetch(:go_root)
    on roles(fetch(:go_roles)) do
      if not test "[ -d #{goroot}/src ]"
        info "Downloading #{fetch :go_version}"
        execute :mkdir, "-p", goroot
        execute :curl, "-sSL #{fetch :go_source} | tar xvz --strip-components=1 -C #{goroot}"
      end

      if not test "[ -f #{goroot}/bin/go ]"
        info "Installing #{fetch :go_version}"
        within "#{goroot}/src" do
          with fetch(:go_install_env, {}) do
            execute :"./make.bash", %(--no-clean 2>&1)
          end
        end
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
    set :go_version, "go1.5"
    set :go_roles,   :all

    set :go_install_path, "~/.gos"
    set :go_install_env,  -> { {goroot_bootstrap: File.join(fetch(:go_install_path), "go1.4")} }
    set :go_archive,      "https://golang.org/dl/VERSION.src.tar.gz"

    set :go_root,   -> { File.join(fetch(:go_install_path), fetch(:go_version)) }
    set :go_source, -> { fetch(:go_archive).sub("VERSION", fetch(:go_version)) }
  end
end
