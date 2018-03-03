#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'net/http'

cfg_format = ARGV[0]

if !['hcl','json'].include?(cfg_format)
    raise ArgumentError, 'Unsupported terraform config format'
end

while true do
    sleep 5
    # Must be somedomain.net instead of somedomain.net/, otherwise, it will throw exception.
    Net::HTTP.start("candidateexercise.s3-website-eu-west-1.amazonaws.com") do |http|
        resp = http.get("/exercise1.yaml")
        open("config.yaml", "w") do |file|
            file.write(resp.body)
        end
    end

    cnf = YAML.load_file('config.yaml')

    keys = Hash.new
    instances = Hash.new

    resources =
        {
            'resource' =>
                {
                    'aws_key_pair' => keys,
                    'aws_instance' => instances,
                }
        }

    cnf['machines'].each do |key, val|
        k_name = "#{val['name']}-key"
        keys[val['name']] =
            {
                'key_name' => k_name,
                'public_key' => val['sshkey']
            }
        instances[val['name']] =
            {
                'ami' => val['ami'],
                'instance_type' => val['type'],
                'key_name' => k_name,
            }
    end

    if cfg_format == 'json'
        puts JSON.pretty_generate(resources)
    elsif cfg_format == 'hcl'
        resources['resource'].each do |res_t,res|
            res.each do |res_n,res_v|
                puts "  resource \"#{res_t}\" \"#{res_n}\" {"
                res_v.each do |key,val|
                    puts "    #{key} = #{val.to_json}"
                end
            puts "  }"
            end
        end
    end
end
