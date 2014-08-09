require 'spec_helper'

describe 'Connection helper' do
    describe :connect do
        describe 'call without block' do
            it 'should return open Client instance' do
                client = SocialCoffee.connect 
                expect(client).not_to be nil
                expect(client).to be_instance_of SocialCoffee::Client
                expect(client.open?).to be true

                client.close
            end
        end

        describe 'call with a block' do
            it 'should return closed connenction' do
                client = SocialCoffee.connect { |client|  }

                expect(client).not_to be nil
                expect(client).to be_instance_of SocialCoffee::Client
                expect(client.open?).to be false
            end

            it 'should yield open connection to block' do
                SocialCoffee.connect do |client|
                    expect(client).not_to be nil
                    expect(client.open?).to be true
                end
            end
        end
    end
end