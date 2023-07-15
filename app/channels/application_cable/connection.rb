module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
      puts "=== Connect ==="
      puts uuid
    end

    def disconnect
      puts "=== Disconnect ==="
      puts uuid
    end
  end
end
