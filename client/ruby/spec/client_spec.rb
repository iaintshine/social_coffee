require "spec_helper"

describe SocialCoffee::Client do
    describe :respond_to do
        it { should respond_to :open }
        it { should respond_to :close }
    end

    describe :ping do
    end

    describe :get_friends do
    end

    describe :create_friendship do
    end

    describe :remove_friendship do
    end
end 