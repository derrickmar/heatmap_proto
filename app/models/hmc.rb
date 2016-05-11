class Hmc
  def self.two_by_two(twod_array)
    puts "in here?"
    print twod_array
    WebsocketRails[:hmc].trigger 'two_by_two', twod_array
  end
end

# WebsocketRails[:hmc].trigger 'two_by_two', "adsf"
