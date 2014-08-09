require "spec_helper"

describe SocialCoffee::Client do
    before :all do 
        @client = SocialCoffee::Client.new 
        @client.open
    end

    after :all do
        @client.close
    end

    describe :respond_to do
        subject { @client }

        it { should respond_to :open }
        it { should respond_to :close }

        it { should respond_to :ping }
        it { should respond_to :get_friends }
        it { should respond_to :create_friendship }
        it { should respond_to :remove_friendship }
    end

    describe :ping do
        it 'should return pong string' do
            @client.ping
        end
    end

    describe :get_friends do
    end

    describe :create_friendship do
    end

    describe :remove_friendship do
    end
end 