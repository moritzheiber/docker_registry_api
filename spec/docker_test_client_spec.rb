require 'rspec'
require 'serverspec'
require 'docker_registry_api'

set :backend, :exec
temp_path = Dir.pwd + '/images'

describe "docker test client" do

	before do
        client = DockerRegistryApi::Client.new(:uri => 'https://registry.hub.docker.com')
        client.pull('library/alpine', '3.5')
    end

    describe file(temp_path + '/library/alpine/3.5/manifest.mf') do
        it { should be_file }
        #its(:content) { should match /sha256:0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b/ }
    end

    describe file(temp_path + '/library/alpine/3.5/sha256:0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b') do
        #it { should be_file }
        #it "correct sha 256 sum" do
        #    expect(subject.sha256sum).to eq('0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b')
        #end
    end

end