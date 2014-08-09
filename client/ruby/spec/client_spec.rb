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
            describe 'user without friends' do 
                it 'should return an array' do
                    expect(@client.get_friends(user)).to be_instance_of(Array)
                end

                it 'should return an empty array' do
                    expect(@client.get_friends(user)).to be_empty
                end
            end

            describe 'user with friends' do
                let(:user_a) { 1 }
                let(:user_b) { 2 }

                before :each do
                    @client.create_friendship user_a, user_b
                end

                after :each do
                    @client.remove_friendship user_a, user_b
                end

                it 'should return an array' do
                    expect(@client.get_friends(user_a)).to be_instance_of(Array)
                end

                it 'should return one element' do
                    expect(@client.get_friends(user_a).length).to eq(1)
                end

                it 'should return user_b id' do
                    expect(@client.get_friends(user_a).first).to eq(user_b)
                end
            end
        end
    end

    describe :create_friendship do
        let(:user_a) { 1 }
        let(:user_b) { 2 }

        describe 'invalid calls' do
            it 'should raise error if any argument is null' do
                expect{ @client.create_friendship nil, user_b }.to raise_error
                expect{ @client.create_friendship user_a, nil }.to raise_error
            end

            it 'should raise error if any argument has non positive integer value' do
                expect{ @client.create_friendship -user_a, user_b }.to raise_error
                expect{ @client.create_friendship user_a, -user_b }.to raise_error
            end

            it 'should raise error if both arguments are equal' do
                expect{ @client.create_friendship user_a, user_a }.to raise_error
            end
        end

        describe 'valid calls' do
            describe 'users are not friends' do
                after :each do 
                    @client.remove_friendship user_a, user_b
                end

                it 'should return true' do
                    expect(@client.create_friendship(user_a, user_b)).to eq(true)
                end
            end

            describe 'users are already friends' do
                before :each do 
                    @client.create_friendship user_a, user_b
                end

                after :each do 
                    @client.remove_friendship user_a, user_b
                end

                it 'should return false' do
                    expect(@client.create_friendship(user_a, user_b)).to eq(false)
                end
            end
        end
    end

    describe :remove_friendship do
    end
end 