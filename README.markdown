Workon
======

A simple script to bootstrap your work day. It can:

- Launch your editor with the projects directory.
- Start a web server (Middleman, Passenger, Pow, Unicorn).
- Run Guard or Watchr.
- Display display commit history (currently only Git)
- Open your file manager with the projects directory
- Open the projects development page in your browser

        $ workon -h
        Usage: workon [options] project
          -w, --without ACTORS             Exclude unwanted actors
          -o, --only ACTORS                Only use certain actors
          -d, --dump-configuration         Dump workon configuration to project_path/.workonrc
              --host HOST                  Ping this host
              --port PORT                  Use this port for Middleman/Passenger
              --server SERVER              Use this server (auto,middleman,passenger,pow,unicorn)
              --install-helper             Install `wo' helper function to ~/.bash_profile
          -P, --show-project               Echo project's directory
          -n, --dry-run                    Do not run any commands
          -v, --version                    Show version information
          -h, --help                       Show this help information

More to come ...
