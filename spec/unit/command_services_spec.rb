require 'spec_helper'

describe 'VMC::Cli::Command::Services' do

  include WebMock::API

  before(:all) do
    @local_target = VMC::DEFAULT_LOCAL_TARGET
    @auth_token = spec_asset('sample_token.txt')
  end

  before(:each) do
    # make sure these get cleared so we don't have tests pass that shouldn't
    RestClient.proxy = nil
    ENV['http_proxy'] = nil
    ENV['https_proxy'] = nil
  end

  it 'should return plans from services_plan when plans are configured' do
    info_path = "#{@local_target}/#{VMC::INFO_PATH}"
    stub_request(:get, info_path).to_return(File.new(spec_asset('info_authenticated.txt')))
    services_path = "#{@local_target}/#{VMC::Client.path(VMC::GLOBAL_SERVICES_PATH)}"
    stub_request(:get, services_path).to_return(File.new(spec_asset('services_with_plans.txt')))
    client = VMC::Client.new(@local_target, @auth_token)
    command = VMC::Cli::Command::Services.new(options)
    command.client(client)
    command.service_plans("filesystem").should == ["free", "charge"]
  end

  it 'should return empty array from services_plan when no service is configured' do
    info_path = "#{@local_target}/#{VMC::INFO_PATH}"
    stub_request(:get, info_path).to_return(File.new(spec_asset('info_authenticated.txt')))
    services_path = "#{@local_target}/#{VMC::Client.path(VMC::GLOBAL_SERVICES_PATH)}"
    stub_request(:get, services_path).to_return(File.new(spec_asset('services_with_plans.txt')))
    client = VMC::Client.new(@local_target, @auth_token)
    command = VMC::Cli::Command::Services.new(options)
    command.client(client)
    command.service_plans("redis").should == []
  end

  it 'should return empty array from services_plan when no plan is configured' do
    info_path = "#{@local_target}/#{VMC::INFO_PATH}"
    stub_request(:get, info_path).to_return(File.new(spec_asset('info_authenticated.txt')))
    services_path = "#{@local_target}/#{VMC::Client.path(VMC::GLOBAL_SERVICES_PATH)}"
    stub_request(:get, services_path).to_return(File.new(spec_asset('services_with_plans.txt')))
    client = VMC::Client.new(@local_target, @auth_token)
    command = VMC::Cli::Command::Services.new(options)
    command.client(client)
    command.service_plans("mysql").should == []
  end

end
