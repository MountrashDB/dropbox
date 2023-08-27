module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
    end

    def disconnect
    end
  end
end
