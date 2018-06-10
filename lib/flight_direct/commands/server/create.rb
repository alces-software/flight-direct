
module FlightDirect
  module Commands
    module Server
      class Create < Command
        def run
          install_yum_packages
          write_apache_git_config
          create_git_repository
          restart_apache
        end

        private

        # TODO: Make this a ENV variable and export in 'profile.d'
        def git_dir
          '/var/www/git'
        end

        def create_git_repository
          puts 'Creating apache git repository'
          FileUtils.mkdir_p git_dir
        end

        def install_yum_packages
          puts 'Installing apache'
          `yum -y -e0 install httpd`
        end

        # TODO: Once 'git_dir' is an ENV variable, break this out into a separate file
        # that is copied into place
        def write_apache_git_config
          puts 'Writing flight-direct apache conf'
          config = <<-CONF.strip_heredoc
            # Git over HTTP
            <VirtualHost *:80>
              SetEnv GIT_PROJECT_ROOT #{git_dir}
              SetEnv GIT_HTTP_EXPORT_ALL
              ScriptAlias /git/ /usr/libexec/git-core/git-http-backend/

              <Location /git/>
                Order Deny,Allow
                Deny from env=AUTHREQUIRED

                AuthType Basic
                AuthName "Git Access"
                Require group committers
                Satisfy Any
              </Location>
            </VirtualHost>
          CONF
          File.write('/etc/httpd/conf.d/flight-direct-git.conf', config)
        end

        def restart_apache
          puts 'Restarting the apache server'
          `systemctl restart httpd.service`
        end
      end
    end
  end
end
