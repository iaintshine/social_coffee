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
            expect(@client.ping).to eq("pong")
        end
    end

    describe :get_friends do
        let(:user) { 1 }

        describe 'invalid calls' do
            it 'should raise error if null' do
                expect{ @client.get_friends nil }.to raise_error 
            end

            it 'should raise error if non positive integer value' do
                expect{ @client.get_friends -user }.to raise_error
            end
        end

        describe 'valid call' do
            it 'should return an array with ids' do
                expect(@client.get_friends(user)).to be_instance_of(Array)
            end
        end
    end

    describe :create_friendship do

    end

    describe :remove_friendship do
    end
end 