require 'spec_helper'

describe 'haveged::service' do

  context 'with default parameters' do
    it {
      should contain_service('haveged').with(
               'ensure' => 'running',
               'enable' => 'true',
               'name'   => 'haveged',
             )
    }
  end

  context 'with defined parameters' do
    let :params do
      {
        :service_name   => 'foobar',
        :service_enable => 'foo',
        :service_ensure => 'bar',
      }
    end

    it {
      should contain_service('haveged').with(
               'ensure' => 'bar',
               'enable' => 'foo',
               'name'   => 'foobar',
             )
    }
  end
end
