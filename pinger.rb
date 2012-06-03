#!/usr/bin/ruby

require 'rubygems'
require 'net/ping'

class Host
    @@pinger = Net::Ping::ICMP.new
    def initialize(name, ip)
        @name = name
        @ip = ip
    end
   def ping
        puts @name + " (#{@ip}): " + @@pinger.ping(@ip).to_s
    rescue
        puts "Error for #{@name} #{@ip}"
   end
end

begin
    x =  "Test"
    threads = Array.new

    host_map = {}
    hosts = []
    file = File.open('/etc/hosts') 
    file.each_line do |line|
        host_map[line.split(/\s+/)[0]] = line.split(/\s+/)[1]
    end
    host_map.each do |ip, name| 
        if name
            h = Host.new(name, ip)
            hosts.push(h)
            #puts name.upcase + " " +  ip 
        end
    end

    hosts.each do |h| 
         t = Thread.new  do
            h.ping
        end
        threads.push(t)
    end
    threads.each { |t| t.join}
end
