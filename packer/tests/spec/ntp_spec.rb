require 'spec_helper'

describe user('ec2-user') do
  it { should exist }
end

describe user('ec2-user') do
  it { should belong_to_group 'ec2-user' }
end
