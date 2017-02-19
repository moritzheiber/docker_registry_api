require 'rspec'
require 'serverspec'
require 'docker_registry_api'

set :backend, :exec
image_path = Dir.pwd + '/images'
FileUtils.remove_dir(image_path)

describe DockerRegistryApi do

    context "with public docker registry" do
    
        before do
            @client = DockerRegistryApi::Client.new(:uri => 'https://registry.hub.docker.com')
        end

        describe ".layer_exists" do

            it "should return false for invalid layer digest" do
                expect(@client.layer_exists('library/alpine', 'invalid_layer_digest')).to be false
            end
         
             it "should return true for existing layer digest" do
                expect(@client.layer_exists('library/alpine', 'sha256:0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b')).to be true
            end
        end

        context "when pulling alpine 3.5" do

            before(:all) do
                @client = DockerRegistryApi::Client.new(:uri => 'https://registry.hub.docker.com')
                @client.pull('library/alpine', '3.5')
            end

            describe file(image_path + '/library/alpine/3.5/manifest.mf') do
                it "is a file" do
                    expect(subject).to be_file
                end
                it "contains layer hash 'sha256:0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b'" do
                    expect(subject.content).to match(/sha256:0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b/)
                end         
            end

            describe file(image_path + '/library/alpine/3.5/sha256:0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b') do
                it { should be_file }
                it "correct sha 256 sum" do
                    expect(subject.sha256sum).to eq('0a8490d0dfd399b3a50e9aaa81dba0d425c3868762d46526b41be00886bcc28b')
                end
            end

        end
    end
end

