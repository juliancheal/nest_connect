require 'spec_helper'

RSpec.describe NestConnect::API::Devices::Thermostat do
  subject(:thermostat) { described_class.new(resource_id: 'device_id') }

  describe '#access_token' do
    it 'allows access_token to be overwritten' do
      subject = described_class.new(resource_id: 'device_id', access_token: '1234')

      expect(subject.access_token).to eql('1234')
    end
  end

  describe '#put' do
    it 'returns a response object' do
      global_config.access_token = 'foo'
      stub_put_request_success

      subject = thermostat.put({target_temperature_f: 70})

      expect(subject.status).to eql(200)
    end
  end

  describe '#get' do
    it 'returns a response object' do
      global_config.access_token = 'foo'
      stub_get_request_success

      subject = thermostat.get

      expect(subject.status).to eql(200)
    end
  end

  describe '#all' do
    it 'returns a response object' do
      global_config.access_token = 'foo'
      stub_all_request_success

      subject = thermostat.all

      expect(subject.status).to eql(200)
    end
  end

  def stub_put_request_success
    stub_request(:put, "https://developer-api.nest.com/devices/thermostats/device_id").
      with(
        body: "{\"target_temperature_f\":70}",
        headers: {
          'Authorization'=>'Bearer foo',
          'Content-Type'=>'application/json',
        }).
      to_return(status: 200, body: "", headers: {})
  end

  def stub_get_request_success
   stub_request(:get, "https://developer-api.nest.com/devices/thermostats/device_id").
    with(
       headers: {
        'Authorization'=>'Bearer foo',
        'Content-Type'=>'application/json',
       }).
     to_return(status: 200, body: "", headers: {})
  end

  def stub_all_request_success
    stub_request(:get, "https://developer-api.nest.com/devices/thermostats").
      with(
        headers: {
          'Authorization'=>'Bearer foo',
          'Content-Type'=>'application/json',
        }).
      to_return(status: 200, body: "", headers: {})
  end
end
