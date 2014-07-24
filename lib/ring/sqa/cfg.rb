require 'asetus'

module Ring
  class SQA
    Directory = '/etc/ring-sqa'
    class InvalidConfig < StandardError; end
    class NoConfig < StandardError; end

    Config = Asetus.new name: 'sqa', load: false, usrdir: Directory, cfgfile: 'main.conf'
    Config.default.directory          = Directory
    Config.default.debug              = false
    Config.default.hosts.load         = %w( ring.nlnog.net )
    Config.default.hosts.ignore       = %w( infra.ring.nlnog.net )
    Config.default.port               = 'ring'.to_i(36)/100
    Config.default.analyzer.tolerance = 1.2
    Config.default.nodes_json         = '/etc/ring/nodes.json'
    Config.default.mtr.args           = '-i0.5 -c5 -r -w -n'
    Config.default.mtr.timeout        = 15
    Config.default.ram_database       = false
    Config.default.paste.url          = 'https://ring.nlnog.net/paste/'

    begin
      Config.load
    rescue => error
      raise InvalidConfig, "Error loading configuration: #{error.message}"
    end

    CFG = Config.cfg

    CFG.bind.ipv4 = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
    CFG.bind.ipv6 = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET6)[0][3]

    raise NoConfig, 'edit /etc/ring-sqa/main.conf' if Config.create
  end
end
